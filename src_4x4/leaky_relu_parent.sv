`timescale 1ns/1ps
`default_nettype none

module leaky_relu_parent (
    input logic clk,
    input logic rst,
    input logic signed [15:0] lr_leak_factor_in,

    input logic lr_valid_1_in,
    input logic lr_valid_2_in,
    input logic lr_valid_3_in,
    input logic lr_valid_4_in,

    input logic signed [15:0] lr_data_1_in,
    input logic signed [15:0] lr_data_2_in,
    input logic signed [15:0] lr_data_3_in,
    input logic signed [15:0] lr_data_4_in,
    
    output logic signed [15:0] lr_data_1_out,
    output logic signed [15:0] lr_data_2_out,
    output logic signed [15:0] lr_data_3_out,
    output logic signed [15:0] lr_data_4_out,
    
    output logic lr_valid_1_out,
    output logic lr_valid_2_out,
    output logic lr_valid_3_out,
    output logic lr_valid_4_out
);

  leaky_relu_child leaky_relu_col_1 (
    .clk(clk),
    .rst(rst),
    .lr_valid_in(lr_valid_1_in),
    .lr_data_in(lr_data_1_in),
    .lr_leak_factor_in(lr_leak_factor_in),
    .lr_data_out(lr_data_1_out),
    .lr_valid_out(lr_valid_1_out)
  );

  leaky_relu_child leaky_relu_col_2 (
    .clk(clk),
    .rst(rst),
    .lr_valid_in(lr_valid_2_in),
    .lr_data_in(lr_data_2_in),
    .lr_leak_factor_in(lr_leak_factor_in),
    .lr_data_out(lr_data_2_out),
    .lr_valid_out(lr_valid_2_out)
  );

  leaky_relu_child leaky_relu_col_3 (
    .clk(clk),
    .rst(rst),
    .lr_valid_in(lr_valid_3_in),
    .lr_data_in(lr_data_3_in),
    .lr_leak_factor_in(lr_leak_factor_in),
    .lr_data_out(lr_data_3_out),
    .lr_valid_out(lr_valid_3_out)
  );

  leaky_relu_child leaky_relu_col_4 (
    .clk(clk),
    .rst(rst),
    .lr_valid_in(lr_valid_4_in),
    .lr_data_in(lr_data_4_in),
    .lr_leak_factor_in(lr_leak_factor_in),
    .lr_data_out(lr_data_4_out),
    .lr_valid_out(lr_valid_4_out)
  );

endmodule