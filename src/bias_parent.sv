`timescale 1ns/1ps
`default_nettype none

module bias_parent(
    input  logic                clk,
    input  logic                rst,

    // Bias scalars fetched from the Unified Buffer (per column/neuron)
    input  logic signed [15:0]  bias_scalar_ub_in_1,
    input  logic signed [15:0]  bias_scalar_ub_in_2,

    // NEW: pulse high exactly when a new column/neuron starts
    input  logic                bias_load_en_1,
    input  logic                bias_load_en_2,

    // Stream from systolic array
    input  logic signed [15:0]  bias_sys_data_in_1,
    input  logic signed [15:0]  bias_sys_data_in_2,
    input  logic                bias_sys_valid_in_1,
    input  logic                bias_sys_valid_in_2,

    // Stream out (after bias add)
    output logic                bias_Z_valid_out_1,
    output logic                bias_Z_valid_out_2,
    output logic signed [15:0]  bias_z_data_out_1,
    output logic signed [15:0]  bias_z_data_out_2
);

  // Each child handles one output column/neuron.
  // Child latches bias_scalar_ub_in_* only when bias_load_en_* is asserted.

  bias_child column_1 (
    .clk              ( clk ),
    .rst              ( rst ),
    .bias_load_en     ( bias_load_en_1 ),       // NEW
    .bias_scalar_ub_in( bias_scalar_ub_in_1 ),  // renamed
    .bias_sys_data_in ( bias_sys_data_in_1 ),
    .bias_sys_valid_in( bias_sys_valid_in_1 ),
    .bias_Z_valid_out ( bias_Z_valid_out_1 ),
    .bias_z_data_out  ( bias_z_data_out_1 )
  );

  bias_child column_2 (
    .clk              ( clk ),
    .rst              ( rst ),
    .bias_load_en     ( bias_load_en_2 ),       // NEW
    .bias_scalar_ub_in( bias_scalar_ub_in_2 ),  // renamed
    .bias_sys_data_in ( bias_sys_data_in_2 ),
    .bias_sys_valid_in( bias_sys_valid_in_2 ),
    .bias_Z_valid_out ( bias_Z_valid_out_2 ),
    .bias_z_data_out  ( bias_z_data_out_2 )
  );

endmodule
