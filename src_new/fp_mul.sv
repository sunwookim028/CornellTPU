module parameterized_multiplier #(
    parameter FORMAT = "FP32", 
    parameter INT_BITS = 16,
    parameter FRAC_BITS = 16,
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] result
);

logic a_sign, b_sign, result_sign;
logic [7:0] a_exp, b_exp, result_exp;
logic [22:0] a_mant, b_mant;
logic [23:0] a_mant_ext, b_mant_ext;
logic [47:0] product_mant;

logic a_nan, b_nan, a_inf, b_inf, a_zero, b_zero;
logic overflow, underflow;

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
            else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                result = 32'h7FC00000;  // NaN: inf * 0
            end
            else if (a_inf || b_inf) begin
                result = {a_sign ^ b_sign, 8'hFF, 23'h0};  // inf
            end
            else if (a_zero || b_zero) begin
                result = {a_sign ^ b_sign, 8'h00, 23'h0};  // zero
            end
            else begin
                // fp32 multiplication logic
                a_mant_ext = (a_exp == 8'h00) ? {1'b0, a_mant} : {1'b1, a_mant};
                b_mant_ext = (b_exp == 8'h00) ? {1'b0, b_mant} : {1'b1, b_mant};
                
                // multiply mantissas
                product_mant = a_mant_ext * b_mant_ext;
                
                // add exponents (subtract bias 127)
                result_exp = a_exp + b_exp - 8'd127;
                
                // normalize product
                if (product_mant[47]) begin
                    product_mant = product_mant >> 1;
                    result_exp = result_exp + 1;
                end else if (product_mant[46]) begin
                    // already normalized
                end else begin
                    // need to shift left to normalize
                    for (int i = 45; i >= 0; i--) begin
                        if (product_mant[i]) begin
                            product_mant = product_mant << (46 - i);
                            result_exp = result_exp - (46 - i);
                        end
                    end
                end
                
                // check for overflow/underflow
                overflow = (result_exp >= 8'hFF);
                underflow = (result_exp == 8'h00) || (result_exp[7] && (result_exp != 8'h00));
                
                // handle special cases
                if (overflow) begin
                    result = {a_sign ^ b_sign, 8'hFF, 23'h0};  // inf
                end else if (underflow) begin
                    result = {a_sign ^ b_sign, 8'h00, 23'h0};  // zero
                end else begin
                    result_sign = a_sign ^ b_sign;
                    result = {result_sign, result_exp, product_mant[45:23]};  // round to 23 bits
                end
            end
        end
    end 
    else begin : fixed_point_mode
        logic signed [WIDTH-1:0] a_signed, b_signed;
        logic signed [WIDTH*2-1:0] product_full;
        logic [WIDTH-1:0] product_truncated;
        logic overflow_positive, overflow_negative;
        
        assign a_signed = a;
        assign b_signed = b;
        
        assign product_full = a_signed * b_signed;
        
        assign product_truncated = product_full[WIDTH-1+FRAC_BITS:FRAC_BITS];
        
        assign overflow_positive = (a_signed > 0 && b_signed > 0 && product_truncated[WIDTH-1] == 1);
        assign overflow_negative = (a_signed < 0 && b_signed < 0 && product_truncated[WIDTH-1] == 0);
        
        always_comb begin
            if (overflow_positive) begin
                result = {1'b0, {WIDTH-1{1'b1}}};
            end else if (overflow_negative) begin
                result = {1'b1, {WIDTH-1{1'b0}}};
            end else begin
                result = product_truncated;
            end
        end
    end
endgenerate

endmodule