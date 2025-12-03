import random
import struct
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

def float_to_fp32_bits(val: float) -> int:
    """Convert Python float/int to 32-bit IEEE-754 single-precision bit pattern."""
    return struct.unpack(">I", struct.pack(">f", float(val)))[0]


def matmul_4x4(A, B):
    C = [[0.0]*4 for _ in range(4)]
    for i in range(4):
        for j in range(4):
            s = 0.0
            for k in range(4):
                s += A[i][k] * B[k][j]
            C[i][j] = s
    return C

def transpose_4x4(M):
    return [[M[j][i] for j in range(4)] for i in range(4)]

def rand_mat_4x4(lo=-3, hi=3):
    # random integer entries; they get converted to FP32 later
    return [[random.randint(lo, hi) for _ in range(4)] for _ in range(4)]

def gen_random_tests(num_cases, lo, hi):
    cases = []
    for _ in range(num_cases):
        X  = rand_mat_4x4(lo, hi)
        W  = rand_mat_4x4(lo, hi)
        WT = transpose_4x4(W)
        OUT = matmul_4x4(X, WT)
        cases.append({ "X": X, "W": W, "OUT": OUT })
    return cases

async def run_one_case(dut, X, W, OUT):
    # Start a clock (you can move this out to the top-level test if you prefer)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    accept_ws = [
        dut.sys_accept_w_1,
        dut.sys_accept_w_2,
        dut.sys_accept_w_3,
        dut.sys_accept_w_4,
    ]
    for sig in accept_ws:
        sig.value = 0

    init_sigs = [
        dut.sys_start_1, dut.sys_start_2, dut.sys_start_3, dut.sys_start_4,
        dut.sys_weight_in_11, dut.sys_weight_in_12, dut.sys_weight_in_13, dut.sys_weight_in_14,
        dut.sys_data_in_11,   dut.sys_data_in_21,   dut.sys_data_in_31,   dut.sys_data_in_41,
    ]
    for sig in init_sigs:
        sig.value = 0

    # Cycle 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    
    dut.rst.value = 0
    dut.sys_weight_in_11.value = float_to_fp32_bits(W[0][3])
    dut.sys_accept_w_1.value = 1
    await RisingEdge(dut.clk)

    # Cycle 2
    dut.sys_weight_in_11.value = float_to_fp32_bits(W[0][2])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = float_to_fp32_bits(W[1][3])
    dut.sys_accept_w_2.value = 1
    await RisingEdge(dut.clk)

    # Cycle 3
    dut.sys_weight_in_11.value = float_to_fp32_bits(W[0][1])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = float_to_fp32_bits(W[1][2])
    dut.sys_accept_w_2.value = 1
    dut.sys_weight_in_13.value = float_to_fp32_bits(W[2][3])
    dut.sys_accept_w_3.value = 1
    await RisingEdge(dut.clk)

    # Cycle 4
    dut.sys_weight_in_11.value = float_to_fp32_bits(W[0][0])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = float_to_fp32_bits(W[1][1])
    dut.sys_accept_w_2.value = 1
    dut.sys_weight_in_13.value = float_to_fp32_bits(W[2][2])
    dut.sys_accept_w_3.value = 1
    dut.sys_weight_in_14.value = float_to_fp32_bits(W[3][3])
    dut.sys_accept_w_4.value = 1
    dut.sys_switch_in.value   = 1
    await RisingEdge(dut.clk)

    # Cycle 5
    dut.sys_accept_w_1.value  = 0
    dut.sys_weight_in_12.value = float_to_fp32_bits(W[1][0])
    dut.sys_accept_w_2.value   = 1
    dut.sys_weight_in_13.value = float_to_fp32_bits(W[2][1])
    dut.sys_accept_w_3.value   = 1
    dut.sys_weight_in_14.value = float_to_fp32_bits(W[3][2])
    dut.sys_accept_w_4.value   = 1
    dut.sys_switch_in.value    = 0

    # Start putting in X values
    dut.sys_data_in_11.value = float_to_fp32_bits(X[0][0])
    dut.sys_start_1.value    = 1
    await RisingEdge(dut.clk)

    # Cycle 6
    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_weight_in_13.value = float_to_fp32_bits(W[2][0])
    dut.sys_accept_w_3.value   = 1
    dut.sys_weight_in_14.value = float_to_fp32_bits(W[3][1])
    dut.sys_accept_w_4.value   = 1

    dut.sys_data_in_11.value = float_to_fp32_bits(X[1][0])
    dut.sys_start_1.value    = 1
    dut.sys_data_in_21.value = float_to_fp32_bits(X[0][1])
    dut.sys_start_2.value    = 1
    await RisingEdge(dut.clk)

    # Cycle 7
    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_accept_w_3.value = 0

    dut.sys_weight_in_14.value = float_to_fp32_bits(W[3][0])
    dut.sys_accept_w_4.value   = 1

    dut.sys_data_in_11.value = float_to_fp32_bits(X[2][0])
    dut.sys_start_1.value    = 1
    dut.sys_data_in_21.value = float_to_fp32_bits(X[1][1])
    dut.sys_start_2.value    = 1
    dut.sys_data_in_31.value = float_to_fp32_bits(X[0][2])
    dut.sys_start_3.value    = 1
    await RisingEdge(dut.clk)

    # Cycle 8
    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_accept_w_3.value = 0
    dut.sys_accept_w_4.value = 0

    dut.sys_data_in_11.value = float_to_fp32_bits(X[3][0])
    dut.sys_start_1.value    = 1
    dut.sys_data_in_21.value = float_to_fp32_bits(X[2][1])
    dut.sys_start_2.value    = 1
    dut.sys_data_in_31.value = float_to_fp32_bits(X[1][2])
    dut.sys_start_3.value    = 1
    dut.sys_data_in_41.value = float_to_fp32_bits(X[0][3])
    dut.sys_start_4.value    = 1
    await RisingEdge(dut.clk)

    # Cycle 9
    dut.sys_start_1.value    = 0
    dut.sys_data_in_21.value = float_to_fp32_bits(X[3][1])
    dut.sys_start_2.value    = 1
    dut.sys_data_in_31.value = float_to_fp32_bits(X[2][2])
    dut.sys_start_3.value    = 1
    dut.sys_data_in_41.value = float_to_fp32_bits(X[1][3])
    dut.sys_start_4.value    = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[0][0])
    assert dut.sys_valid_out_41.value == 1
    await RisingEdge(dut.clk)

    # Cycle 10
    dut.sys_start_2.value    = 0
    dut.sys_data_in_31.value = float_to_fp32_bits(X[3][2])
    dut.sys_start_3.value    = 1
    dut.sys_data_in_41.value = float_to_fp32_bits(X[2][3])
    dut.sys_start_4.value    = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[1][0])
    assert dut.sys_valid_out_41.value == 1
    assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[0][1])
    assert dut.sys_valid_out_42.value == 1
    await RisingEdge(dut.clk)

    # Cycle 11
    dut.sys_start_3.value    = 0
    dut.sys_data_in_41.value = float_to_fp32_bits(X[3][3])
    dut.sys_start_4.value    = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[2][0])
    assert dut.sys_valid_out_41.value == 1
    assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[1][1])
    assert dut.sys_valid_out_42.value == 1
    assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[0][2])
    assert dut.sys_valid_out_43.value == 1
    await RisingEdge(dut.clk)

    # Cycle 12
    dut.sys_start_4.value = 0

    await Timer(1, units="ns")
    assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[3][0])
    assert dut.sys_valid_out_41.value == 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[3][0])
    assert dut.sys_valid_out_41.value == 1
    assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[2][1])
    assert dut.sys_valid_out_42.value == 1
    assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[1][2])
    assert dut.sys_valid_out_43.value == 1
    assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[0][3])
    assert dut.sys_valid_out_44.value == 1
    await RisingEdge(dut.clk)

    # Cycle 13
    await Timer(1, units="ns")
    assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[3][1])
    assert dut.sys_valid_out_42.value == 1
    assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[2][2])
    assert dut.sys_valid_out_43.value == 1
    assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[1][3])
    assert dut.sys_valid_out_44.value == 1
    await RisingEdge(dut.clk)

    # Cycle 14
    await Timer(1, units="ns")
    assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[3][2])
    assert dut.sys_valid_out_43.value == 1
    assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[2][3])
    assert dut.sys_valid_out_44.value == 1
    await RisingEdge(dut.clk)

    # Cycle 15
    while int(dut.sys_valid_out_44.value) == 0:
        await RisingEdge(dut.clk)
        assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[3][3])
    await RisingEdge(dut.clk)

@cocotb.test()
async def test_systolic_array_4x4_random_suite(dut):
    cases = gen_random_tests(num_cases=100, lo=-3, hi=3)
    for i, case in enumerate(cases):
        cocotb.log.info(f"[systolic_4x4] Case {i+1}")
        await run_one_case(dut, case["X"], case["W"], case["OUT"])
