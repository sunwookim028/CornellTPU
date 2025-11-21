# import cocotb
# from cocotb.clock import Clock
# from cocotb.triggers import RisingEdge, Timer

# import struct

# X = [
#     [0.1, 0.2, 0.3, 0.4],
#     [0.5, 0.6, 0.7, 0.8],
#     [0.9, 1.0, 1.1, 1.2],
#     [1.3, 1.4, 1.5, 1.6]
# ]

# W1 = [
#     [1., 0., 0., 0.],
#     [0., 1., 0., 0.],
#     [0., 0., 1., 0.],
#     [0., 0., 0., 1.]
# ]

# OUT = [
#     [0.1, 0.2, 0.3, 0.4],
#     [0.5, 0.6, 0.7, 0.8],
#     [0.9, 1.0, 1.1, 1.2],
#     [1.3, 1.4, 1.5, 1.6]
# ]

# def float_to_fp32_bits(val: float) -> int:
#     """Convert Python float to 32-bit IEEE-754 single-precision bit pattern."""
#     return struct.unpack(">I", struct.pack(">f", val))[0]


# @cocotb.test()
# async def test_systolic_array_4x4_fp32(dut):

#     # Create a clock
#     clock = Clock(dut.clk, 10, units="ns")
#     cocotb.start_soon(clock.start())
    
#     # Reset the DUT
#     dut.rst.value = 1
#     dut.sys_accept_w_1.value = 0
#     dut.sys_accept_w_2.value = 0
#     dut.sys_accept_w_3.value = 0
#     dut.sys_accept_w_4.value = 0
#     dut.sys_switch_in.value = 0
#     await RisingEdge(dut.clk)
#     await RisingEdge(dut.clk)  # allow reset to propagate

#     # ===================== Load Weights =====================

#     # Cycle 1: load first weight into column 1
#     dut.rst.value = 0
#     dut.sys_weight_in_11.value = float_to_fp32_bits(W1[0][3])
#     dut.sys_accept_w_1.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 2: load second weight into column 1, first into column 2
#     dut.sys_weight_in_11.value = float_to_fp32_bits(W1[0][2])
#     dut.sys_accept_w_1.value = 1
#     dut.sys_weight_in_12.value = float_to_fp32_bits(W1[1][3])
#     dut.sys_accept_w_2.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 3: load third into col 1, second into col 2, first into col 3
#     dut.sys_weight_in_11.value = float_to_fp32_bits(W1[0][1])
#     dut.sys_accept_w_1.value = 1
#     dut.sys_weight_in_12.value = float_to_fp32_bits(W1[1][2])
#     dut.sys_accept_w_2.value = 1
#     dut.sys_weight_in_13.value = float_to_fp32_bits(W1[2][3])
#     dut.sys_accept_w_3.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 4: fourth into col 1, third into col 2, second into col 3, first into col 4
#     dut.sys_weight_in_11.value = float_to_fp32_bits(W1[0][0])
#     dut.sys_accept_w_1.value = 1
#     dut.sys_weight_in_12.value = float_to_fp32_bits(W1[1][1])
#     dut.sys_accept_w_2.value = 1
#     dut.sys_weight_in_13.value = float_to_fp32_bits(W1[2][2])
#     dut.sys_accept_w_3.value = 1
#     dut.sys_weight_in_14.value = float_to_fp32_bits(W1[3][3])
#     dut.sys_accept_w_4.value = 1

#     dut.sys_switch_in.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 5: finish col 1, continue others, start feeding X
#     dut.sys_accept_w_1.value = 0

#     dut.sys_weight_in_12.value = float_to_fp32_bits(W1[1][0])
#     dut.sys_accept_w_2.value = 1
#     dut.sys_weight_in_13.value = float_to_fp32_bits(W1[2][1])
#     dut.sys_accept_w_3.value = 1
#     dut.sys_weight_in_14.value = float_to_fp32_bits(W1[3][2])
#     dut.sys_accept_w_4.value = 1

#     dut.sys_switch_in.value = 0

