//------------------------------------------------------------------------------
// VPU Top: integrates control + datapath
// Exposes a clean memory-side interface + done pulse
//------------------------------------------------------------------------------
`timescale 1ns/1ps
`default_nettype none

module vpu #(
  parameter int DATA_W        = 32,
  parameter int ADDR_W        = 16,
  parameter int OP_W          = 4,
  parameter int INST_ADDR     = 5,
  // datapath options
  parameter bit HAS_FP_ADDER  = 0    // use integer/FXP add/sub in datapath
)(
  input  logic                 clk,
  input  logic                 rst,

  // 32b instruction
  input  logic [31:0]          inst,

  // Memory handshakes
  input  logic                 mem_rdy,
  input  logic                 mem_read_en,
  input  logic                 mem_write_en,

  // Addresses
  output logic [ADDR_W-1:0]    addr_a,
  output logic [ADDR_W-1:0]    addr_b,
  output logic [ADDR_W-1:0]    addr_c,

  // Data
  input  logic [DATA_W-1:0]    data_a,
  input  logic [DATA_W-1:0]    data_b,
  output logic [DATA_W-1:0]    data_c,

  // Done pulse
  output logic                 done
);

  // control ↔ datapath wires
  logic                 dp_start;
  logic [OP_W-1:0]      dp_opcode;
  logic [DATA_W-1:0]    dp_operand0, dp_operand1;
  logic [DATA_W-1:0]    dp_result;
  logic                 dp_op_valid;

  // ---------------- Control (explicit mapping) ----------------
  vpu_control #(
    .DATA_W    (DATA_W),
    .ADDR_W    (ADDR_W),
    .OP_W      (OP_W),
    .INST_ADDR (INST_ADDR)
  ) u_ctrl (
    .clk          (clk),
    .rst          (rst),

    .inst         (inst),

    .mem_rdy      (mem_rdy),
    .mem_read_en  (mem_read_en),
    .mem_write_en (mem_write_en),

    .addr_a       (addr_a),
    .addr_b       (addr_b),
    .addr_c       (addr_c),

    .data_a       (data_a),
    .data_b       (data_b),
    .data_c       (data_c),

    .dp_start     (dp_start),
    .dp_opcode    (dp_opcode),
    .dp_operand0  (dp_operand0),
    .dp_operand1  (dp_operand1),
    .dp_result    (dp_result),
    .dp_op_valid  (dp_op_valid),

    .done         (done)
  );

  // ---------------- Datapath (explicit mapping) ---------------
  vpu_datapath #(
    .DATA_W       (DATA_W),
    .OP_W         (OP_W),
    .HAS_FP_ADDER (HAS_FP_ADDER)  // keep 0 unless you add the FP adder source
  ) u_dp (
    .clk        (clk),
    .rst        (rst),
    .start      (dp_start),
    .operand0   (dp_operand0),
    .operand1   (dp_operand1),
    .opcode     (dp_opcode),
    .result_out (dp_result),
    .op_valid   (dp_op_valid)
  );

endmodule

`default_nettype wire
