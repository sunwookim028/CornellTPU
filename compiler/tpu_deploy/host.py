
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
LOADS = [(0, 1, [0.0]), (217, 1, [0.0]), (250, 1, [0.625]), (251, 1, [0.125]), (252, 1, [0.25]), (17, 16, [2.0024421215057373, 0.1374831348657608, 0.23564091324806213, 0.05563409999012947, 1.3201143741607666, 0.4689483046531677, -1.0108745098114014, 1.1198853254318237, 0.46716827154159546, -0.7011154294013977, 0.752327024936676, 2.2817115783691406, -0.29726994037628174, 1.3216279745101929, -0.163315087556839, -1.1148940324783325]), (1, 16, [-0.13733254373073578, -0.638226330280304, 1.3012895584106445, 1.0006968975067139, 0.3418624997138977, -0.699691116809845, 2.366413116455078, -1.407938838005066, 0.7109388113021851, 0.49534353613853455, -0.5755569338798523, 0.731464684009552, -1.056182861328125, -0.42905864119529724, 1.2012913227081299, -1.2550355195999146]), (65, 4, [0.06730744242668152, 0.8856136202812195, 0.3337476849555969, 0.11382734775543213]), (101, 16, [-0.017836933955550194, 1.7047678232192993, -1.0170084238052368, 0.4794759750366211, 2.399348497390747, 0.9598559737205505, 0.7057144641876221, 0.7034816741943359, 0.5324989557266235, -1.1705070734024048, 0.8591910600662231, 0.9599936604499817, -1.7139012813568115, 2.474431037902832, -0.1700378656387329, 0.06514523923397064])]
STORES = [(1, 16, 'X'), (17, 16, 'W'), (33, 16, 'Z'), (49, 16, 'W.T'), (69, 16, 'Y'), (85, 16, 'A'), (117, 16, 'dA'), (133, 16, 'dZ'), (234, 16, 'relu_deriv'), (149, 16, 'dW'), (165, 4, 'db'), (169, 16, 'dX'), (233, 1, 'loss')]

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

