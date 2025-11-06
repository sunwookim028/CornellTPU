import argparse
import time
import numpy as np
from pynq import Overlay, allocate
import os

# AXI-Lite register map offsets (in bytes)
REG_ADDR = {
    "instr":       0x00,  # 0=write_bram, 1=read_bram, 2=compute
    "instr_ready": 0x04,
    "stream_ready":0x08,
    "addr_a":      0x0C,
    "addr_b":      0x10,
    "addr_out":    0x14,
    "length":      0x18,
}

# Instruction opcodes
WRITE_BRAM = 0
READ_BRAM  = 1
COMPUTE    = 2


def wait_for_flag(mmio, name, expected=1, poll_delay=0.001):
    """Poll a register until it matches the expected value."""
    offset = REG_ADDR[name]
    while mmio.read(offset) != expected:
        time.sleep(poll_delay)


def main():
    parser = argparse.ArgumentParser(description="PYNQ host program to test TPU (write, compute, read)")
    parser.add_argument("bitstream", type=str, help="Path to TPU bitstream (.bit)")
    parser.add_argument("--length", type=int, default=16, help="Number of 32-bit words to process")
    args = parser.parse_args()

    bit_path = args.bitstream
    length = args.length

    if not os.path.exists(bit_path):
        raise FileNotFoundError(f"Cannot find {bit_path}")
    hwh_path = os.path.splitext(bit_path)[0] + ".hwh"
    if not os.path.exists(hwh_path):
        raise FileNotFoundError(f"Missing .hwh for overlay: {hwh_path}")

    print(f"Programming FPGA with {bit_path}")
    ol = Overlay(bit_path)
    ol.download()

    # Components
    dma = ol.axi_dma_0
    ctrl = ol.tpu_top_0  # your AXI-lite control IP instance name
    mmio = ctrl.mmio

    # Buffers
    a = np.random.randint(0, 100, length, dtype=np.uint32)
    b = np.random.randint(0, 100, length, dtype=np.uint32)
    in_buf = allocate(shape=(length,), dtype=np.uint32)
    out_buf = allocate(shape=(length,), dtype=np.uint32)

    mmio.write(0x00, 0xABCD)
    print(hex(mmio.read(0x00))+ "\n")
    print(hex(mmio.read(0x04))+ "\n")
    print(hex(mmio.read(0x08))+ "\n")
    print(hex(mmio.read(0x0C))+ "\n")
    print(hex(mmio.read(0x10))+ "\n")
    print(hex(mmio.read(0x14))+ "\n")
    print(hex(mmio.read(0x18)))
    print("\n--- Stage 1: Write vectors to BRAM via DMA ---")
    # wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], 0x0000)   # BRAM base A
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], WRITE_BRAM)

    # wait until stream ready to accept DMA data
    # wait_for_flag(mmio, "stream_ready", 1)

    # Send A first
    in_buf[:] = a
    dma.sendchannel.transfer(in_buf)
    dma.sendchannel.wait()

    # Send B
    in_buf[:] = b
    dma.sendchannel.transfer(in_buf)
    dma.sendchannel.wait()

    print("Write to BRAM complete.")

    print("\n--- Stage 2: Compute ---")
    time.sleep(1)
    # wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], 0x0000)
    mmio.write(REG_ADDR["addr_b"], length)   # B vector stored right after A
    mmio.write(REG_ADDR["addr_out"], length * 2)
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], COMPUTE)

    print("Waiting for computation to finish...")
    time.sleep(2)
    # wait_for_flag(mmio, "instr_ready", 1)
    print("Computation done.")

    print("\n--- Stage 3: Read results from BRAM ---")
    time.sleep(2)
    # wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], length * 2)
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], READ_BRAM)
    # wait_for_flag(mmio, "stream_ready", 1)
    dma.recvchannel.transfer(out_buf)
    dma.recvchannel.wait()
    time.sleep(2)

    result = np.copy(out_buf)

    print("\nResults:")
    for i in range(length):
        print(f"A[{i}]={a[i]:>3}, B[{i}]={b[i]:>3}, OUT[{i}]={result[i]:>3}")

    # Additional verification:
    expected = (a + b) & 0xFFFFFFFF
    if np.array_equal(result, expected):
        print("\n✅ TPU compute test PASSED — results match expected values")
    else:
        print("\n❌ TPU compute test FAILED")
        for i in range(length):
            if result[i] != expected[i]:
                print(f"Mismatch at {i}: expected {expected[i]}, got {result[i]}")
                break


if __name__ == "__main__":
    main()