#     # Load first X into row 1
#     dut.sys_data_in_11.value = float_to_fp32_bits(X[0][0])
#     dut.sys_start_1.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 6: continue weights, feed more X
#     dut.sys_accept_w_1.value = 0
#     dut.sys_accept_w_2.value = 0

#     dut.sys_weight_in_13.value = float_to_fp32_bits(W1[2][0])
#     dut.sys_accept_w_3.value = 1
#     dut.sys_weight_in_14.value = float_to_fp32_bits(W1[3][1])
#     dut.sys_accept_w_4.value = 1

#     # Load second X into row 1, first X into row 2
#     dut.sys_data_in_11.value = float_to_fp32_bits(X[1][0])
#     dut.sys_start_1.value = 1
#     dut.sys_data_in_21.value = float_to_fp32_bits(X[0][1])
#     dut.sys_start_2.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 7: finish weights into col 4, feed more X
#     dut.sys_accept_w_1.value = 0
#     dut.sys_accept_w_2.value = 0
#     dut.sys_accept_w_3.value = 0

#     dut.sys_weight_in_14.value = float_to_fp32_bits(W1[3][0])
#     dut.sys_accept_w_4.value = 1

#     # Load third X into row 1, second into row 2, first into row 3
#     dut.sys_data_in_11.value = float_to_fp32_bits(X[2][0])
#     dut.sys_start_1.value = 1
#     dut.sys_data_in_21.value = float_to_fp32_bits(X[1][1])
#     dut.sys_start_2.value = 1
#     dut.sys_data_in_31.value = float_to_fp32_bits(X[0][2])
#     dut.sys_start_3.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 8: all accept_w low, feed more X
#     dut.sys_accept_w_1.value = 0
#     dut.sys_accept_w_2.value = 0
#     dut.sys_accept_w_3.value = 0
#     dut.sys_accept_w_4.value = 0

#     # Load fourth X into row 1, third into row 2, second into row 3, first into row 4
#     dut.sys_data_in_11.value = float_to_fp32_bits(X[3][0])
#     dut.sys_start_1.value = 1
#     dut.sys_data_in_21.value = float_to_fp32_bits(X[2][1])
#     dut.sys_start_2.value = 1
#     dut.sys_data_in_31.value = float_to_fp32_bits(X[1][2])
#     dut.sys_start_3.value = 1
#     dut.sys_data_in_41.value = float_to_fp32_bits(X[0][3])
#     dut.sys_start_4.value = 1
#     await RisingEdge(dut.clk)

#     # Cycle 9: continue feeding X, start checking outputs
#     dut.sys_start_1.value = 0  # done with row 1
#     dut.sys_data_in_21.value = float_to_fp32_bits(X[3][1])
#     dut.sys_start_2.value = 1
#     dut.sys_data_in_31.value = float_to_fp32_bits(X[2][2])
#     dut.sys_start_3.value = 1
#     dut.sys_data_in_41.value = float_to_fp32_bits(X[1][3])
#     dut.sys_start_4.value = 1

#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[0][0])
#     assert dut.sys_valid_out_41.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 10
#     dut.sys_start_2.value = 0  # done with row 2
#     dut.sys_data_in_31.value = float_to_fp32_bits(X[3][2])
#     dut.sys_start_3.value = 1
#     dut.sys_data_in_41.value = float_to_fp32_bits(X[2][3])
#     dut.sys_start_4.value = 1

#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[1][0])
#     assert dut.sys_valid_out_41.value == 1
#     assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[0][1])
#     assert dut.sys_valid_out_42.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 11
#     dut.sys_start_3.value = 0  # done with row 3
#     dut.sys_data_in_41.value = float_to_fp32_bits(X[3][3])
#     dut.sys_start_4.value = 1

#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[2][0])
#     assert dut.sys_valid_out_41.value == 1
#     assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[1][1])
#     assert dut.sys_valid_out_42.value == 1
#     assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[0][2])
#     assert dut.sys_valid_out_43.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 12
#     dut.sys_start_4.value = 0  # done with row 4

