# test_parameterized_adder_fixed.py
import os
import subprocess
from textwrap import dedent

def write_sv_tb(path):
    tb = dedent(r"""
    `timescale 1ns/1ps

    // Fixed-point testbench for parameterized_adder (FORMAT != "FP32")
    module tb_param_adder_fixed;
      localparam int WIDTH     = 32;
      localparam int INT_BITS  = 16;
      localparam int FRAC_BITS = 16;

      // DUT I/O
      logic [WIDTH-1:0] a, b;
      wire  [WIDTH-1:0] result;

      // Instantiate DUT in fixed mode (any string not equal to "FP32" works)
      parameterized_adder #(
        .FORMAT("FIXED"),
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        
        .WIDTH(WIDTH)
      ) dut (
        .a(a),
        .b(b),
        .result(result)
      );

      integer test_cnt, err_cnt;

      // Signed helpers for readability
      function automatic integer to_int(input logic [WIDTH-1:0] x);
        to_int = $signed(x);
      endfunction

      // Saturating signed add (mirrors DUT logic)
      function automatic logic [WIDTH-1:0] sat_add(input logic [WIDTH-1:0] aa,
                                                   input logic [WIDTH-1:0] bb);
        logic signed [WIDTH-1:0] sa, sb, ssum;
        sa   = aa;
        sb   = bb;
        ssum = sa + sb;
        if ((sa[WIDTH-1] == sb[WIDTH-1]) && (ssum[WIDTH-1] != sa[WIDTH-1])) begin
          // overflow -> clamp to max positive or most negative
          sat_add = sa[WIDTH-1] ? {1'b1, {WIDTH-1{1'b0}}} : {1'b0, {WIDTH-1{1'b1}}};
        end
        else begin
          sat_add = ssum;
        end
      endfunction

      // Pack Q16.16 from integer part and fractional float
      function automatic logic [WIDTH-1:0] q16_16(input integer i, input real frac);
        // clamp frac to [-1, 1)
        real f;
        integer frac_raw;
        begin
          f = frac;
          if (f >=  0.999984741) f =  0.999984741; // ~ (2^16-1)/2^16
          if (f <  -1.0)         f = -1.0;
          frac_raw = $rtoi(f * (1<<FRAC_BITS));
          q16_16 = $signed( (i <<< FRAC_BITS) + frac_raw );
        end
      endfunction

      task automatic check(input logic [WIDTH-1:0] aa,
                           input logic [WIDTH-1:0] bb,
                           input string name);
        logic [WIDTH-1:0] exp;
        begin
          a = aa; b = bb;
          #1;
          exp = sat_add(aa, bb);

          $display("Test %0d: %s", test_cnt, name);
          $display("  A = 0x%08x (%0d)  B = 0x%08x (%0d)",
                   aa, to_int(aa), bb, to_int(bb));
          $display("  R = 0x%08x (%0d)  EXP = 0x%08x (%0d)",
                   result, to_int(result), exp, to_int(exp));

          if (result !== exp) begin
            $display("  FAIL");
            err_cnt += 1;
          end
          else begin
            $display("  PASS");
          end
          test_cnt += 1;
          $display("");
        end
      endtask

      initial begin
        test_cnt = 1;
        err_cnt  = 0;

        $display("\n=== parameterized_adder FIXED-POINT tests (Q%0d.%0d) ===\n",
                 INT_BITS, FRAC_BITS);

        // ---------- Directed integer-like (just raw signed 32-bit adds) ----------
        // No overflow (pos + pos)
        check(32'sd10, 32'sd20, "10 + 20 = 30");
        // No overflow (neg + pos)
        check(-32'sd10, 32'sd3, "-10 + 3 = -7");
        // No overflow (neg + neg)
        check(-32'sd100, -32'sd23, "-100 + -23 = -123");

        // Positive overflow: 0x7fffffff + 1 -> clamp to 0x7fffffff
        check(32'h7fffffff, 32'h00000001, "positive overflow -> clamp max");

        // Negative overflow: 0x80000000 + 0xffffffff (-1) -> clamp to 0x80000000
        check(32'h80000000, 32'hffffffff, "negative overflow -> clamp min");

        // Mixed signs should not overflow (e.g., max + min = -1)
        check(32'h7fffffff, 32'h80000000, "max + min (no overflow) = -1");

        // ---------- Fractional Q16.16 checks ----------
        logic [WIDTH-1:0] one, half, minus_half, small, neg_small;
        one        = q16_16(1, 0.0);         // 1.0
        half       = q16_16(0, 0.5);         // 0.5
        minus_half = q16_16(0, -0.5);        // -0.5
        small      = q16_16(0, 0.0625);      // 0.0625
        neg_small  = q16_16(0, -0.0625);     // -0.0625

        // 1.0 + 0.5 = 1.5
        check(one, half, "Q16.16: 1.0 + 0.5 = 1.5");

        // 0.5 + 0.5 = 1.0
        check(half, half, "Q16.16: 0.5 + 0.5 = 1.0");

        // 0.5 + (-0.5) = 0.0
        check(half, minus_half, "Q16.16: 0.5 + (-0.5) = 0.0");

        // small + neg_small = ~0.0
        check(small, neg_small, "Q16.16: small + (-small) ~ 0.0");

        // Overflow with large Q16.16 near max positive
        // (0x7fff0000 ≈ 32767.0) + (0x00020000 ≈ 2.0) -> clamp max
        check(32'h7fff0000, 32'h00020000, "Q16.16: positive overflow near max");

        // Underflow with large negatives -> clamp min
        // (0x80000000 ≈ -32768.0) + (0xfffe0000 ≈ -2.0) -> clamp min
        check(32'h80000000, 32'hfffe0000, "Q16.16: negative overflow near min");

        // ---------- (Optional) Random sanity ----------
        // small random poke to ensure nothing weird (comment out if undesired)
        automatic int i;
        automatic logic [WIDTH-1:0] ra, rb;
        for (i = 0; i < 16; i++) begin
          ra = $random;
          rb = $random;
          check(ra, rb, $sformatf("random %0d", i));
        end

        // Summary
        $display("=== SUMMARY ===");
        $display("Tests: %0d  Errors: %0d", test_cnt-1, err_cnt);
        if (err_cnt == 0) $display("SUCCESS: All fixed-point tests passed!");
        else              $display("FAILURE: Some tests failed.");
        $finish;
      end
    endmodule
    """)
    with open(path, "w") as f:
        f.write(tb)

