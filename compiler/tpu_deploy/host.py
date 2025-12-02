
import argparse
import os
import time
import numpy as np
from pynq import Overlay, allocate

REG_ADDR = {
    "tpu_mode":        0x00,
    "instr_ready":  0x04,
    "stream_ready": 0x08,
    "addr_ram":       0x0C,
    "length":       0x18,
}

WRITE_BRAM = 1
READ_BRAM  = 2
COMPUTE    = 3
WRITE_IRAM = 4

def wait_for_flag(mmio, name, expected=1, poll_delay=0.001):
    offset = REG_ADDR[name]
    while mmio.read(offset) != expected:
        time.sleep(poll_delay)

# --- Auto-injected ---
LOADS = [(0, 16, [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]), (16, 16, [1.0, 0.0, 2.0, 1.0, 3.0, 1.0, 0.0, 4.0, 5.0, 2.0, 1.0, 0.0, 1.0, 1.0, 3.0, 2.0])]
STORES = [(32, 16, 'output')]

def write_bram(mmio, dma, addr, values):
    in_buf = allocate(shape=values.shape, dtype=np.int64)
    value_bits = values.view(np.uint32)
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_ram"], addr)
    mmio.write(REG_ADDR["length"], values.size)
    mmio.write(REG_ADDR["tpu_mode"], WRITE_BRAM)

    wait_for_flag(mmio, "stream_ready", 1)
    in_buf[:] = value_bits.astype(np.uint64)
    dma.sendchannel.transfer(in_buf)
    dma.sendchannel.wait()
    wait_for_flag(mmio, "instr_ready", 1)
    in_buf.freebuffer()
    mmio.write(REG_ADDR["tpu_mode"], 0)

def read_bram(mmio, dma, addr, length):

    out_buf = allocate(shape=(length,), dtype=np.float32)
    # wait_for_flag(mmio, "stream_ready", 1)
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_ram"], addr)
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["tpu_mode"], READ_BRAM)

    dma.recvchannel.transfer(out_buf)
    dma.recvchannel.wait()

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["tpu_mode"], 0)

    arr = np.copy(out_buf)
    out_buf.freebuffer()
    return arr

def main():
    parser = argparse.ArgumentParser(description="PYNQ host program to test TPU (write, compute, read)")
    parser.add_argument("bitstream", type=str, help="Path to TPU bitstream (.bit)")
    parser.add_argument("instr_file")
    args = parser.parse_args()

    bit_path = args.bitstream
    instructions = args.instr_file

    if not os.path.exists(bit_path):
        raise FileNotFoundError(f"Cannot find {bit_path}")
    hwh_path = os.path.splitext(bit_path)[0] + ".hwh"
    if not os.path.exists(hwh_path):
        raise FileNotFoundError(f"Missing .hwh for overlay: {hwh_path}")

    print(f"Programming FPGA with {bit_path}")
    ol = Overlay(args.bitstream)
    ol.download()

    dma = ol.axi_dma_0
    ctrl = ol.tpu_top_v6_0
    mmio = ctrl.mmio

    base = 0x0000

    for (addr, length, value) in LOADS:
        write_bram(mmio, dma, addr, np.array(value, dtype=np.float32).reshape(-1))
    
    print("loading data complete")

    instrs = []
    with open(instructions) as f:
        for line in f:
            instrs.append(int(line, 16))
    instrs_np = np.array(instrs, dtype=np.uint64)

    instr_buf = allocate(shape=instrs_np.shape, dtype=np.uint64)
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_ram"], base)
    mmio.write(REG_ADDR["length"], len(instrs_np))
    mmio.write(REG_ADDR["tpu_mode"], WRITE_IRAM)
    wait_for_flag(mmio, "stream_ready", 1)
    instr_buf[:] = instrs_np
    dma.sendchannel.transfer(instr_buf)
    dma.sendchannel.wait()
    wait_for_flag(mmio, "instr_ready", 1)
    print("writing instructions complete")
    mmio.write(REG_ADDR["tpu_mode"], 0)
    instr_buf.freebuffer()


    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["tpu_mode"], COMPUTE)
    wait_for_flag(mmio, "instr_ready", 1)
    print("compute complete")
    mmio.write(REG_ADDR["tpu_mode"], 0)

    for (addr, length, label) in STORES:
        out = read_bram(mmio, dma, addr, length)
        print(f"{label} = {out}")
    print("storing complete")

if __name__ == "__main__":
    main()