#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[3][0])
#     assert dut.sys_valid_out_41.value == 1

#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_41.value) == float_to_fp32_bits(OUT[3][0])
#     assert dut.sys_valid_out_41.value == 1
#     assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[2][1])
#     assert dut.sys_valid_out_42.value == 1
#     assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[1][2])
#     assert dut.sys_valid_out_43.value == 1
#     assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[0][3])
#     assert dut.sys_valid_out_44.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 13
#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_42.value) == float_to_fp32_bits(OUT[3][1])
#     assert dut.sys_valid_out_42.value == 1
#     assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[2][2])
#     assert dut.sys_valid_out_43.value == 1
#     assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[1][3])
#     assert dut.sys_valid_out_44.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 14
#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_43.value) == float_to_fp32_bits(OUT[3][2])
#     assert dut.sys_valid_out_43.value == 1
#     assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[2][3])
#     assert dut.sys_valid_out_44.value == 1

#     await RisingEdge(dut.clk)

#     # Cycle 15
#     await Timer(1, units="ns")
#     assert int(dut.sys_data_out_44.value) == float_to_fp32_bits(OUT[3][3])
#     assert dut.sys_valid_out_44.value == 1

#     await RisingEdge(dut.clk)

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import struct

X = [
    [0.1, 0.2, 0.3, 0.4],
    [0.5, 0.6, 0.7, 0.8],
    [0.9, 1.0, 1.1, 1.2],
    [1.3, 1.4, 1.5, 1.6],
]

W1 = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 1.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, 0.0],
    [0.0, 0.0, 0.0, 1.0],
]

OUT = [
    [0.1, 0.2, 0.3, 0.4],
    [0.5, 0.6, 0.7, 0.8],
    [0.9, 1.0, 1.1, 1.2],
    [1.3, 1.4, 1.5, 1.6],
]


def float_to_fp32_bits(val: float) -> int:
    """Convert Python float to 32-bit IEEE-754 single-precision bit pattern."""
    return struct.unpack(">I", struct.pack(">f", float(val)))[0]


