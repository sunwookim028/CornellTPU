import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import numpy as np


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

    # Random small integer matrices
    A = np.array([[1, 2, 3, 4],
                  [5, 6, 7, 8],
                  [9, 10, 11, 12],
                  [13, 14, 15, 16]], dtype=np.int32)

    B = np.array([[1, 0, 0, 0],
                  [0, 1, 0, 0],
                  [0, 0, 1, 0],
                  [0, 0, 0, 1]], dtype=np.int32)

    # Expected output: A × B = A
    expected = A @ B

    # ------------------------------------------------------------------
    # Drive matrices into the wrapper inputs
    # ------------------------------------------------------------------
    for i in range(N):
        for j in range(N):
            dut.weight_matrix[i*N + j].value = int(A[i, j])
            dut.x_matrix[i*N + j].value = int(B[i, j])

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
    out = np.zeros((N, N), dtype=np.int32)
    for i in range(N):
        for j in range(N):
            out[i, j] = dut.out_matrix[i*N + j].value.signed_integer

    dut._log.info("Output matrix:")
    for r in out:
        dut._log.info(str(r))

    # ------------------------------------------------------------------
    # Verify
    # ------------------------------------------------------------------
    if not np.array_equal(out, expected):
        dut._log.error(f"Expected:\n{expected}")
        raise cocotb.result.TestFailure("Matrix multiply mismatch")
    else:
        dut._log.info("Matrix multiply PASSED.")
