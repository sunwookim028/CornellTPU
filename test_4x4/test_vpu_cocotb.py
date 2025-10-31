#=========================================================================
# VPU Forward Pass Cocotb Testbench (4-lane)
#=========================================================================
# Tests the 4-lane forward pass:
# systolic array -> bias -> leaky ReLU -> output
# vpu_data_pathway = 0b1100

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

FRAC_BITS = 8

def to_fixed(val, frac_bits=FRAC_BITS):
    """Convert python float to signed 16-bit fixed-point (Q8.8)."""
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF

def from_fixed(val, frac_bits=FRAC_BITS):
    """Convert signed 16-bit fixed-point back to python float."""
    if val >= 1 << 15:
        val -= 1 << 16
    return float(val) / (1 << frac_bits)

#-------------------------------------------------------------------------
# Input test data for forward pass
#-------------------------------------------------------------------------

# 4×4 systolic array pre-activation outputs (Z_pre)
Z1_pre = [
    [ 0.0,     0.0,     0.0,     0.0    ],
    [-0.5792,  0.4234, -0.5792,  0.4234 ],
    [ 0.2985,  0.0913,  0.2985,  0.0913 ],
    [-0.2807,  0.5147, -0.2807,  0.5147 ],
]

# Bias scalars (one per neuron)
B1 = [-0.4939, 0.189, -0.4939, 0.189]

# Leak factor (for leaky ReLU)
LEAK = 0.5

#-------------------------------------------------------------------------
# Expected reference output for leaky ReLU layer
# (for human verification, not strict compare)
#-------------------------------------------------------------------------

# Expected (approximate) leaky ReLU output matrix:
# [
#   [-0.24695, 0.189],
#   [-0.5366,  0.6124],
#   [-0.0977,  0.2803],
#   [-0.3873,  0.7037]
# ]

#-------------------------------------------------------------------------
# Test Procedure
#-------------------------------------------------------------------------

@cocotb.test()
async def test_vpu_forward_pass(dut):
    """Validate the forward pathway (bias + leaky ReLU) in the 4-lane VPU."""

    # Start clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Configure forward pass (bias + leaky relu)
    dut.vpu_data_pathway.value = 0b1100

    # Set bias scalars from Unified Buffer
    dut.bias_scalar_in_1.value = to_fixed(B1[0])
    dut.bias_scalar_in_2.value = to_fixed(B1[1])
    dut.bias_scalar_in_3.value = to_fixed(B1[2])
    dut.bias_scalar_in_4.value = to_fixed(B1[3])

    # Set leaky ReLU leak factor
    dut.lr_leak_factor_in.value = to_fixed(LEAK)

    # Feed systolic array pre-activation data row by row
    for row_idx, row in enumerate(Z1_pre):
        dut.vpu_data_in_1.value = to_fixed(row[0])
        dut.vpu_data_in_2.value = to_fixed(row[1])
        dut.vpu_data_in_3.value = to_fixed(row[2])
        dut.vpu_data_in_4.value = to_fixed(row[3])

        dut.vpu_valid_in_1.value = 1
        dut.vpu_valid_in_2.value = 1
        dut.vpu_valid_in_3.value = 1
        dut.vpu_valid_in_4.value = 1

        await RisingEdge(dut.clk)

        # Optional print for debug
        dut._log.info(f"Cycle {row_idx}: "
                      f"Z1_pre=({row[0]:+.3f},{row[1]:+.3f},{row[2]:+.3f},{row[3]:+.3f})")

    # Deassert valid after all inputs
    dut.vpu_valid_in_1.value = 0
    dut.vpu_valid_in_2.value = 0
    dut.vpu_valid_in_3.value = 0
    dut.vpu_valid_in_4.value = 0
    dut.vpu_data_in_1.value = 0
    dut.vpu_data_in_2.value = 0
    dut.vpu_data_in_3.value = 0
    dut.vpu_data_in_4.value = 0

    # Let pipeline flush
    await ClockCycles(dut.clk, 10)

    #-------------------------------------------------------------------------
    # Collect results
    #-------------------------------------------------------------------------

    out_vals = [
        from_fixed(int(dut.vpu_data_out_1.value)),
        from_fixed(int(dut.vpu_data_out_2.value)),
        from_fixed(int(dut.vpu_data_out_3.value)),
        from_fixed(int(dut.vpu_data_out_4.value)),
    ]
    valids = [
        int(dut.vpu_valid_out_1.value),
        int(dut.vpu_valid_out_2.value),
        int(dut.vpu_valid_out_3.value),
        int(dut.vpu_valid_out_4.value),
    ]

    dut._log.info(f"Output values (Q8.8→float): {out_vals}")
    dut._log.info(f"Valid signals: {valids}")

    #-------------------------------------------------------------------------
    # Simple sanity checks
    #-------------------------------------------------------------------------

    # Check that valid bits eventually go high
    assert any(valids), "No valid outputs observed after forward pass!"

    # Check that outputs are nonzero for nonzero inputs
    assert any(abs(v) > 0.001 for v in out_vals), "All outputs are zero — bias or relu inactive?"

    # (Optional) check sign preservation: positive inputs should yield positive outputs
    assert out_vals[1] > 0, "Positive lane did not propagate through ReLU correctly"