@cocotb.test()
async def test_systolic_array_4x4_fp32(dut):
    """
    Directed FP32 test for a 4x4 systolic array with parameterized N.
    Assumes:
      - sys_data_in[0..3], sys_start[0..3]
      - sys_weight_in[0..3], sys_accept_w[0..3]
      - sys_data_out[0..3], sys_valid_out[0..3]
    """

    N = 4  # we’re testing the 4x4 instance

    # Create a clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT and clear control signals
    dut.rst.value = 1
    for i in range(N):
        dut.sys_accept_w[i].value = 0
        dut.sys_start[i].value = 0
        dut.sys_data_in[i].value = 0
        dut.sys_weight_in[i].value = 0

    dut.sys_switch_in.value = 0
    if hasattr(dut, "ub_rd_col_size_in"):
        dut.ub_rd_col_size_in.value = 0
    if hasattr(dut, "ub_rd_col_size_valid_in"):
        dut.ub_rd_col_size_valid_in.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # allow reset to propagate

    # ===================== Load Weights =====================

    # Cycle 1: load first weight into column 0 (old col1)
    dut.rst.value = 0
    dut.sys_weight_in[0].value = float_to_fp32_bits(W1[0][3])
    dut.sys_accept_w[0].value = 1
    await RisingEdge(dut.clk)

    # Cycle 2: load second weight into col0, first into col1
    dut.sys_weight_in[0].value = float_to_fp32_bits(W1[0][2])
    dut.sys_accept_w[0].value = 1
    dut.sys_weight_in[1].value = float_to_fp32_bits(W1[1][3])
    dut.sys_accept_w[1].value = 1
    await RisingEdge(dut.clk)

    # Cycle 3: third into col0, second into col1, first into col2
    dut.sys_weight_in[0].value = float_to_fp32_bits(W1[0][1])
    dut.sys_accept_w[0].value = 1
    dut.sys_weight_in[1].value = float_to_fp32_bits(W1[1][2])
    dut.sys_accept_w[1].value = 1
    dut.sys_weight_in[2].value = float_to_fp32_bits(W1[2][3])
    dut.sys_accept_w[2].value = 1
    await RisingEdge(dut.clk)

    # Cycle 4: fourth into col0, third into col1, second into col2, first into col3
    dut.sys_weight_in[0].value = float_to_fp32_bits(W1[0][0])
    dut.sys_accept_w[0].value = 1
    dut.sys_weight_in[1].value = float_to_fp32_bits(W1[1][1])
    dut.sys_accept_w[1].value = 1
    dut.sys_weight_in[2].value = float_to_fp32_bits(W1[2][2])
    dut.sys_accept_w[2].value = 1
    dut.sys_weight_in[3].value = float_to_fp32_bits(W1[3][3])
    dut.sys_accept_w[3].value = 1

    dut.sys_switch_in.value = 1
    await RisingEdge(dut.clk)

    # Cycle 5: finish col0, continue others, start feeding X
    dut.sys_accept_w[0].value = 0

    dut.sys_weight_in[1].value = float_to_fp32_bits(W1[1][0])
    dut.sys_accept_w[1].value = 1
    dut.sys_weight_in[2].value = float_to_fp32_bits(W1[2][1])
    dut.sys_accept_w[2].value = 1
    dut.sys_weight_in[3].value = float_to_fp32_bits(W1[3][2])
    dut.sys_accept_w[3].value = 1

    dut.sys_switch_in.value = 0

    # Load first X into row 0
    dut.sys_data_in[0].value = float_to_fp32_bits(X[0][0])
    dut.sys_start[0].value = 1
    await RisingEdge(dut.clk)

    # Cycle 6: continue weights, feed more X
    dut.sys_accept_w[0].value = 0
    dut.sys_accept_w[1].value = 0

    dut.sys_weight_in[2].value = float_to_fp32_bits(W1[2][0])
    dut.sys_accept_w[2].value = 1
    dut.sys_weight_in[3].value = float_to_fp32_bits(W1[3][1])
    dut.sys_accept_w[3].value = 1

    # Load second X into row 0, first X into row 1
    dut.sys_data_in[0].value = float_to_fp32_bits(X[1][0])
    dut.sys_start[0].value = 1
    dut.sys_data_in[1].value = float_to_fp32_bits(X[0][1])
    dut.sys_start[1].value = 1
    await RisingEdge(dut.clk)

    # Cycle 7: finish weights into col3, feed more X
    dut.sys_accept_w[0].value = 0
    dut.sys_accept_w[1].value = 0
    dut.sys_accept_w[2].value = 0

    dut.sys_weight_in[3].value = float_to_fp32_bits(W1[3][0])
    dut.sys_accept_w[3].value = 1

    # Load third X into row 0, second into row 1, first into row 2
    dut.sys_data_in[0].value = float_to_fp32_bits(X[2][0])
    dut.sys_start[0].value = 1
    dut.sys_data_in[1].value = float_to_fp32_bits(X[1][1])
    dut.sys_start[1].value = 1
    dut.sys_data_in[2].value = float_to_fp32_bits(X[0][2])
    dut.sys_start[2].value = 1
    await RisingEdge(dut.clk)

    # Cycle 8: all accept_w low, feed more X
    for i in range(N):
        dut.sys_accept_w[i].value = 0

    # Load fourth X into row 0, third into row 1, second into row 2, first into row 3
    dut.sys_data_in[0].value = float_to_fp32_bits(X[3][0])
    dut.sys_start[0].value = 1
    dut.sys_data_in[1].value = float_to_fp32_bits(X[2][1])
    dut.sys_start[1].value = 1
    dut.sys_data_in[2].value = float_to_fp32_bits(X[1][2])
    dut.sys_start[2].value = 1
    dut.sys_data_in[3].value = float_to_fp32_bits(X[0][3])
    dut.sys_start[3].value = 1
    await RisingEdge(dut.clk)

    # Cycle 9: continue feeding X, start checking outputs
    dut.sys_start[0].value = 0  # done with row 0
    dut.sys_data_in[1].value = float_to_fp32_bits(X[3][1])
    dut.sys_start[1].value = 1
    dut.sys_data_in[2].value = float_to_fp32_bits(X[2][2])
    dut.sys_start[2].value = 1
    dut.sys_data_in[3].value = float_to_fp32_bits(X[1][3])
    dut.sys_start[3].value = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out[0].value) == float_to_fp32_bits(OUT[0][0])
    assert dut.sys_valid_out[0].value == 1

    await RisingEdge(dut.clk)

    # Cycle 10
    dut.sys_start[1].value = 0  # done with row 1
    dut.sys_data_in[2].value = float_to_fp32_bits(X[3][2])
    dut.sys_start[2].value = 1
    dut.sys_data_in[3].value = float_to_fp32_bits(X[2][3])
    dut.sys_start[3].value = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out[0].value) == float_to_fp32_bits(OUT[1][0])
    assert dut.sys_valid_out[0].value == 1
    assert int(dut.sys_data_out[1].value) == float_to_fp32_bits(OUT[0][1])
    assert dut.sys_valid_out[1].value == 1

    await RisingEdge(dut.clk)

    # Cycle 11
    dut.sys_start[2].value = 0  # done with row 2
    dut.sys_data_in[3].value = float_to_fp32_bits(X[3][3])
    dut.sys_start[3].value = 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out[0].value) == float_to_fp32_bits(OUT[2][0])
    assert dut.sys_valid_out[0].value == 1
    assert int(dut.sys_data_out[1].value) == float_to_fp32_bits(OUT[1][1])
    assert dut.sys_valid_out[1].value == 1
    assert int(dut.sys_data_out[2].value) == float_to_fp32_bits(OUT[0][2])
    assert dut.sys_valid_out[2].value == 1

    await RisingEdge(dut.clk)

    # Cycle 12
    dut.sys_start[3].value = 0  # done with row 3

    await Timer(1, units="ns")
    assert int(dut.sys_data_out[0].value) == float_to_fp32_bits(OUT[3][0])
    assert dut.sys_valid_out[0].value == 1

    await Timer(1, units="ns")
    assert int(dut.sys_data_out[0].value) == float_to_fp32_bits(OUT[3][0])
    assert dut.sys_valid_out[0].value == 1
    assert int(dut.sys_data_out[1].value) == float_to_fp32_bits(OUT[2][1])
    assert dut.sys_valid_out[1].value == 1
    assert int(dut.sys_data_out[2].value) == float_to_fp32_bits(OUT[1][2])
    assert dut.sys_valid_out[2].value == 1
    assert int(dut.sys_data_out[3].value) == float_to_fp32_bits(OUT[0][3])
    assert dut.sys_valid_out[3].value == 1

    await RisingEdge(dut.clk)

    # Cycle 13
    await Timer(1, units="ns")
    assert int(dut.sys_data_out[1].value) == float_to_fp32_bits(OUT[3][1])
    assert dut.sys_valid_out[1].value == 1
    assert int(dut.sys_data_out[2].value) == float_to_fp32_bits(OUT[2][2])
    assert dut.sys_valid_out[2].value == 1
    assert int(dut.sys_data_out[3].value) == float_to_fp32_bits(OUT[1][3])
    assert dut.sys_valid_out[3].value == 1

    await RisingEdge(dut.clk)

    # Cycle 14
    await Timer(1, units="ns")
    assert int(dut.sys_data_out[2].value) == float_to_fp32_bits(OUT[3][2])
    assert dut.sys_valid_out[2].value == 1
    assert int(dut.sys_data_out[3].value) == float_to_fp32_bits(OUT[2][3])
    assert dut.sys_valid_out[3].value == 1

    await RisingEdge(dut.clk)

    # Cycle 15
    await Timer(1, units="ns")
    assert int(dut.sys_data_out[3].value) == float_to_fp32_bits(OUT[3][3])
    assert dut.sys_valid_out[3].value == 1

    await RisingEdge(dut.clk)
