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
WRITE_BRAM = 1
READ_BRAM  = 2
COMPUTE    = 3


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
    ctrl = ol.tpu_top_v4_0  # your AXI-lite control IP instance name
    mmio = ctrl.mmio

    # testing writing and reading to brams
    a = np.random.randint(0, 100, length, dtype=np.uint32)
    b = np.random.randint(0, 100, length, dtype=np.uint32)
    in_buf = allocate(shape=(length,), dtype=np.uint32)
    out_buf = allocate(shape=(length,), dtype=np.uint32)

    print("\nWriting to BRAM")

    wait_for_flag(mmio, "instr_ready", 1)


    base = 0x0000
    # configure tpu to write_bram mode
    mmio.write(REG_ADDR["addr_a"], base)   # BRAM base A
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], WRITE_BRAM)

    # send data through dma
    wait_for_flag(mmio, "stream_ready", 1)
    in_buf[:] = a
    dma.sendchannel.transfer(in_buf)
    dma.sendchannel.wait()

    #instr_ready is raised when instruction is done
    wait_for_flag(mmio, "instr_ready", 1)
    # after ay instruction should always set instr back to IDLE state(0)
    mmio.write(REG_ADDR["instr"], 0) 

    print("\nReading results from BRAM")

    # wait until stream ready to accept DMA data
    wait_for_flag(mmio, "stream_ready", 1)

    # when reading from brams configure dma before configuring tpu (opposite to writing)
    
    dma.recvchannel.transfer(out_buf)


    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], base)
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], READ_BRAM)

    dma.recvchannel.wait()

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["instr"], 0)

    result = np.copy(out_buf)

    print("\nRead and Write to Bram Results:")
    for i in range(length):
        print(f"A[{i}]={a[i]:>3}, OUT[{i}]={result[i]:>3}")

    # Additional verification:
    expected = (a) & 0xFFFFFFFF
    if np.array_equal(result, expected):
        print("\n✅ TPU Read and Write test PASSED — results match expected values")
    else:
        print("\n❌ TPU compute test FAILED")
        for i in range(length):
            if result[i] != expected[i]:
                print(f"Mismatch at {i}: expected {expected[i]}, got {result[i]}")
                break

    print("\n Starting Compute Test Now: ")


    # Buffers
    a = np.random.randint(0, 100, length, dtype=np.uint32)
    b = np.random.randint(0, 100, length, dtype=np.uint32)
    in_buf = allocate(shape=(length,), dtype=np.uint32)
    out_buf = allocate(shape=(length,), dtype=np.uint32)

    # mmio.write(0x00, 0xABCD)
    # print(hex(mmio.read(0x00))+ "\n")
    # mmio.write(0x04, 0xABCD)
    # print(hex(mmio.read(0x04))+ "\n")
    # mmio.write(0x08, 0xABCD)
    # print(hex(mmio.read(0x08))+ "\n")
    # mmio.write(0x0C, 0xABCD)
    # print(hex(mmio.read(0x0C))+ "\n")
    # mmio.write(0x10, 0xABCD)
    # print(hex(mmio.read(0x10))+ "\n")
    # mmio.write(0x14, 0xABCD)
    # print(hex(mmio.read(0x14))+ "\n")
    # mmio.write(0x18, 0xABCD)
    # print(hex(mmio.read(0x18)))

    print("\n--- Stage 1: Write vectors to BRAM via DMA ---")

    wait_for_flag(mmio, "instr_ready", 1)

    print("\n ready for instruction")

    base = 0x0000
    # configure tpu to write_bram mode
    mmio.write(REG_ADDR["addr_a"], base)   # BRAM base A
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], WRITE_BRAM)
    # print(mmio.read(REG_ADDR["addr_a"]))   # BRAM base A
    # print(mmio.read(REG_ADDR["length"]))
    # print(mmio.read(REG_ADDR["instr"]))

    # send data through dma
    wait_for_flag(mmio, "stream_ready", 1)
    in_buf[:] = a
    dma.sendchannel.transfer(in_buf)
    dma.sendchannel.wait()

    #instr_ready is raised when instruction is done
    wait_for_flag(mmio, "instr_ready", 1)
    # after ay instruction should always set instr back to IDLE state(0)
    mmio.write(REG_ADDR["instr"], 0) 
    print("\n ready for instruction")
    #configure tpu again
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], base + length)   # BRAM base B
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], WRITE_BRAM)

    # print(mmio.read(REG_ADDR["addr_a"]))   
    # print(mmio.read(REG_ADDR["length"]))
    # print(mmio.read(REG_ADDR["instr"]))

    wait_for_flag(mmio, "stream_ready", 1)

    # Send B
    in_buf[:] = b
    # print("\n=== DMA Status BEFORE B transfer ===")
    # print("MM2S Control (0x00):", hex(mmio.read(0x00)))
    # print("MM2S Status  (0x04):", hex(mmio.read(0x04)))
    # print("instr_ready:", mmio.read(REG_ADDR["instr_ready"]))
    # print("stream_ready:", mmio.read(REG_ADDR["stream_ready"]))

    dma.sendchannel.transfer(in_buf)

    # print("\n=== DMA Status BEFORE wait() for B ===")
    # print("MM2S Status  (0x04):", hex(mmio.read(0x04)))

    dma.sendchannel.wait()

    # print("\n=== DMA Status AFTER wait() for B ===")
    # print("MM2S Status  (0x04):", hex(mmio.read(0x04)))
    # print("instr_ready:", mmio.read(REG_ADDR["instr_ready"]))
    # print("stream_ready:", mmio.read(REG_ADDR["stream_ready"]))

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["instr"], 0)
    print("Write to BRAM complete.")

    print("\n--- Stage 2: Compute ---")

    #configure TPU to Compute mode
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], base)
    mmio.write(REG_ADDR["addr_b"], base + length)   # B vector stored right after A
    mmio.write(REG_ADDR["addr_out"], base + (length * 2))
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], COMPUTE)

    # print(mmio.read(REG_ADDR["addr_a"]))
    # print(mmio.read(REG_ADDR["addr_b"])) 
    # print(mmio.read(REG_ADDR["addr_out"]))    
    # print(mmio.read(REG_ADDR["length"]))
    # print(mmio.read(REG_ADDR["instr"]))

    print("Waiting for computation to finish...")
    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["instr"], 0)
    print("Computation done.")

    print("\n--- Stage 3: Read results from BRAM ---")

    # wait_for_flag(mmio, "stream_ready", 1)
    # print("\n=== DMA Status BEFORE transfer ===")
    # print("S2MM Control (0x30):", hex(mmio.read(0x30)))
    # print("S2MM Status  (0x34):", hex(mmio.read(0x34)))
    # print("instr_ready:", mmio.read(REG_ADDR["instr_ready"]))
    # print("stream_ready:", mmio.read(REG_ADDR["stream_ready"]))


    # when reading from brams configure dma before configuring tpu (opposite to writing)
    dma.recvchannel.transfer(out_buf)

    # print("\n=== DMA Status BEFORE wait() ===")
    # print("S2MM Status  (0x34):", hex(mmio.read(0x34)))
    # print("S2MM Destination address (0x48):", hex(mmio.read(0x48)))

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["addr_a"], base + (length * 2))
    mmio.write(REG_ADDR["length"], length)
    mmio.write(REG_ADDR["instr"], READ_BRAM)

    # print(mmio.read(REG_ADDR["addr_a"]))   
    # print(mmio.read(REG_ADDR["length"]))
    # print(mmio.read(REG_ADDR["instr"]))

    dma.recvchannel.wait()

    # print("\n=== DMA Status AFTER wait() ===")
    # print("S2MM Status  (0x34):", hex(mmio.read(0x34)))
    # print("instr_ready:", mmio.read(REG_ADDR["instr_ready"]))
    # print("stream_ready:", mmio.read(REG_ADDR["stream_ready"]))

    wait_for_flag(mmio, "instr_ready", 1)
    mmio.write(REG_ADDR["instr"], 0)

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
