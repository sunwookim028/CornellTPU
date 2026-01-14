
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
LOADS = [(0, 253, [0.0, 1.4192051887512207, -0.29870572686195374, 0.9025493860244751, -2.28082537651062, -1.0534303188323975, -2.090635299682617, 1.585089087486267, -1.2007927894592285, 0.028758525848388672, 0.2741258442401886, -0.8385756015777588, 0.6660357713699341, -0.09974239021539688, -1.0992021560668945, 0.5265140533447266, -0.3951014578342438, -1.1574026346206665, 0.07047610729932785, 0.44022488594055176, -1.8328938484191895, 1.0582157373428345, 0.27812910079956055, -1.1386216878890991, -0.49134179949760437, 0.6028213500976562, -0.04403959959745407, 0.7900022268295288, 0.013325640000402927, 0.513105034828186, 1.6035252809524536, -1.516037940979004, 0.1341216117143631, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.8402794599533081, -1.477299690246582, -2.0134668350219727, 0.4641053080558777, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.4335382282733917, 1.2868770360946655, -0.9768239855766296, 1.3236647844314575, -1.3845869302749634, 1.2148914337158203, -0.28488320112228394, -0.9699869155883789, -0.004887710325419903, -0.48199671506881714, -0.03309726342558861, -0.27854710817337036, -0.6906055212020874, 0.49702075123786926, -0.33838170766830444, -0.8278400897979736, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0625, 0.125, 0.25])]
STORES = [(1, 16, 'X'), (17, 16, 'W'), (33, 16, 'Z'), (65, 4, 'b'), (49, 16, 'W.T'), (69, 16, 'Y'), (85, 16, 'A'), (185, 16, 'diff'), (201, 16, 'sqaured'), (117, 16, 'dA'), (133, 16, 'dZ'), (149, 16, 'dW'), (165, 4, 'db'), (169, 16, 'dX'), (233, 1, 'loss')]

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

    bench = {
        "load_time": 0.0,
        "write_iram_time": 0.0,
        "compute_time": 0.0,
        "store_time": 0.0,
        "total_time": 0.0
    }

    overall_start = time.perf_counter()

    t0 = time.perf_counter()
    for (addr, length, value) in LOADS:
        write_bram(mmio, dma, addr, np.array(value, dtype=np.float32).reshape(-1))
    bench["load_time"] = time.perf_counter() - t0
    print("loading data complete")

    instrs = []
    with open(instructions) as f:
        for line in f:
            instrs.append(int(line, 16))
    instrs_np = np.array(instrs, dtype=np.uint64)

    instr_buf = allocate(shape=instrs_np.shape, dtype=np.uint64)
    
    t0 = time.perf_counter()
    
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_ram"], base)
    mmio.write(REG_ADDR["length"], len(instrs_np))
    mmio.write(REG_ADDR["tpu_mode"], WRITE_IRAM)
    wait_for_flag(mmio, "stream_ready", 1)
    instr_buf[:] = instrs_np
    dma.sendchannel.transfer(instr_buf)
    dma.sendchannel.wait()
    wait_for_flag(mmio, "instr_ready", 1)

    bench["write_iram_time"] = time.perf_counter() - t0
    print("writing instructions complete")

    mmio.write(REG_ADDR["tpu_mode"], 0)
    instr_buf.freebuffer()


    t0 = time.perf_counter()

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["tpu_mode"], COMPUTE)
    wait_for_flag(mmio, "instr_ready", 1)

    bench["compute_time"] = time.perf_counter() - t0
    print("compute complete")

    mmio.write(REG_ADDR["tpu_mode"], 0)

    
    # Compute overall read window
    min_addr = min(addr for (addr, _, _) in STORES)
    max_addr = max(addr + (length) for (addr, length, _) in STORES)
    total_len = max_addr - min_addr

    # Single DMA read
    t0 = time.perf_counter()
    merged = read_bram(mmio, dma, min_addr, total_len + 1) # idk why but the +1 fixes the bus error bug somehow
    bench["store_time"] = time.perf_counter() - t0

    for (addr, length, label) in STORES:
        start = addr - min_addr
        end = start + length
        out = merged[start:end]
        print(f"{label} = {out}")

    print("storing complete")
    bench["total_time"] = time.perf_counter() - overall_start
    print("===== BENCHMARK RESULTS =====")
    for key, val in bench.items():
        print(f"{key}: {val*1000:.3f} ms")

if __name__ == "__main__":
    main()

