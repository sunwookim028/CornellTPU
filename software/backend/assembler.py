import sys
import ast
import os
import shutil
import numpy as np

HOST_TEMPLATE = """
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
LOADS = __LOADS__
STORES = __STORES__

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

"""

OPCODES_VPU = {
    "add": 0,
    "sub": 1,
    "relu": 2,
    "mul": 3,
    "relu_derivative": 4,
}

MODE_VPU      = 0
MODE_SYSTOLIC = 1
MODE_VADD     = 2
MODE_HALT     = 3

ADDR_BITS   = 13
LEN_BITS    = 23
OPCODE_BITS = 10

ADDR_MAX   = (1 << ADDR_BITS) - 1
LEN_MAX    = (1 << LEN_BITS) - 1
OPCODE_MAX = (1 << OPCODE_BITS) - 1

LOADS = []
STORES = []

LOADS_OPTIMIZED = []
STORES_OPTIMIZED = []

MEMORY_SIZE = 8192  


def check_addr(addr: int, label: str):
    if not (0 <= addr <= ADDR_MAX):
        raise ValueError(f"{label} address {addr} out of range (0..{ADDR_MAX})")
    return addr


def encode_vpu(op: str, addr_a: int, addr_b: int, addr_out: int, addr_const: int = 0):
    opcode = OPCODES_VPU[op]
    check_addr(addr_a, "addr_a")
    check_addr(addr_b, "addr_b")
    check_addr(addr_out, "addr_out")
    check_addr(addr_const, "addr_const")

    word = 0
    word |= (MODE_VPU & 0b11) << 62
    word |= (addr_a & ADDR_MAX) << 49
    word |= (addr_b & ADDR_MAX) << 36
    word |= (addr_out & ADDR_MAX) << 23
    word |= (addr_const & ADDR_MAX) << 10
    word |= (opcode & OPCODE_MAX)

    return word


def encode_systolic(addr_a: int, addr_b: int, addr_out: int, length: int):
    check_addr(addr_a, "addr_a")
    check_addr(addr_b, "addr_b")
    check_addr(addr_out, "addr_out")
    if not (0 <= length <= LEN_MAX):
        raise ValueError(f"length {length} out of range")

    word = 0
    word |= (MODE_SYSTOLIC & 0b11) << 62
    word |= (addr_a & ADDR_MAX) << 49
    word |= (addr_b & ADDR_MAX) << 36
    word |= (addr_out & ADDR_MAX) << 23
    word |= (length & LEN_MAX)

    return word


def encode_halt():
    word = 0
    word |= (MODE_HALT & 0b11) << 62
    return word


def parse_int_token(tok: str) -> int:
    tok = tok.strip().rstrip(",")
    if tok.startswith("0x") or tok.startswith("0X"):
        return int(tok, 16)
    return int(tok)


def assemble_line(line: str, matmul_len: int = 16):
    line = line.strip()
    if not line or line.startswith("#"):
        return None
    
    
    parts = line.split(maxsplit=1)
    op = parts[0].lower()

      # ----------- LOAD HANDLING ----------
    if op == "load":
        # Format: load <addr>, <length>, <python_literal>

        addr_str, length_str, values_str = parts[1].split(",", 2)
        addr = parse_int_token(addr_str)
        length = parse_int_token(length_str)
        values = ast.literal_eval(values_str.strip())
        LOADS.append((addr, length, values))
        return None

    # ----------- STORE HANDLING ----------
    if op == "store":

        addr_str, length_str, label_str = parts[1].split(",", 2)
        addr = parse_int_token(addr_str)
        length = parse_int_token(length_str)
        label = label_str.strip()

        STORES.append((addr, length, label))
        return None

    tokens = line.split()
    op = parts[0].lower()
    operands = [parse_int_token(p) for p in tokens[1:]]
    

    if op == "matmul":
        if len(operands) != 3:
            raise ValueError(f"matmul expects 3 operands: {line}")
        return encode_systolic(*operands, matmul_len)

    if op == "halt":
        return encode_halt()

    if op in OPCODES_VPU:
        if len(operands) != 3:
            raise ValueError(f"{op} expects 3 operands: {line}")
        return encode_vpu(op, *operands)

    raise ValueError(f"Unknown op: {op}")

def generate_memory_image(LOADS):

    max_addr = 0
    for addr, length, _ in LOADS:
        max_addr = max(max_addr, addr + length)

    memory = [0.0] * max_addr

    for addr, length, values in LOADS:
        memory[addr:addr+length] = values

    return memory, max_addr

def generate_host_py(host_path, loads, stores):
    with open(host_path, "w") as f:
        template = HOST_TEMPLATE.replace(
            "__LOADS__", repr(loads)
        ).replace(
            "__STORES__", repr(stores)
        )
        f.write(template)


def assemble_file(input_path: str, output_path: str, matmul_len: int = 16):
    with open(input_path, "r") as f:
        lines = f.readlines()

    assembled_words = []

    for line in lines:
        encoded = assemble_line(line, matmul_len)
        if encoded is not None:
            assembled_words.append(encoded)

    # Always append HALT as the final instruction
    assembled_words.append(encode_halt())

    with open(output_path, "w") as f:
        for word in assembled_words:
            f.write(f"{word:016X}\n")

    print(f"Assembly complete. Wrote {len(assembled_words)} instructions to {output_path}")

    # optimization with linear memory allocation
    data_stream, size = generate_memory_image(LOADS)

    loads = [(0, size, data_stream)]

    generate_host_py("host.py", loads, STORES)

    # deploys files to folder tpu_deploy
    deploy_dir = os.path.join(os.path.dirname(output_path), "tpu_deploy")

    if not os.path.exists(deploy_dir):
        raise FileNotFoundError(f"tpu_deploy folder not found: {deploy_dir}")

    # Overwrite files inside tpu_deploy
    instr_dest = os.path.join(deploy_dir, os.path.basename(output_path))
    host_dest = os.path.join(deploy_dir, "host.py")

    shutil.copy2(output_path, instr_dest)
    shutil.copy2("host.py", host_dest)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python assemble.py input.txt output.txt")
        sys.exit(1)

    assemble_file(sys.argv[1], sys.argv[2])
