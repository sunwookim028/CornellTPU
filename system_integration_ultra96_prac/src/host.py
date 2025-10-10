# host python code for ps side for const_driver ip
# based on Yixiao's host.py from the ultra96 example 
# future: make const value writeable, replace size arg

import argparse, time, pynq, os
import numpy as np

from pynq.buffer import PynqBuffer

def main():
    parser = argparse.ArgumentParser(description="Host Program for Constant Driver IP")
    parser.add_argument("bitstream", type=str, help="Path to the bitstream file")
    args = parser.parse_args()
    bitstream_path:str = args.bitstream
    if not os.path.exists(bitstream_path):
        raise FileNotFoundError(f"Cannot find the bitstream file at {bitstream_path}")
    hwh_path = os.path.splitext(bitstream_path)[0] + ".hwh"
    if not os.path.exists(hwh_path):
        raise FileNotFoundError(f"Cannot find the hwh file at {hwh_path}")

    print(f"Programming hardware with bitstream {bitstream_path}")
    overlay = pynq.Overlay(bitstream_path)
    const_driver = overlay.const_driver_0

    print(f"Running const_driver")


     # read const value
    value = const_driver.read(0x0)  # offset depends on reg mapping in ip ?
    print(f"Read constant value from hardware: 0x{value:08X}")

    # poll/check value periodically
    for i in range(5):
        val = const_driver.read(0x0)
        print(f"[{i}] Value = 0x{val:08X}")
        time.sleep(0.5)

    print("Done.")


if __name__ == "__main__":
    main()