# test_systolic_wrapper_suite.py
# Run testing suite with cases defined in systolic_test_suite.py

import cocotb
from cocotb.triggers import RisingEdge, Timer
import numpy as np

import struct

from systolic_test_suite import TEST_CASES

DATAWIDTH = 32 # If this is changed, the add/mul units in pe.sv must be changed to fit new data type
N = 4

# Fixed-point helpers
def to_fixed(val, frac_bits=8):
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF

def from_fixed(val, frac_bits=8):
    return float(val) / (1 << frac_bits)

# FP32 Helper
def float_to_fp32_bits(val: float) -> int:
    """Convert Python float to 32-bit IEEE-754 single-precision bit pattern."""
    return struct.unpack(">I", struct.pack(">f", float(val)))[0]


async def run_single_test(dut, W, X, test_name):
    results = []

    # Reset
    dut.rst.value = 1
    dut.start_load.value = 0
    dut.start_compute.value = 0
    dut.start_store.value = 0
    await Timer(20, units="ns")
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Convert matrices to flat lists
    W_flat = W.flatten()
    X_flat = X.flatten()

    W_fixed = [float_to_fp32_bits(v) for v in W_flat]
    X_fixed = [float_to_fp32_bits(v) for v in X_flat]

    # Load into mock memory
    for i, val in enumerate(W_fixed):
        dut.mem_inst.weight_matrix[i].value = val
    for i, val in enumerate(X_fixed):
        dut.mem_inst.x_matrix[i].value = val

    # Run matmul by giving DUT start signals for each of the 3 stages

    # First load
    dut.start_load.value = 1
    await RisingEdge(dut.clk)
    dut.start_load.value = 0
    for _ in range(800):
        await RisingEdge(dut.clk)
        if int(dut.done_load.value) == 1:
            break
    else:
        assert False, f"[{test_name}] TIMEOUT in load"
    
    # Now compute
    dut.start_compute.value = 1
    await RisingEdge(dut.clk)
    dut.start_compute.value = 0
    for _ in range(800):
        await RisingEdge(dut.clk)
        if int(dut.done_compute.value) == 1:
            break
    else:
        assert False, f"[{test_name}] TIMEOUT in compute"

    # Finally, store
    dut.start_store.value = 1
    await RisingEdge(dut.clk)
    dut.start_store.value = 0
    for _ in range(800):
        await RisingEdge(dut.clk)

        # Capture write requests to mem
        if int(dut.mem_write_en.value) == 1:
            for i in range(int(dut.BANKING_FACTOR.value)):
                # We have to get creative w/ how we index the mem req data since
                # the earlier entries live at the higher indices in the output stream
                j = dut.BANKING_FACTOR.value - (i+1)
                # For fixed point:
                #results.append(from_fixed(int(dut.mem_req_data.value[DATAWIDTH*j:(DATAWIDTH*(j+1) - 1)].signed_integer)))
                # For floating point: Interpret output result as FP32 and cast to Python float
                output_bits = int(dut.mem_req_data.value[DATAWIDTH*j:(DATAWIDTH*(j+1) - 1)])
                results.append(struct.unpack(">f", struct.pack(">I", output_bits))[0])

        if int(dut.done_store.value) == 1:
            break
    else:
        assert False, f"[{test_name}] TIMEOUT in store"


    # Reshape results
    out_grid = np.array(results).reshape(N, N)

    # Expected output
    expected = X @ W.T

    # Compare with tolerance
    tol = 1e-1
    for idx, (o, e) in enumerate(zip(out_grid.flatten(), expected.flatten())):
        assert abs(o - e) <= tol, \
            f"[{test_name}] MISMATCH at {idx}: got {o}, expected {e}"

    dut._log.info(f"Test case [{test_name}] PASSED!")


@cocotb.test()
async def test_systolic_wrapper_suite(dut):
    """Run all directed + random tests."""

    for case in TEST_CASES:
        name = case["name"]
        W = case["W"]
        X = case["X"]

        #dut._log.info(f"--- Running test case: {name} ---")
        await run_single_test(dut, W, X, name)
