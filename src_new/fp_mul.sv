module parameterized_multiplier #(
    parameter FORMAT = "FP32"
)(
    input logic [31:0] a,
    input logic [31:0] b, 
    output logic [31:0] result
);

generate
    if (FORMAT == "FP32") begin : fp32_mode
        logic a_sign, b_sign, result_sign;
        logic [7:0] a_exp, b_exp, result_exp;
        logic [23:0] a_mant, b_mant;
        logic [47:0] product_mant;
        logic [23:0] result_mant;
        logic normalize_done;
        integer i;
        
        always_comb begin
            a_sign = a[31];
            b_sign = b[31];
            a_exp = a[30:23];
            b_exp = b[30:23];
            a_mant = (a_exp == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant = (b_exp == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            
            // Multiply mantissas
            product_mant = a_mant * b_mant;
            
            // Add exponents and subtract bias (127)
            result_exp = a_exp + b_exp - 8'd127;
            result_sign = a_sign ^ b_sign;
            
            // Normalize - without break statement
            result_mant = product_mant[46:23];
            normalize_done = 1'b0;
            
            if (product_mant[47]) begin
                // Overflow case - shift right
                result_mant = product_mant >> 24;
                result_exp = result_exp + 1;
                normalize_done = 1'b1;
            end else if (product_mant[46]) begin
                // Already normalized
                result_mant = product_mant[46:23];
                normalize_done = 1'b1;
            end
            
            if (!normalize_done) begin
                // Find first 1 and shift left
                for (i = 45; i >= 0; i = i - 1) begin
                    if (product_mant[i] && !normalize_done) begin
                        result_mant = product_mant << (46 - i);
                        result_exp = result_exp - (46 - i);
                        normalize_done = 1'b1;
                    end
                end
            end
            
            // Handle special cases
            if (a_exp == 8'hFF || b_exp == 8'hFF) begin
                // Infinity or NaN
                if ((a_exp == 8'hFF && a_mant[22:0] != 0) || 
                    (b_exp == 8'hFF && b_mant[22:0] != 0)) begin
                    result = 32'h7FC00000; // NaN
                end else begin
                    result = {result_sign, 8'hFF, 23'h0}; // Infinity
                end
            end else if (result_exp[7] && result_exp != 8'h00) begin
                // Underflow
                result = {result_sign, 8'h00, 23'h0};
            end else if (result_exp >= 8'hFF) begin
                // Overflow
                result = {result_sign, 8'hFF, 23'h0};
            end else begin
                result = {result_sign, result_exp, result_mant[22:0]};
            end
        end
    end else begin : fixed_point_mode
        assign result = a * b;
    end
endgenerate

endmodule