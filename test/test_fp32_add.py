import cocotb
from cocotb.triggers import Timer
import struct

# --- Helper Function to display hex as float ---
def hex_to_float(hex_int):
    """Converts a 32-bit integer representing an FP32 value to a Python float."""
    return struct.unpack('>f', struct.pack('>I', hex_int))[0]

@cocotb.test()
async def test_fp32_add_vectors(dut):
    """Test the fp32_add module with a variety of IEEE 754 test vectors."""

    dut._log.info("Starting FP32 Adder Cocotb Test")

    # (A_hex, B_hex, Expected_hex, Description)
    test_vectors = [
        # ===== Basic Operations =====
        ('3F800000', '3F800000', '40000000', "T1: 1.0 + 1.0 = 2.0"),
        ('3F800000', '3F000000', '3FC00000', "T2: 1.0 + 0.5 = 1.5"),
        ('3F800000', 'BF800000', '00000000', "T3: 1.0 + (-1.0) = +0.0"),
        ('3FC00000', 'BF400000', '3F400000', "T4: 1.5 + (-0.75) = 0.75"),
        ('41200000', 'C1A00000', 'C1200000', "T5: 10.0 + (-20.0) = -10.0"),

        # ===== Special Values (NaN, Inf, zeros) =====
        ('3F800000', '7FC00000', '7FC00000', "T6: 1.0 + NaN = NaN"),
        ('7F800000', '3F800000', '7F800000', "T7: +Inf + 1.0 = +Inf"),
        ('7F800000', 'FF800000', '7FC00000', "T8: +Inf + (-Inf) = NaN"),
        ('00000000', '3F800000', '3F800000', "T9: +0.0 + 1.0 = 1.0"),
        ('00000000', '80000000', '00000000', "T10: +0.0 + (-0.0) = +0.0"),
        ('80000000', '80000000', '80000000', "T11: -0.0 + (-0.0) = -0.0"),

        # ===== Overflow / Absorption =====
        ('7F7FFFFF', '7F7FFFFF', '7F800000', "T12: Max + Max = +Inf (overflow)"),
        ('FF7FFFFF', 'FF7FFFFF', 'FF800000', "T13: MaxNeg + MaxNeg = -Inf (overflow)"),
        ('3F800000', '00800000', '3F800000', "T14: 1.0 + Smallest Norm = 1.0 (absorption)"),
        ('00400000', '3F800000', '3F800000', "T15: Denormal + 1.0 = 1.0 (absorption)"),

        # ===== Extra: more signed combinations & simple fractions =====
        ('C1200000', '41A00000', '41200000', "T16: -10.0 + 20.0 = 10.0"),
        ('3F400000', '3F400000', '3FC00000', "T17: 0.75 + 0.75 = 1.5"),
        ('BF000000', 'BE800000', 'BF400000', "T18: -0.5 + -0.25 = -0.75"),
        ('BF000000', '3F800000', '3F000000', "T19: -0.5 + 1.0 = 0.5"),

        # ===== Extra: tiny subnormal-ish values =====
        ('0DA24260', '8DA24260', '00000000',
         "T20: 1e-30 + (-1e-30) = 0.0 (cancellation)"),
        ('0DA24260', '0DA24260', '0E224260',
         "T21: 1e-30 + 1e-30 = 2e-30 (denormal add)"),

        # ===== Extra: huge vs small, absorption behavior =====
        ('7149F2CA', 'BF800000', '7149F2CA',
         "T22: 1e30 + (-1.0) ≈ 1e30 (absorption, opposite sign)"),
        ('7149F2CA', '0DA24260', '7149F2CA',
         "T23: 1e30 + 1e-30 ≈ 1e30 (absorption, same sign)"),
    ]

    for a_hex, b_hex, expected_hex, description in test_vectors:
        a_int = int(a_hex, 16)
        b_int = int(b_hex, 16)
        expected_int = int(expected_hex, 16)

        # Apply inputs
        dut.a.value = a_int
        dut.b.value = b_int

        # Wait for combinational logic to settle
        await Timer(1, units="ns")

        actual_int = int(dut.result.value)

        # Logging
        dut._log.info("--- %s ---", description)
        dut._log.info("A: %s (%s)", a_hex, hex_to_float(a_int))
        dut._log.info("B: %s (%s)", b_hex, hex_to_float(b_int))
        dut._log.info("Expected: %s | Actual: %08X", expected_hex, actual_int)

        # Assert correctness (bit-exact)
        assert actual_int == expected_int, (
            f"[FAIL] {description}: "
            f"Actual={actual_int:08X}, Expected={expected_hex}"
        )

        dut._log.info("Result: PASS")

    dut._log.info("FP32 Adder Cocotb Test finished successfully.")
