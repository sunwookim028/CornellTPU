import argparse
import time
import numpy as np
from pynq import Overlay, allocate
import os


def main():
    parser = argparse.ArgumentParser(description="PYNQ host program for DMA ↔ loopback test")
    parser.add_argument("bitstream", type=str, help="Path to the loopback bitstream (.bit)")
    parser.add_argument("--size", type=int, default=16, help="Number of 32-bit words to transfer")
    args = parser.parse_args()

    bitstream_path = args.bitstream
    size = args.size

    if not os.path.exists(bitstream_path):
        raise FileNotFoundError(f"Cannot find bitstream file at {bitstream_path}")
    hwh_path = os.path.splitext(bitstream_path)[0] + ".hwh"
    if not os.path.exists(hwh_path):
        raise FileNotFoundError(f"Cannot find .hwh file at {hwh_path}")

    print(f"Programming FPGA with {bitstream_path}")
    overlay = Overlay(bitstream_path)
    overlay.download()

    # Locate DMA
    dma = overlay.axi_dma_0
    print("DMA loaded successfully")

    # Allocate contiguous buffers
    in_buffer = allocate(shape=(size,), dtype=np.uint32)
    out_buffer = allocate(shape=(size,), dtype=np.uint32)

    # Fill input with random data
    in_buffer[:] = np.random.randint(0, 2**32, size, dtype=np.uint32)

    print(f"Transferring {size} 32-bit words through DMA → loopback → DMA")

    # Start DMA transfers
    start_time = time.perf_counter()
    dma.sendchannel.transfer(in_buffer)
    dma.recvchannel.transfer(out_buffer)
    dma.sendchannel.wait()
    dma.recvchannel.wait()
    end_time = time.perf_counter()

    # Compare data
    if np.array_equal(in_buffer, out_buffer):
        print("Loopback test passed — data matches")
    else:
        print("Loopback test failed — data mismatch detected.")
        for i in range(size):
            if in_buffer[i] != out_buffer[i]:
                print(f"  Index {i}: sent=0x{in_buffer[i]:08X}, recv=0x{out_buffer[i]:08X}")
                break

    # Timing and bandwidth
    elapsed_ms = (end_time - start_time) * 1e3
    bytes_transferred = size * 4
    bandwidth_MBps = (bytes_transferred / 1e6) / (elapsed_ms / 1e3)
    print(f"DMA transfer time: {elapsed_ms:.3f} ms")
    print(f"Effective bandwidth: {bandwidth_MBps:.2f} MB/s")


if __name__ == "__main__":
    main()
