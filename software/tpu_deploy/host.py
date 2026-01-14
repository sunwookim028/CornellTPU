
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
LOADS = [(0, 1, [0.0]), (217, 1, [0.0]), (250, 1, [0.0625]), (251, 1, [0.125]), (252, 1, [0.25]), (17, 16, [-0.6157273054122925, -0.8532673120498657, 0.846603512763977, 0.24555155634880066, -0.027109621092677116, 0.13724546134471893, -1.372422218322754, -0.7323502898216248, 0.011781510896980762, 1.5158519744873047, 0.2315135896205902, 0.5745108723640442, 1.082961082458496, -2.2413995265960693, 0.5595777034759521, -1.0570253133773804]), (1, 16, [1.082766056060791, 1.27499520778656, -0.5501754283905029, 1.0163384675979614, 0.07839599996805191, -0.034628044813871384, 0.7430522441864014, -1.9831030368804932, -0.5077247619628906, -1.6506532430648804, -0.30850839614868164, 0.7162443399429321, -1.2786157131195068, -0.189548060297966, -1.02693510055542, 0.899297833442688]), (65, 4, [2.6693835258483887, -0.7779089212417603, -0.6129744052886963, -1.1968188285827637]), (101, 16, [1.2220115661621094, -1.1984094381332397, -1.861122488975525, 0.3849925100803375, 0.7721431851387024, -0.5748991966247559, -1.0003670454025269, 1.2401621341705322, 0.9175151586532593, -0.2041284441947937, 0.3352528512477875, -1.1656676530838013, -1.0598396062850952, 1.288211703300476, 0.1472133994102478, -1.7400456666946411])]
STORES = [(1, 16, 'X'), (17, 16, 'W'), (33, 16, 'Z'), (65, 4, 'b'), (49, 16, 'W.T'), (69, 16, 'Y'), (85, 16, 'A'), (185, 16, 'diff'), (201, 16, 'sqaured'), (117, 16, 'dA'), (133, 16, 'dZ'), (234, 16, 'relu_deriv'), (149, 16, 'dW'), (165, 4, 'db'), (169, 16, 'dX'), (233, 1, 'loss')]

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

    t0 = time.perf_counter()
    for (addr, length, label) in STORES:
        out = read_bram(mmio, dma, addr, length)
        print(f"{label} = {out}")
    bench["store_time"] = time.perf_counter() - t0
    print("storing complete")

    bench["total_time"] = time.perf_counter() - overall_start
    print("===== BENCHMARK RESULTS =====")
    for key, val in bench.items():
        print(f"{key}: {val*1000:.3f} ms")

if __name__ == "__main__":
    main()

