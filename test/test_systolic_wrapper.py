import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import numpy as np

def to_fixed(val, frac_bits=8):
    """Convert a float to 16-bit fixed point with 8 fractional bits."""
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF


def from_fixed(val, frac_bits=8):
    """Convert 16-bit fixed-point with 8 fractional bits to float."""
    # Convert from 16-bit signed integer
    if val & 0x8000:  # if sign bit is set
        val = val - 0x10000
    return float(val) / (1 << frac_bits)

@cocotb.test()
async def test_systolic_wrapper(dut):
    """Test the top-level systolic_wrapper module for a 4×4 multiply"""

    # ------------------------------------------------------------------
    # Setup
    # ------------------------------------------------------------------
    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.start.value = 0
    await Timer(20, units="ns")
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # ------------------------------------------------------------------
    # Define test matrices
    # ------------------------------------------------------------------
    N = 4
    DATA_WIDTH = 16

    X = np.array([
        [0.1, 0.2, 0.3, 0.4],
        [0.5, 0.6, 0.7, 0.8],
        [0.9, 1.0, 1.1, 1.2],
        [1.3, 1.4, 1.5, 1.6]
        ], dtype = float)

    W = np.array([
        [1.0, 1.1, 1.2, 1.3],
        [2.0, 2.1, 2.2, 2.3],
        [1.4, 1.5, 1.6, 1.7],
        [2.4, 2.5, 2.6, 2.7]
        ], dtype = float)

    expected = X @ W.T


    # ------------------------------------------------------------------
    # Drive matrices into the wrapper inputs
    # ------------------------------------------------------------------
    for i in range(N):
        for j in range(N):
            dut.weight_matrix[i*N + j].value = to_fixed(W[i][j])
            dut.x_matrix[i*N + j].value = to_fixed(X[i][j])

    await RisingEdge(dut.clk)

    # ------------------------------------------------------------------
    # Start computation
    # ------------------------------------------------------------------
    dut._log.info("Pulsing start...")
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # ------------------------------------------------------------------
    # Wait for done
    # ------------------------------------------------------------------
    timeout_cycles = 200
    for _ in range(timeout_cycles):
        await RisingEdge(dut.clk)
        if dut.done.value:
            dut._log.info(f"Done signal asserted at cycle {_}")
            break
    else:
        raise cocotb.result.TestFailure("Timeout waiting for done signal")

    # ------------------------------------------------------------------
    # Capture output matrix
    # ------------------------------------------------------------------
    out = np.array([
        [0.,0.,0.,0.],
        [0.,0.,0.,0.],
        [0.,0.,0.,0.],
        [0.,0.,0.,0.]
        ], dtype = float)
    for i in range(N):
        for j in range(N):
            out[i][j] = round(from_fixed(dut.out_matrix[i*N + j].value), 2) # Adjust rounding as needed

    dut._log.info("Output matrix:")
    for r in out:
        dut._log.info(str(r))

    # ------------------------------------------------------------------
    # Verify
    # ------------------------------------------------------------------

    if (out.all() != expected.all()):
        dut._log.error(f"Expected:\n{expected}")
        raise cocotb.result.TestFailure("Matrix multiply mismatch")
    else:
        dut._log.info("Matrix multiply PASSED.")
