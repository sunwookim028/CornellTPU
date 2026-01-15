// Synthesis-friendly FP32 multiplier with proper default assignments
// Modified from original to prevent latch inference in Yosys
module fp32_mul#(
  parameter FORMAT = "FP32",
  parameter INT_BITS = 16,
  parameter FRAC_BITS = 16,
  parameter WIDTH = 32
)(
  input [31:0] a, b,
  output reg [31:0] result
);

reg [23:0] a_m, b_m, z_m;
reg [9:0] a_e, b_e, z_e;
reg a_s, b_s, z_s;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(*) begin
    // Default assignments to prevent latch inference
    a_m = {1'b0, a[22:0]};
    b_m = {1'b0, b[22:0]};
    a_e = a[30:23] - 127;
    b_e = b[30:23] - 127;
    a_s = a[31];
    b_s = b[31];
    z_m = 24'h0;
    z_e = 10'h0;
    z_s = 1'b0;
    product = 50'h0;
    guard_bit = 1'b0;
    round_bit = 1'b0;
    sticky = 1'b0;
    result = 32'h0;
    
    if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin // NAN
        result = {1'b1, 8'hFF, 1'b1, 22'h0};
    end
    else if (a_e == 128) begin // INF A
        if (($signed(b_e) == -127) && (b_m == 0)) begin // NAN IF B = 0
            result = {1'b1, 8'hFF, 1'b1, 22'h0};
        end else begin
            result = {a_s ^ b_s, 8'hFF, 23'h0};
        end
    end
    else if (b_e == 128) begin // INF B
        if (($signed(a_e) == -127) && (a_m == 0)) begin // NAN IF A = 0
            result = {1'b1, 8'hFF, 1'b1, 22'h0};
        end else begin
            result = {a_s ^ b_s, 8'hFF, 23'h0};
        end
    end
    else if (($signed(a_e) == -127) && (a_m == 0)) begin // 0 if A = 0
        result = {a_s ^ b_s, 8'h0, 23'h0};
    end
    else if (($signed(b_e) == -127) && (b_m == 0)) begin // 0 if B = 0
        result = {a_s ^ b_s, 8'h0, 23'h0};
    end
    else begin
        if ($signed(a_e) == -127) begin 
            a_e = -126;
        end else begin
            a_m[23] = 1'b1;
        end
        
        if ($signed(b_e) == -127) begin 
            b_e = -126;
        end else begin
            b_m[23] = 1'b1;
        end
        
        if (~a_m[23]) begin
            a_m = a_m << 1;
            a_e = a_e - 1;
        end
        if (~b_m[23]) begin 
            b_m = b_m << 1;
            b_e = b_e - 1;
        end
        
        z_s = a_s ^ b_s;
        z_e = a_e + b_e + 1;
        product = a_m * b_m * 4;
        
        z_m = product[49:26];
        guard_bit = product[25];
        round_bit = product[24];
        sticky = (product[23:0] != 0);
        
        // underflow
        if ($signed(z_e) < -126) begin
            z_e = z_e + (-126 - $signed(z_e));
            z_m = z_m >> (-126 - $signed(z_e));
            guard_bit = z_m[0];
            round_bit = guard_bit;
            sticky = sticky | round_bit;
        end
        else if (z_m[23] == 0) begin
            z_e = z_e - 1;
            z_m = z_m << 1;
            z_m[0] = guard_bit;
            guard_bit = round_bit;
            round_bit = 1'b0;
        end
        // round
        else if (guard_bit && (round_bit | sticky | z_m[0])) begin
            z_m = z_m + 1;
            if (z_m == 24'hffffff) begin
                z_e = z_e + 1;
            end
        end
        
        result[22:0] = z_m[22:0];
        result[30:23] = z_e[7:0] + 127;
        result[31] = z_s;
        
        if ($signed(z_e) == -126 && z_m[23] == 0) begin
            result[30:23] = 8'h0;
        end
        
        // overflow
        if ($signed(z_e) > 127) begin 
            result[22:0] = 23'h0;
            result[30:23] = 8'hFF;
            result[31] = z_s;
        end
    end
end

endmodule