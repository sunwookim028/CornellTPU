import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import struct

# 5x5 input matrix
X_5x5 = [
    [0.1, 0.2, 0.3, 0.4, 0.5],
    [0.6, 0.7, 0.8, 0.9, 1.0],
    [1.1, 1.2, 1.3, 1.4, 1.5],
    [1.6, 1.7, 1.8, 1.9, 2.0],
    [2.1, 2.2, 2.3, 2.4, 2.5],
]

# 5x5 identity weight matrix
W1_5x5 = [
    [1.0, 0.0, 0.0, 0.0, 0.0],
    [0.0, 1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, 0.0, 0.0],
    [0.0, 0.0, 0.0, 1.0, 0.0],
    [0.0, 0.0, 0.0, 0.0, 1.0],
]

# Expected output: X * I^T = X
OUT_5x5 = X_5x5


def float_to_fp32_bits(val: float) -> int:
    """Convert Python float to 32-bit IEEE-754 single-precision bit pattern."""
    return struct.unpack(">I", struct.pack(">f", float(val)))[0]


@cocotb.test()
async def test_systolic_array_5x5_fp32(dut):
    """
    FP32 test for a 5x5 parameterized systolic array.
    Assumes DUT ports:
      - sys_data_in[0..4], sys_start[0..4]
      - sys_weight_in[0..4], sys_accept_w[0..4]
      - sys_data_out[0..4], sys_valid_out[0..4]
      - sys_switch_in
    """
    N = 5
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # ---------------- Reset and init ----------------
    dut.rst.value = 1
    for i in range(N):
        dut.sys_data_in[i].value = 0
        dut.sys_start[i].value = 0
        dut.sys_weight_in[i].value = 0
        dut.sys_accept_w[i].value = 0

    dut.sys_switch_in.value = 0
    if hasattr(dut, "ub_rd_col_size_in"):
        dut.ub_rd_col_size_in.value = 0
    if hasattr(dut, "ub_rd_col_size_valid_in"):
        dut.ub_rd_col_size_valid_in.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    row_ptr = [0] * N

    max_cycles = (3 * N - 2) + N + 5  # run long enough to drain

    for p in range(max_cycles):
        # Default control signals each cycle
        for i in range(N):
            dut.sys_accept_w[i].value = 0
            dut.sys_start[i].value = 0

        # Switch pulse when last weight of first column is loaded
        dut.sys_switch_in.value = 1 if p == (N - 1) else 0
        
        if p < (3 * N - 2):
            for c in range(N):
                k = p - c
                if 0 <= k < N:
                    # For column c, send row = c, col = N-1-k
                    w_row = c
                    w_col = N - 1 - k
                    w_val = W1_5x5[w_row][w_col]
                    dut.sys_weight_in[c].value = float_to_fp32_bits(w_val)
                    dut.sys_accept_w[c].value = 1

        # ---- X input stream, staggered by row ----
        for r in range(N):
            ph = p - (N + r)  # row-dependent delay
            if 0 <= ph < N:
                x_val = X_5x5[ph][r]
                dut.sys_data_in[r].value = float_to_fp32_bits(x_val)
                dut.sys_start[r].value = 1

        # Advance one cycle
        await RisingEdge(dut.clk)

        # ---------------- Check outputs this cycle ----------------
        for c in range(N):
            if int(dut.sys_valid_out[c].value) == 1:
                assert row_ptr[c] < N, f"Too many outputs on column {c}"

                got_bits = int(dut.sys_data_out[c].value)
                exp_val = OUT_5x5[row_ptr[c]][c]
                exp_bits = float_to_fp32_bits(exp_val)

                assert got_bits == exp_bits, (
                    f"Mismatch at col {c}, row {row_ptr[c]}: "
                    f"got 0x{got_bits:08x}, expected 0x{exp_bits:08x} "
                    f"(got {struct.unpack('>f', struct.pack('>I', got_bits))[0]:.6f}, "
                    f"expected {exp_val:.6f})"
                )
                row_ptr[c] += 1

    # ---------------- Final completeness check ----------------
    for c in range(N):
        assert row_ptr[c] == N, (
            f"Column {c}: expected {N} outputs, saw {row_ptr[c]}"
        )
