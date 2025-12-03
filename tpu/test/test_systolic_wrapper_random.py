import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import numpy as np
import random

# ----------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------

def to_fixed(val, frac_bits=8):
    """Convert float to 16-bit fixed-point with given fractional bits."""
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF

def from_fixed(val, frac_bits=8):
    """Convert 16-bit fixed-point back to float."""
    if val & 0x8000:
        val -= 0x10000
    return float(val) / (1 << frac_bits)


async def reset_dut(dut):
    dut.rst.value = 1
    dut.start.value = 0
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

# ----------------------------------------------------------------------
# Randomized test suite
# ----------------------------------------------------------------------

@cocotb.test()
async def test_systolic_wrapper_random(dut):
    """
    Run multiple random 4x4 matrix multiplications and verify correctness.
    """

    # Clock setup (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    N = 4
    FRAC_BITS = 8
    NUM_TESTS = 50   # Number of random trials
    VALUE_RANGE = (-2.0, 2.0)  # Range of float values to test

    dut._log.info(f"Starting {NUM_TESTS} randomized systolic array tests...")

    for test_idx in range(NUM_TESTS):
        # --------------------------------------------------------------
        # Generate random test matrices
        # --------------------------------------------------------------
        X = np.random.uniform(*VALUE_RANGE, size=(N, N)).astype(float)
        W = np.random.uniform(*VALUE_RANGE, size=(N, N)).astype(float)
        expected = np.round(X @ W.T, 2)

        # --------------------------------------------------------------
        # Drive inputs
        # --------------------------------------------------------------
        for i in range(N):
            for j in range(N):
                dut.x_matrix[i*N + j].value = to_fixed(X[i][j], FRAC_BITS)
                dut.weight_matrix[i*N + j].value = to_fixed(W[i][j], FRAC_BITS)

        await RisingEdge(dut.clk)

        # --------------------------------------------------------------
        # Start computation
        # --------------------------------------------------------------
        dut.start.value = 1
        await RisingEdge(dut.clk)
        dut.start.value = 0

        # --------------------------------------------------------------
        # Wait for 'done'
        # --------------------------------------------------------------
        timeout_cycles = 200
        for _ in range(timeout_cycles):
            await RisingEdge(dut.clk)
            if dut.done.value:
                break
        else:
            raise cocotb.result.TestFailure(f"Timeout on test {test_idx+1}")

        # --------------------------------------------------------------
        # Read outputs
        # --------------------------------------------------------------
        out = np.zeros((N, N), dtype=float)
        for i in range(N):
            for j in range(N):
                out[i][j] = round(from_fixed(int(dut.out_matrix[i*N + j].value), FRAC_BITS), 2)

        # --------------------------------------------------------------
        # Check results
        # --------------------------------------------------------------
        if not np.allclose(out, expected, atol=0.02):
            dut._log.error(f"Test {test_idx+1} FAILED")
            dut._log.error(f"Expected:\n{expected}")
            dut._log.error(f"Got:\n{out}")
            raise cocotb.result.TestFailure(f"Matrix multiply mismatch on test {test_idx+1}")

        # Reset for next test
        await reset_dut(dut)

    dut._log.info("All randomized tests passes successfully.")
