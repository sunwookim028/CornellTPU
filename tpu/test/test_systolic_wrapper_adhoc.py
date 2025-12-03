import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import numpy as np
import struct


def float_to_fp32_bits(val: float) -> int:
    """Convert Python float to 32-bit IEEE-754 single-precision bit pattern."""
    return struct.unpack(">I", struct.pack(">f", float(val)))[0]


def fp32_bits_to_float(bits: int) -> float:
    """Convert 32-bit IEEE-754 bit pattern to Python float."""
    bits = bits & 0xFFFFFFFF
    return struct.unpack(">f", struct.pack(">I", bits))[0]


@cocotb.test()
async def test_systolic_wrapper(dut):
    """Test the top-level systolic_wrapper module for a 4×4 multiply (FP32)."""

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
    DATA_WIDTH = 32  # FP32

    X = np.array([
        [0.1, 0.2, 0.3, 0.4],
        [0.5, 0.6, 0.7, 0.8],
        [0.9, 1.0, 1.1, 1.2],
        [1.3, 1.4, 1.5, 1.6]
    ], dtype=float)

    W = np.array([
        [1.0, 1.1, 1.2, 1.3],
        [2.0, 2.1, 2.2, 2.3],
        [1.4, 1.5, 1.6, 1.7],
        [2.4, 2.5, 2.6, 2.7]
    ], dtype=float)

    expected = (X @ W.T).astype(np.float32)

    # ------------------------------------------------------------------
    # Drive matrices into the wrapper inputs (as FP32 bit patterns)
    # ------------------------------------------------------------------
    for i in range(N):
        for j in range(N):
            dut.weight_matrix[i*N + j].value = float_to_fp32_bits(W[i, j])
            dut.x_matrix[i*N + j].value      = float_to_fp32_bits(X[i, j])

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
    for cycle in range(timeout_cycles):
        await RisingEdge(dut.clk)
        if dut.done.value:
            dut._log.info(f"Done signal asserted at cycle {cycle}")
            break
    else:
        raise cocotb.result.TestFailure("Timeout waiting for done signal")

    # ------------------------------------------------------------------
    # Capture output matrix
    # ------------------------------------------------------------------
    out = np.zeros((N, N), dtype=float)
    for i in range(N):
        for j in range(N):
            raw_bits = int(dut.out_matrix[i*N + j].value)
            out[i, j] = fp32_bits_to_float(raw_bits)

    dut._log.info("Output matrix (FP32):")
    for r in out:
        dut._log.info(str(r))

    # ------------------------------------------------------------------
    # Verify
    # ------------------------------------------------------------------
    # Allow for small floating-point error
    if not np.allclose(out, expected, rtol=1e-5, atol=1e-5):
        dut._log.error(f"Expected:\n{expected}")
        dut._log.error(f"Got:\n{out}")
        raise cocotb.result.TestFailure("Matrix multiply mismatch (FP32)")
    else:
        dut._log.info("Matrix multiply PASSED (FP32).")
