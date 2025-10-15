import argparse, time, pynq, os
import numpy as np

from pynq.buffer import PynqBuffer
# Load bitstream
ol = Overlay("/home/xilinx/fifo_overlay.bit")
fifo_ip = ol.my_fifo_ip_0  # Name as seen in Vivado block design
dma = ol.axi_dma_0          # stream data via dma?

# Prepare test data
N = 16
in_buffer = allocate(shape=(N,), dtype=np.uint32)
out_buffer = allocate(shape=(N,), dtype=np.uint32)
in_buffer[:] = np.arange(N, dtype=np.uint32)

# ---- Test 1: Bypass mode ----
fifo_ip.register_map.enable_bypass = 1
fifo_ip.register_map.data_mod = 0
fifo_ip.register_map.ctrl_start = 1

dma.sendchannel.transfer(in_buffer)
dma.recvchannel.transfer(out_buffer)
dma.sendchannel.wait()
dma.recvchannel.wait()

print("Bypass mode input :", in_buffer)
print("Bypass mode output:", out_buffer)
assert np.array_equal(in_buffer, out_buffer), "Bypass test failed!"

# ---- Test 2: Modifier mode ----
fifo_ip.register_map.enable_bypass = 0
fifo_ip.register_map.data_mod = 10
fifo_ip.register_map.ctrl_start = 1

dma.sendchannel.transfer(in_buffer)
dma.recvchannel.transfer(out_buffer)
dma.sendchannel.wait()
dma.recvchannel.wait()

expected = in_buffer + 10
print("Modifier mode output:", out_buffer)
assert np.array_equal(expected, out_buffer), "Modifier test failed!"

