// Synthesis-friendly FP32 adder with proper default assignments
// Modified from original to prevent latch inference in Yosys
module fp32_add #(
    parameter FORMAT = "FP32", 
    parameter INT_BITS = 16,
    parameter FRAC_BITS = 16,
    parameter WIDTH = 32
    ) (
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] result
);

logic a_sign, b_sign, result_sign;
logic [7:0] a_exp, b_exp, larger_exp, exp_diff, result_exp;
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
            // Default assignments to prevent latch inference
            result = 32'h00000000;
            result_sign = 1'b0;
            result_exp = 8'h00;
            a_mant_ext = 24'h0;
            b_mant_ext = 24'h0;
            larger_exp = 8'h00;
            exp_diff = 8'h00;
            sum_mant = 25'h0;
            
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
            else if (a_zero && b_zero) begin
                result = {a_sign & b_sign, 8'h00, 23'h0}; 
            end
            else if (a_zero) begin
                result = b;
            end
            else if (b_zero) begin
                result = a;
            end
            else begin
                // fp32 addition logic
                a_mant_ext = (a_exp == 8'h00) ? {1'b0, a_mant} : {1'b1, a_mant};
                b_mant_ext = (b_exp == 8'h00) ? {1'b0, b_mant} : {1'b1, b_mant};
                
                // align exponents
                if (a_exp >= b_exp) begin
                    larger_exp = a_exp;
                    exp_diff = a_exp - b_exp;
                    b_mant_ext = b_mant_ext >> exp_diff;
                end else begin
                    larger_exp = b_exp;
                    exp_diff = b_exp - a_exp;
                    a_mant_ext = a_mant_ext >> exp_diff;
                end
                
                // add/sub mantissas
                if (a_sign == b_sign) begin
                    sum_mant = {1'b0, a_mant_ext} + {1'b0, b_mant_ext};
                    result_sign = a_sign;
                end else begin
                    if (a_mant_ext >= b_mant_ext) begin
                        sum_mant = {1'b0, a_mant_ext} - {1'b0, b_mant_ext};
                        result_sign = a_sign;
                    end else begin
                        sum_mant = {1'b0, b_mant_ext} - {1'b0, a_mant_ext};
                        result_sign = b_sign;
                    end
                end
                
                result_exp = larger_exp;
                
                // Normalize - unrolled to avoid for loop with integer
                if (sum_mant[24]) begin
                    sum_mant = sum_mant >> 1;
                    result_exp = result_exp + 1;
                end 
                else if (!sum_mant[23]) begin
                    // Leading zero detection - priority encoder style
                    if (sum_mant[22]) begin
                        sum_mant = sum_mant << 1;
                        result_exp = result_exp - 1;
                    end else if (sum_mant[21]) begin
                        sum_mant = sum_mant << 2;
                        result_exp = result_exp - 2;
                    end else if (sum_mant[20]) begin
                        sum_mant = sum_mant << 3;
                        result_exp = result_exp - 3;
                    end else if (sum_mant[19]) begin
                        sum_mant = sum_mant << 4;
                        result_exp = result_exp - 4;
                    end else if (sum_mant[18]) begin
                        sum_mant = sum_mant << 5;
                        result_exp = result_exp - 5;
                    end else if (sum_mant[17]) begin
                        sum_mant = sum_mant << 6;
                        result_exp = result_exp - 6;
                    end else if (sum_mant[16]) begin
                        sum_mant = sum_mant << 7;
                        result_exp = result_exp - 7;
                    end else if (sum_mant[15]) begin
                        sum_mant = sum_mant << 8;
                        result_exp = result_exp - 8;
                    end else if (sum_mant[14]) begin
                        sum_mant = sum_mant << 9;
                        result_exp = result_exp - 9;
                    end else if (sum_mant[13]) begin
                        sum_mant = sum_mant << 10;
                        result_exp = result_exp - 10;
                    end else if (sum_mant[12]) begin
                        sum_mant = sum_mant << 11;
                        result_exp = result_exp - 11;
                    end else if (sum_mant[11]) begin
                        sum_mant = sum_mant << 12;
                        result_exp = result_exp - 12;
                    end else if (sum_mant[10]) begin
                        sum_mant = sum_mant << 13;
                        result_exp = result_exp - 13;
                    end else if (sum_mant[9]) begin
                        sum_mant = sum_mant << 14;
                        result_exp = result_exp - 14;
                    end else if (sum_mant[8]) begin
                        sum_mant = sum_mant << 15;
                        result_exp = result_exp - 15;
                    end else if (sum_mant[7]) begin
                        sum_mant = sum_mant << 16;
                        result_exp = result_exp - 16;
                    end else if (sum_mant[6]) begin
                        sum_mant = sum_mant << 17;
                        result_exp = result_exp - 17;
                    end else if (sum_mant[5]) begin
                        sum_mant = sum_mant << 18;
                        result_exp = result_exp - 18;
                    end else if (sum_mant[4]) begin
                        sum_mant = sum_mant << 19;
                        result_exp = result_exp - 19;
                    end else if (sum_mant[3]) begin
                        sum_mant = sum_mant << 20;
                        result_exp = result_exp - 20;
                    end else if (sum_mant[2]) begin
                        sum_mant = sum_mant << 21;
                        result_exp = result_exp - 21;
                    end else if (sum_mant[1]) begin
                        sum_mant = sum_mant << 22;
                        result_exp = result_exp - 22;
                    end else if (sum_mant[0]) begin
                        sum_mant = sum_mant << 23;
                        result_exp = result_exp - 23;
                    end
                end
                
                if (sum_mant == 0) begin
                    result = 32'h00000000;
                end
                else if (result_exp >= 8'hFF) begin
                    result = {result_sign, 8'hFF, 23'h0}; 
                end 
                else if (result_exp == 8'h00) begin
                    result = {result_sign, 8'h00, 23'h0};
                end 
                else begin
                    result = {result_sign, result_exp, sum_mant[22:0]};
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
            // Default assignment
            result = sum;
            if (overflow) begin
                result = a[WIDTH-1] ? {1'b1, {WIDTH-1{1'b0}}} : {1'b0, {WIDTH-1{1'b1}}};
            end
        end
    end
endgenerate

endmodule