def find_or_write_dut(build_dir):
    """Try to find your parameterized_adder.sv; otherwise write the provided DUT into build/."""
    candidates = [
        "src_linh/parameterized_adder.sv",
        "src_new/parameterized_adder.sv",
        "parameterized_adder.sv",
    ]
    for c in candidates:
        if os.path.exists(c):
            return c

    # Fallback: write the provided module into build/
    dut_code = dedent(r"""
    module parameterized_adder #(
        parameter FORMAT = "FP32", 
        parameter INT_BITS = 16,
        parameter FRAC_BITS = 16,
        parameter WIDTH = 32
    ) (
        input  logic [WIDTH-1:0] a, b,
        output logic [WIDTH-1:0] result
    );

    logic a_sign, b_sign, result_sign;
    logic [7:0] a_exp, b_exp, larger_exp, exp_diff;
    logic [22:0] a_mant, b_mant;
    logic [23:0] a_mant_ext, b_mant_ext;
    logic [24:0] sum_mant;

    logic a_nan, b_nan, a_inf, b_inf, a_zero, b_zero;

    generate
        if (FORMAT == "FP32") begin : fp32_mode
            assign a_sign = a[31];
            assign a_exp  = a[30:23];
            assign a_mant = a[22:0];
            
            assign b_sign = b[31];
            assign b_exp  = b[30:23];
            assign b_mant = b[22:0];
            
            assign a_nan  = (a_exp == 8'hFF) && (a_mant != 0);
            assign b_nan  = (b_exp == 8'hFF) && (b_mant != 0);
            assign a_inf  = (a_exp == 8'hFF) && (a_mant == 0);
            assign b_inf  = (b_exp == 8'hFF) && (b_mant == 0);
            assign a_zero = (a_exp == 8'h00) && (a_mant == 0);
            assign b_zero = (b_exp == 8'h00) && (b_mant == 0);
            
            always_comb begin
                if (a_nan || b_nan) begin
                    result = 32'h7FC00000;  // NaN
                end
                else if (a_inf && b_inf) begin
                    result = (a_sign == b_sign) ? {a_sign, 8'hFF, 23'h0} : 32'h7FC00000;
                end
                else if (a_inf) begin
                    result = {a_sign, 8'hFF, 23'h0};
                end
                else if (b_inf) begin
                    result = {b_sign, 8'hFF, 23'h0};
                end
                else begin
                    a_mant_ext = (a_exp == 8'h00) ? {1'b0, a_mant} : {1'b1, a_mant};
                    b_mant_ext = (b_exp == 8'h00) ? {1'b0, b_mant} : {1'b1, b_mant};
                    
                    if (a_exp >= b_exp) begin
                        larger_exp = a_exp;
                        exp_diff = a_exp - b_exp;
                        b_mant_ext = b_mant_ext >> exp_diff;
                    end else begin
                        larger_exp = b_exp;
                        exp_diff = b_exp - a_exp;
                        a_mant_ext = a_mant_ext >> exp_diff;
                    end
                    
                    if (a_sign == b_sign) begin
                        sum_mant = a_mant_ext + b_mant_ext;
                        result_sign = a_sign;
                    end else begin
                        if (a_mant_ext >= b_mant_ext) begin
                            sum_mant = a_mant_ext - b_mant_ext;
                            result_sign = a_sign;
                        end else begin
                            sum_mant = b_mant_ext - a_mant_ext;
                            result_sign = b_sign;
                        end
                    end
                    
                    if (sum_mant[24]) begin
                        sum_mant = sum_mant >> 1;
                        larger_exp = larger_exp + 1;
                    end else if (sum_mant[23:0] != 0) begin
                        sum_mant = sum_mant << 1;
                        larger_exp = larger_exp - 1;
                    end
                    
                    if (larger_exp >= 8'hFF) begin
                        result = {result_sign, 8'hFF, 23'h0}; 
                    end else if (larger_exp == 8'h00) begin
                        result = {result_sign, 8'h00, 23'h0};
                    end else begin
                        result = {result_sign, larger_exp, sum_mant[22:0]};
                    end
                end
            end
        end 
        else begin : fixed_point_mode
            logic [WIDTH-1:0] sum;
            logic overflow;
            
            assign sum = a + b;
            assign overflow = (a[WIDTH-1] == b[WIDTH-1]) && (sum[WIDTH-1] != a[WIDTH-1]);
            
            always_comb begin
                if (overflow) begin
                    result = a[WIDTH-1] ? {1'b1, {WIDTH-1{1'b0}}} : {1'b0, {WIDTH-1{1'b1}}};
                end else begin
                    result = sum;
                end
            end
        end
    endgenerate

    endmodule
    """)
    dut_path = os.path.join(build_dir, "parameterized_adder.sv")
    with open(dut_path, "w") as f:
        f.write(dut_code)
    return dut_path

def run():
    os.makedirs("build", exist_ok=True)
    tb_path = "build/tb_param_adder_fixed.sv"
    write_sv_tb(tb_path)

    dut_path = find_or_write_dut("build")

    print("Compiling with iverilog...")
    cmd = ["iverilog", "-g2012", "-o", "build/adder_fixed_tb", tb_path, dut_path]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print("=== COMPILE ERROR ===")
        print(r.stderr)
        return False
    if r.stderr:
        print("iverilog warnings:")
        print(r.stderr)

    print("Running vvp...")
    r = subprocess.run(["vvp", "build/adder_fixed_tb"], capture_output=True, text=True)
    print("=== SIM OUTPUT ===")
    print(r.stdout)
    if r.stderr:
        print("=== SIM ERR ===")
        print(r.stderr)

    ok = "SUCCESS: All fixed-point tests passed!" in r.stdout
    print("RESULT:", "PASS" if ok else "FAIL")
    return ok

if __name__ == "__main__":
    run()