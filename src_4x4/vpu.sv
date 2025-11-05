// Top-level VPU module connecting vpu_ctrl and vpu_dpath
`timescale 1ns/1ps
`default_nettype none

module vpu #(
  parameter int DATA_W = 16,
  parameter int ADDR_W = 10,
  parameter int B = 8,        // batch size (K in spec)
  parameter int D_OUT = 4     // output features (M in spec)
)(
  input logic clk,
  input logic rst,

  // Unified Buffer (UB) Interface
  input logic ub_req_rdy,           // UB ready to accept request for data
  output logic ub_req_val,          // VPU sending valid addr request
  
  // Address outputs to UB
  output logic [ADDR_W-1:0] addr_Z_prime,  // Input data address (Z')
  output logic [ADDR_W-1:0] addr_b,        // Bias data address  
  output logic [ADDR_W-1:0] addr_Z,        // VPU output data address

  // Data interfaces with UB - use consistent 64-bit notation
  input logic [63:0] data_Z_prime [0:B-1],   // 8 banks x 64b input data from UB
  input logic [63:0] data_b,                 // Bias data from UB
  output logic [63:0] data_Z [0:B-1],        // 8 banks x 64b output data to UB

  // Control signals
  input logic [3:0] vpu_data_pathway,    // Operation mode control
  output logic vpu_busy,                 // VPU busy signal

  // Debug/Monitor outputs
  output logic signed [DATA_W-1:0] debug_vpu_out_1,
  output logic signed [DATA_W-1:0] debug_vpu_out_2,
  output logic signed [DATA_W-1:0] debug_vpu_out_3,
  output logic signed [DATA_W-1:0] debug_vpu_out_4,
  output logic debug_valid_out
);

  // Internal signals between control and datapath
  logic signed [DATA_W-1:0] vpu_data_in_1;
  logic signed [DATA_W-1:0] vpu_data_in_2;
  logic signed [DATA_W-1:0] vpu_data_in_3;
  logic signed [DATA_W-1:0] vpu_data_in_4;
  logic vpu_valid_in_1;
  logic vpu_valid_in_2;
  logic vpu_valid_in_3;
  logic vpu_valid_in_4;

  logic signed [DATA_W-1:0] bias_scalar_in_1;
  logic signed [DATA_W-1:0] bias_scalar_in_2;
  logic signed [DATA_W-1:0] bias_scalar_in_3;
  logic signed [DATA_W-1:0] bias_scalar_in_4;
  logic signed [DATA_W-1:0] lr_leak_factor_in;

  logic signed [DATA_W-1:0] vpu_data_out_1;
  logic signed [DATA_W-1:0] vpu_data_out_2;
  logic signed [DATA_W-1:0] vpu_data_out_3;
  logic signed [DATA_W-1:0] vpu_data_out_4;
  logic vpu_valid_out_1;
  logic vpu_valid_out_2;
  logic vpu_valid_out_3;
  logic vpu_valid_out_4;

  // Instantiate control unit
  vpu_ctrl #(
    .DATA_W(DATA_W),
    .ADDR_W(ADDR_W),
    .B(B),
    .D_OUT(D_OUT)
  ) ctrl_inst (
    .clk(clk),
    .rst(rst),
    
    // UB Interface
    .ub_req_rdy(ub_req_rdy),
    .ub_req_val(ub_req_val),
    .addr_Z_prime(addr_Z_prime),
    .addr_b(addr_b),
    .addr_Z(addr_Z),
    .data_Z_prime(data_Z_prime),
    .data_b(data_b),
    .data_Z(data_Z),
    
    // VPU Datapath Interface
    .vpu_data_in_1(vpu_data_in_1),
    .vpu_data_in_2(vpu_data_in_2),
    .vpu_data_in_3(vpu_data_in_3),
    .vpu_data_in_4(vpu_data_in_4),
    .vpu_valid_in_1(vpu_valid_in_1),
    .vpu_valid_in_2(vpu_valid_in_2),
    .vpu_valid_in_3(vpu_valid_in_3),
    .vpu_valid_in_4(vpu_valid_in_4),
    
    .bias_scalar_in_1(bias_scalar_in_1),
    .bias_scalar_in_2(bias_scalar_in_2),
    .bias_scalar_in_3(bias_scalar_in_3),
    .bias_scalar_in_4(bias_scalar_in_4),
    .lr_leak_factor_in(lr_leak_factor_in),
    
    .vpu_data_out_1(vpu_data_out_1),
    .vpu_data_out_2(vpu_data_out_2),
    .vpu_data_out_3(vpu_data_out_3),
    .vpu_data_out_4(vpu_data_out_4),
    .vpu_valid_out_1(vpu_valid_out_1),
    .vpu_valid_out_2(vpu_valid_out_2),
    .vpu_valid_out_3(vpu_valid_out_3),
    .vpu_valid_out_4(vpu_valid_out_4),
    
    .vpu_data_pathway(vpu_data_pathway),
    .vpu_busy(vpu_busy)
  );

  // Instantiate datapath unit
  vpu_dpath datapath_inst (
    .clk(clk),
    .rst(rst),
    .vpu_data_pathway(vpu_data_pathway),
    
    // Inputs from control unit
    .vpu_data_in_1(vpu_data_in_1),
    .vpu_data_in_2(vpu_data_in_2),
    .vpu_data_in_3(vpu_data_in_3),
    .vpu_data_in_4(vpu_data_in_4),
    .vpu_valid_in_1(vpu_valid_in_1),
    .vpu_valid_in_2(vpu_valid_in_2),
    .vpu_valid_in_3(vpu_valid_in_3),
    .vpu_valid_in_4(vpu_valid_in_4),
    
    // Bias inputs from control unit
    .bias_scalar_in_1(bias_scalar_in_1),
    .bias_scalar_in_2(bias_scalar_in_2),
    .bias_scalar_in_3(bias_scalar_in_3),
    .bias_scalar_in_4(bias_scalar_in_4),
    .lr_leak_factor_in(lr_leak_factor_in),
    
    // Outputs to control unit
    .vpu_data_out_1(vpu_data_out_1),
    .vpu_data_out_2(vpu_data_out_2),
    .vpu_data_out_3(vpu_data_out_3),
    .vpu_data_out_4(vpu_data_out_4),
    .vpu_valid_out_1(vpu_valid_out_1),
    .vpu_valid_out_2(vpu_valid_out_2),
    .vpu_valid_out_3(vpu_valid_out_3),
    .vpu_valid_out_4(vpu_valid_out_4)
  );

  // Debug outputs - connect to datapath outputs for monitoring
  assign debug_vpu_out_1 = vpu_data_out_1;
  assign debug_vpu_out_2 = vpu_data_out_2;
  assign debug_vpu_out_3 = vpu_data_out_3;
  assign debug_vpu_out_4 = vpu_data_out_4;
  assign debug_valid_out = vpu_valid_out_1; // Use first lane as valid indicator

endmodule