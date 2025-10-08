# import cocotb
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

X = [
    [1., 2., 3., 4.],
    [0.5, 0.6, 0.7, 0.8],
    [0.1, 0.2, 0.3, 0.4],
    [0.5, 0.6, 0.7, 0.8]
]

W1 = [
    [1., 2., 3., 4.],
    [0., 1., 0., 0.],
    [0., 0., 1., 0.],
    [0., 0., 0., 1.]
]

OUT = [
    [0.1, 0.2, 0.3, 0.4],
    [0.5, 0.6, 0.7, 0.8],
    [0.1, 0.2, 0.3, 0.4],
    [0.5, 0.6, 0.7, 0.8]
]

# These arrays are trivial for now.
# Implement directed tests, and then use numpy for random tests.

def to_fixed(val, frac_bits=8):
    """Convert a float to 16-bit fixed point with 8 fractional bits."""
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF

# Calculating X @ W1^T
# Expected output:
# N/A - Right now X and W are just placeholders


# First column of accept weight signal turns off -> set switch flag on and set first row start signal on (start loading in X)
@cocotb.test()
async def test_systolic_array_4x4(dut): 

    # Create a clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # rst the DUT (device under test)
    dut.rst.value = 1
    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_accept_w_3.value = 0
    dut.sys_accept_w_4.value = 0
    dut.sys_switch_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk) # Waiting two cycles here allows the reset to be visible in the waveform



    # Cycle 1:

    # Load first weight into column 1
    dut.rst.value = 0
    dut.sys_weight_in_11.value = to_fixed(W1[0][3])
    dut.sys_accept_w_1.value = 1
    await RisingEdge(dut.clk)

    # Array after this cycle: (w is transposed)
    #   [w14 , no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 2:
    # Load second weight into column 1
    # Load first weight into column 2
    dut.sys_switch_in.value = 1
    dut.sys_weight_in_11.value = to_fixed(W1[0][2])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = to_fixed(W1[1][3])
    dut.sys_accept_w_2.value = 1

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w13 , no x], [w24 , no x], [no w, no x], [no w, no x]
    #   [w14 , no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 3:
    # Load third weight into column 1
    # Load second weight into column 2
    # Load first weight into column 3
    dut.sys_weight_in_11.value = to_fixed(W1[0][1])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = to_fixed(W1[1][2])
    dut.sys_accept_w_2.value = 1
    dut.sys_weight_in_13.value = to_fixed(W1[2][3])
    dut.sys_accept_w_3.value = 1

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w12 , no x], [w23 , no x], [w34 , no x], [no w, no x]
    #   [w13 , no x], [w24 , no x], [no w, no x], [no w, no x]
    #   [w14 , no x], [no w, no x], [no w, no x], [no w, no x]
    #   [no w, no x], [no w, no x], [no w, no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 4:
    # Load fourth weight into column 1
    # Load third weight into column 2
    # Load second weight into column 3
    # Load first weight into column 4
    dut.sys_weight_in_11.value = to_fixed(W1[0][0])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = to_fixed(W1[1][1])
    dut.sys_accept_w_2.value = 1
    dut.sys_weight_in_13.value = to_fixed(W1[2][2])
    dut.sys_accept_w_3.value = 1
    dut.sys_weight_in_14.value = to_fixed(W1[3][3])
    dut.sys_accept_w_4.value = 1

    # Load first X into row 1
    dut.sys_data_in_11.value = to_fixed(X[0][0])
    dut.sys_start_1.value = 1

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , x11 ], [w22 , no x], [w33 , no x], [w44 , no x]
    #   [w12 , no x], [w23 , no x], [w34 , no x], [no w, no x]
    #   [w13 , no x], [w24 , no x], [no w, no x], [no w, no x]
    #   [w14 , no x], [no w, no x], [no w, no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 5:
    # Load fourth weight into column 2
    # Load third weight into column 3
    # Load second weight into column 4
    dut.sys_weight_in_12.value = to_fixed(W1[1][0])
    dut.sys_accept_w_2.value = 1
    dut.sys_weight_in_13.value = to_fixed(W1[2][1])
    dut.sys_accept_w_3.value = 1
    dut.sys_weight_in_14.value = to_fixed(W1[3][2])
    dut.sys_accept_w_4.value = 1

    # Load second X into row 1
    # Load first x into row 2
    dut.sys_data_in_11.value = to_fixed(X[1][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[0][1])
    dut.sys_start_2.value = 1

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , x21 ], [w21 , x11 ], [w32 , no x], [w43 , no x]
    #   [w12 , x12 ], [w22 , no x], [w33 , no x], [w44 , no x]
    #   [w13 , no x], [w23 , no x], [w34 , no x], [no w, no x]
    #   [w14 , no x], [w24 , no x], [no w, no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 6:
    # Load fourth weight into column 3
    # Load third weight into column 4
    dut.sys_weight_in_13.value = to_fixed(W1[2][0])
    dut.sys_accept_w_3.value = 1
    dut.sys_weight_in_14.value = to_fixed(W1[3][1])
    dut.sys_accept_w_4.value = 1

    # Load third X into row 1
    # Load second x into row 2
    # Load first x into row 3
    dut.sys_data_in_11.value = to_fixed(X[2][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[1][1])
    dut.sys_start_2.value = 1
    dut.sys_data_in_31.value = to_fixed(X[0][2])
    dut.sys_start_3.value = 1

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , x31 ], [w21 , x21 ], [w31 , x11 ], [w42 , no x]
    #   [w12 , x22 ], [w22 , x12 ], [w32 , no x], [w43 , no x]
    #   [w13 , x13 ], [w23 , no x], [w33 , no x], [w44 , no x]
    #   [w14 , no x], [w24 , no x], [w34 , no x], [no w, no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE          NONE         NONE



    # Cycle 7:
    # Load fourth weight into column 4
    dut.sys_weight_in_14.value = to_fixed(W1[3][0])
    dut.sys_accept_w_4.value = 1

    # Load fourth X into row 1
    # Load third x into row 2
    # Load second x into row 3
    # Load first x into row 4
    dut.sys_data_in_11.value = to_fixed(X[3][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[2][1])
    dut.sys_start_2.value = 1
    dut.sys_data_in_31.value = to_fixed(X[1][2])
    dut.sys_start_3.value = 1
    dut.sys_data_in_41.value = to_fixed(X[0][3])
    dut.sys_start_4.value = 1
    # Assert outputs
    print("Test:")
    print(dut.sys_data_out_41.value)
    print(dut.sys_data_out_42.value)
    print(dut.sys_data_out_43.value)
    print(dut.sys_data_out_44.value)
    print("Done!")
    #await RisingEdge(dut.clk)
    #await RisingEdge(dut.clk)
    #assert dut.sys_data_out_41.value == to_fixed(OUT[0][0])
    #assert dut.sys_valid_out_41.value == to_fixed(1)

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , x41 ], [w21 , x31 ], [w31 , x21 ], [w41 , x11 ]
    #   [w12 , x32 ], [w22 , x22 ], [w32 , x12 ], [w42 , no x]
    #   [w13 , x23 ], [w23 , x13 ], [w33 , no x], [w43 , no x]
    #   [w14 , x14 ], [w24 , no x], [w34 , no x], [w44 , no x]
    #         |             |             |            |
    #         V             V             V            V
    #       OUT_11         NONE          NONE         NONE
    #
    # OUT_11 = w11*x11 + w12*x12 + w13*x13 + w14*x14

    # Cycle 8:

    # Load fourth x into row 2
    # Load third x into row 3
    # Load second x into row 4
    dut.sys_start_1.value = 0 # Done inputting x to row 1
    dut.sys_data_in_21.value = to_fixed(X[3][1])
    dut.sys_start_2.value = 1
    dut.sys_data_in_31.value = to_fixed(X[2][2])
    dut.sys_start_3.value = 1
    dut.sys_data_in_41.value = to_fixed(X[1][3])
    dut.sys_start_4.value = 1
    
    # Assert outputs
    print("Test:")
    print(dut.sys_data_out_41.value)
    print(dut.sys_data_out_42.value)
    print(dut.sys_data_out_43.value)
    print(dut.sys_data_out_44.value)
    print("Done!")

    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , no x], [w21 , x41 ], [w31 , x31 ], [w41 , x21 ]
    #   [w12 , x42 ], [w22 , x32 ], [w32 , x22 ], [w42 , x12 ]
    #   [w13 , x33 ], [w23 , x23 ], [w33 , x13 ], [w43 , no x]
    #   [w14 , x24 ], [w24 , x14 ], [w34 , no x], [w44 , no x]
    #         |             |             |            |
    #         V             V             V            V
    #        OUT_21        OUT_12          NONE         NONE
    #
    # OUT_21 = w11*x21 + w12*x22 + w13*x23 + w14*x24
    # OUT_12 = w21*x11 + w22*x12 + w23*x13 + w24*x14


    # Cycle 9:

    # Load fourth x into row 3
    # Load third x into row 4
    dut.sys_start_2.value = 0 # Done inputting x to row 2
    dut.sys_data_in_31.value = to_fixed(X[3][2])
    dut.sys_start_3.value = 1
    dut.sys_data_in_41.value = to_fixed(X[2][3])
    dut.sys_start_4.value = 1
    # Assert outputs
    print("Test:")
    print(dut.sys_data_out_41.value)
    print(dut.sys_data_out_42.value)
    print(dut.sys_data_out_43.value)
    print(dut.sys_data_out_44.value)
    print("Done!")
    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , x41 ], [w41 , x31 ]
    #   [w12 , no x], [w22 , x42 ], [w32 , x32 ], [w42 , x22 ]
    #   [w13 , x43 ], [w23 , x33 ], [w33 , x23 ], [w43 , x13 ]
    #   [w14 , x34 ], [w24 , x24 ], [w34 , x14 ], [w44 , no x]
    #         |             |             |            |
    #         V             V             V            V
    #        OUT_31        OUT_22       OUT_13         NONE
    #
    # OUT_31 = w11*x31 + w12*x32 + w13*x33 + w14*x34
    # OUT_22 = w21*x21 + w22*x22 + w23*x23 + w24*x24
    # OUT_13 = w31*x11 + w32*x12 + w33*x13 + w34*x14


    # Cycle 10:

    # Load fourth x into row 4
    dut.sys_start_3.value = 0 # Done inputting x to row 3
    dut.sys_data_in_41.value = to_fixed(X[3][3])
    dut.sys_start_4.value = 1
    # Assert outputs
    print("Test:")
    print(dut.sys_data_out_41.value)
    print(dut.sys_data_out_42.value)
    print(dut.sys_data_out_43.value)
    print(dut.sys_data_out_44.value)
    print("Done!")
    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , no x], [w41 , x41 ]
    #   [w12 , no x], [w22 , no x], [w32 , x42 ], [w42 , x32 ]
    #   [w13 , no x], [w23 , x43 ], [w33 , x33 ], [w43 , x23 ]
    #   [w14 , x44 ], [w24 , x34 ], [w34 , x24 ], [w44 , x14 ]
    #         |             |             |            |
    #         V             V             V            V
    #        OUT_41        OUT_32       OUT_23        OUT_14
    #
    # OUT_41 = w11*x41 + w12*x42 + w13*x43 + w14*x44
    # OUT_32 = w21*x31 + w22*x32 + w23*x33 + w24*x34
    # OUT_23 = w31*x21 + w32*x22 + w33*x23 + w34*x24
    # OUT_14 = w41*x11 + w42*x12 + w43*x13 + w44*x14



    # Cycle 11:

    dut.sys_start_4.value = 0 # Done inputting x to row 4
    # Assert outputs
    print("Test:")
    print(dut.sys_data_out_41.value)
    print(dut.sys_data_out_42.value)
    print(dut.sys_data_out_43.value)
    print(dut.sys_data_out_44.value)
    print("Done!")
    await RisingEdge(dut.clk)

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , no x], [w41 , no x]
    #   [w12 , no x], [w22 , no x], [w32 , no x], [w42 , x42 ]
    #   [w13 , no x], [w23 , no x], [w33 , x43 ], [w43 , x33 ]
    #   [w14 , no x], [w24 , x44 ], [w34 , x34 ], [w44 , x24 ]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE        OUT_42       OUT_33        OUT_24
    #
    # OUT_42 = w21*x41 + w22*x42 + w23*x43 + w24*x44
    # OUT_33 = w31*x31 + w32*x32 + w33*x33 + w34*x34
    # OUT_24 = w41*x21 + w42*x22 + w43*x23 + w44*x24



    # Cycle 12:

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , no x], [w41 , no x]
    #   [w12 , no x], [w22 , no x], [w32 , no x], [w42 , no x]
    #   [w13 , no x], [w23 , no x], [w33 , no x], [w43 , x43 ]
    #   [w14 , no x], [w24 , no x], [w34 , x44 ], [w44 , x34 ]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE        OUT_43        OUT_34
    #
    # OUT_43 = w31*x41 + w32*x42 + w33*x43 + w34*x44
    # OUT_34 = w41*x31 + w42*x32 + w43*x33 + w44*x34



    # Cycle 13:

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , no x], [w41 , no x]
    #   [w12 , no x], [w22 , no x], [w32 , no x], [w42 , no x]
    #   [w13 , no x], [w23 , no x], [w33 , no x], [w43 , no x]
    #   [w14 , no x], [w24 , no x], [w34 , no x], [w44 , x44 ]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE         NONE        OUT_44
    #
    # OUT_44 = w41*x41 + w42*x42 + w43*x43 + w44*x44



    # Cycle 14:

    # Array after this cycle:
    #   [w11 , no x], [w21 , no x], [w31 , no x], [w41 , no x]
    #   [w12 , no x], [w22 , no x], [w32 , no x], [w42 , no x]
    #   [w13 , no x], [w23 , no x], [w33 , no x], [w43 , no x]
    #   [w14 , no x], [w24 , no x], [w34 , no x], [w44 , no x]
    #         |             |             |            |
    #         V             V             V            V
    #        NONE          NONE         NONE        NONE
    #

    #TODO: Add more cycle diagrams to confirm inputs/outputs at each cycle,
    #      then implement test in cocotb

    # Original test case below:
    '''
    dut.rst.value = 1
    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_switch_in.value = 0
    await RisingEdge(dut.clk)

    dut.rst.value = 0
    dut.sys_weight_in_11.value = to_fixed(W1[0][1])
    dut.sys_accept_w_1.value = 1
    await RisingEdge(dut.clk)

    dut.sys_weight_in_11.value = to_fixed(W1[0][0])
    dut.sys_accept_w_1.value = 1
    dut.sys_weight_in_12.value = to_fixed(W1[1][1])
    dut.sys_accept_w_2.value = 1
    await RisingEdge(dut.clk)

    dut.sys_accept_w_1.value = 0
    dut.sys_weight_in_12.value = to_fixed(W1[1][0])
    dut.sys_accept_w_2.value = 1
    dut.sys_switch_in.value = 1
    dut.sys_data_in_11.value = to_fixed(X[0][0])
    dut.sys_start_1.value = 1
    await RisingEdge(dut.clk)

    dut.sys_accept_w_1.value = 0
    dut.sys_accept_w_2.value = 0
    dut.sys_switch_in.value = 0
    dut.sys_data_in_11.value = to_fixed(X[1][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[0][1])
    dut.sys_start_2.value = 1
    await RisingEdge(dut.clk)

    dut.sys_data_in_11.value = to_fixed(X[2][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[1][1])
    dut.sys_start_2.value = 1
    await RisingEdge(dut.clk)

    dut.sys_data_in_11.value = to_fixed(X[3][0])
    dut.sys_start_1.value = 1
    dut.sys_data_in_21.value = to_fixed(X[2][1])
    dut.sys_start_2.value = 1
    await RisingEdge(dut.clk)

    dut.sys_start_1.value = 0
    dut.sys_data_in_21.value = to_fixed(X[3][1])
    dut.sys_start_2.value = 1
    await RisingEdge(dut.clk)

    dut.sys_start_1.value = 0
    dut.sys_start_2.value = 0
    await RisingEdge(dut.clk)
    
    await ClockCycles(dut.clk, 10)
    '''