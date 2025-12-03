import cocotb
from cocotb.triggers import Timer
import struct

# --- Helper: int32 bits -> Python float (for logging) ---
def hex_to_float(hex_int):
    """Converts a 32-bit integer representing an FP32 value to a Python float."""
    return struct.unpack('>f', struct.pack('>I', hex_int))[0]

# --- Helper: check if a 32-bit pattern is NaN ---
def is_nan(bits: int) -> bool:
    """True if bits represent an IEEE-754 single-precision NaN."""
    exp  = (bits >> 23) & 0xFF
    mant = bits & 0x7FFFFF
    return exp == 0xFF and mant != 0

@cocotb.test()
async def test_fp32_mul_vectors(dut):
    """Test the fp32_mul module with a variety of IEEE 754 test vectors."""

    dut._log.info("Starting FP32 Multiplier Cocotb Test")

    # (A_hex, B_hex, Expected_hex, Description)
    test_vectors = [
        # ===== Basic Operations =====
        ('3F800000', '3F800000', '3F800000', "T1: 1.0 * 1.0 = 1.0"),
        ('40000000', '3F000000', '3F800000', "T2: 2.0 * 0.5 = 1.0"),
        ('BF800000', '3FC00000', 'BFC00000', "T3: -1.0 * 1.5 = -1.5"),
        ('C0000000', 'BF400000', '3FC00000', "T4: -2.0 * -0.75 = 1.5"),
        ('40800000', '3E800000', '3F800000', "T5: 4.0 * 0.25 = 1.0"),
        ('41200000', 'C1A00000', 'C3480000', "T6: 10.0 * -20.0 = -200.0"),

        # ===== Special Values (NaN, Inf, zeros) =====
        # Expected_hex here means "NaN", but we will accept any NaN bit pattern.
        ('3F800000', '7FC00000', '7FC00000', "T7: 1.0 * NaN = NaN"),
        ('7F800000', '3FC00000', '7F800000', "T8: +Inf * 1.5 = +Inf"),
        ('FF800000', 'C0000000', '7F800000', "T9: -Inf * -2.0 = +Inf"),
        ('7F800000', '00000000', '7FC00000', "T10: +Inf * +0.0 = NaN (invalid)"),
        ('00000000', '7F800000', '7FC00000', "T11: +0.0 * +Inf = NaN (invalid)"),

        # Zero sign behavior (assuming sign = XOR)
        ('00000000', '40400000', '00000000', "T12: +0.0 * 3.0 = +0.0"),
        ('80000000', '40400000', '80000000', "T13: -0.0 * 3.0 = -0.0"),
        ('80000000', 'C0400000', '00000000', "T14: -0.0 * -3.0 = +0.0"),

        # ===== Overflow / Underflow / Denormals =====
        ('7F7FFFFF', '40000000', '7F800000',
         "T15: Max * 2.0 = +Inf (overflow)"),
        ('00800000', '3F000000', '00400000',
         "T16: MinNorm * 0.5 = subnormal (underflow to 0x00400000)"),
        ('00400000', '40000000', '00800000',
         "T17: Subnormal * 2.0 = MinNorm (0x00800000)"),

        # Tiny values and cancellation
        ('0DA24260', '8DA24260', '80000000',
         "T18: 1e-30 * -1e-30 = -0.0 (very tiny, sign -)"),
        ('0DA24260', '0DA24260', '00000000',
         "T19: 1e-30 * 1e-30 ≈ +0.0 (underflow)"),

        # ===== Huge vs Small, absorption-ish =====
        ('7149F2CA', '0DA24260', '3F800000',
         "T20: 1e30 * 1e-30 ≈ 1.0"),

        # x * 1, x * -1 identity tests
        ('3F800000', '3F800000', '3F800000',
         "T21: 1.0 * 1.0 = 1.0 (identity check)"),
        ('C1200000', 'BF800000', '41200000',
         "T22: -10.0 * -1.0 = 10.0"),
        ('41200000', 'BF800000', 'C1200000',
         "T23: 10.0 * -1.0 = -10.0"),
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