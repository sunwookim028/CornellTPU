module fp32_adder (
    input  logic [31:0] a, b,
    output logic [31:0] result
);
logic a_sign, b_sign;
logic [7:0]  a_exp, b_exp;
logic [22:0] a_mant, b_mant;

assign a_sign = a[31];
assign a_exp  = a[30:23];
assign a_mant = a[22:0];

assign b_sign = b[31];
assign b_exp  = b[30:23];
assign b_mant = b[22:0];

logic a_nan, b_nan, a_inf, b_inf, a_zero, b_zero;

assign a_nan  = (a_exp == 8'hFF) && (a_mant != 0);
assign b_nan  = (b_exp == 8'hFF) && (b_mant != 0);
assign a_inf  = (a_exp == 8'hFF) && (a_mant == 0);
assign b_inf  = (b_exp == 8'hFF) && (b_mant == 0);
assign a_zero = (a_exp == 8'h00) && (a_mant == 0);
assign b_zero = (b_exp == 8'h00) && (b_mant == 0);

logic [7:0]  exp_diff;
logic [7:0]  larger_exp;
logic [23:0] a_mant_ext, b_mant_ext; 
logic [24:0] sum_mant;
logic result_sign;

always_comb begin
  if (a_nan || b_nan) begin
    result = 32'h7FC00000;
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
    // Normal numbers: Add hidden bit
    a_mant_ext = (a_exp == 8'h00) ? {1'b0, a_mant} : {1'b1, a_mant};
    b_mant_ext = (b_exp == 8'h00) ? {1'b0, b_mant} : {1'b1, b_mant};
    
    // Align exponents
    if (a_exp >= b_exp) begin
      larger_exp = a_exp;
      exp_diff = a_exp - b_exp;
      b_mant_ext = b_mant_ext >> exp_diff;
    end else begin
      larger_exp = b_exp;
      exp_diff = b_exp - a_exp;
      a_mant_ext = a_mant_ext >> exp_diff;
    end
    
    // Perform addition/subtraction
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
      for (int i = 22; i >= 0; i--) begin
        if (sum_mant[23]) break;
        sum_mant = sum_mant << 1;
        larger_exp = larger_exp - 1;
      end
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

endmodule