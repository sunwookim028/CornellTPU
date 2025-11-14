import cocotb
from cocotb.triggers import RisingEdge, Timer
import numpy as np

from systolic_test_suite import TEST_CASES

# Fixed-point helpers
def to_fixed(val, frac_bits=8):
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF

def from_fixed(val, frac_bits=8):
    return float(val) / (1 << frac_bits)


async def run_single_test(dut, W, X, test_name):
    N = 4

    # Reset
    dut.rst.value = 1
    dut.start.value = 0
    await Timer(20, units="ns")
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Convert matrices to flat lists
    W_flat = W.flatten()
    X_flat = X.flatten()

    W_fixed = [to_fixed(v) for v in W_flat]
    X_fixed = [to_fixed(v) for v in X_flat]

    # Load into mock memory
    for i, val in enumerate(W_fixed):
        dut.mem_inst.weight_matrix[i].value = val
    for i, val in enumerate(X_fixed):
        dut.mem_inst.x_matrix[i].value = val

    dut._log.info(f"[{test_name}] Memory initialized.")

    # Start DUT
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # Wait for done
    for _ in range(2000):
        await RisingEdge(dut.clk)
        if int(dut.done.value) == 1:
            break
    else:
        assert False, f"[{test_name}] TIMEOUT waiting for done"

    # Extra settling cycles
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    # Read outputs
    results = []
    for idx, x in enumerate(dut.wrapper_inst.out_matrix):
        bv = x.value
        if 'x' in bv.binstr.lower():
            assert False, f"[{test_name}] X detected in output at index {idx}"
        results.append(from_fixed(int(bv.signed_integer)))

    # Reshape results
    out_grid = np.array(results).reshape(N, N)

    # Expected output (your rotated convention)
    expected = np.flipud(np.fliplr(X @ W.T))

    # Compare with tolerance
    tol = 1e-1
    for idx, (o, e) in enumerate(zip(out_grid.flatten(), expected.flatten())):
        assert abs(o - e) <= tol, \
            f"[{test_name}] MISMATCH at {idx}: got {o}, expected {e}"

    dut._log.info(f"[{test_name}] PASS")


@cocotb.test()
async def test_systolic_wrapper_suite(dut):
    """Run all directed + random tests."""

    for case in TEST_CASES:
        name = case["name"]
        W = case["W"]
        X = case["X"]

        dut._log.info(f"--- Running test case: {name} ---")
        await run_single_test(dut, W, X, name)
