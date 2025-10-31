`timescale 1ns/1ps
`default_nettype none

module vpu_dpath #(
    parameter int DATA_W = 16,
    parameter int B = 8,        // rows (batch elements) per column/neuron
    parameter int D_OUT = 4     // output neurons
)(
    input logic clk,
    input logic rst,

    input logic [3:0] vpu_data_pathway,

    // Inputs from systolic array
    input logic signed [DATA_W-1:0] vpu_data_in_1,
    input logic signed [DATA_W-1:0] vpu_data_in_2,
    input logic signed [DATA_W-1:0] vpu_data_in_3,
    input logic signed [DATA_W-1:0] vpu_data_in_4,
    input logic vpu_valid_in_1,
    input logic vpu_valid_in_2,
    input logic vpu_valid_in_3,
    input logic vpu_valid_in_4,

    // Inputs from UB
    input logic signed [DATA_W-1:0] bias_scalar_in_1,
    input logic signed [DATA_W-1:0] bias_scalar_in_2,
    input logic signed [DATA_W-1:0] bias_scalar_in_3,
    input logic signed [DATA_W-1:0] bias_scalar_in_4,
    input logic signed [DATA_W-1:0] lr_leak_factor_in,

    // Outputs to UB
    output logic signed [DATA_W-1:0] vpu_data_out_1,
    output logic signed [DATA_W-1:0] vpu_data_out_2,
    output logic signed [DATA_W-1:0] vpu_data_out_3,
    output logic signed [DATA_W-1:0] vpu_data_out_4,
    output logic vpu_valid_out_1,
    output logic vpu_valid_out_2,
    output logic vpu_valid_out_3,
    output logic vpu_valid_out_4
);

  // Internal signals
  logic signed [DATA_W-1:0] bias_data_1_in, bias_data_2_in, bias_data_3_in, bias_data_4_in;
  logic bias_valid_1_in, bias_valid_2_in, bias_valid_3_in, bias_valid_4_in;

  logic signed [DATA_W-1:0] bias_z_data_out_1, bias_z_data_out_2, bias_z_data_out_3, bias_z_data_out_4;
  logic bias_valid_1_out, bias_valid_2_out, bias_valid_3_out, bias_valid_4_out;

  logic signed [DATA_W-1:0] lr_data_1_in, lr_data_2_in, lr_data_3_in, lr_data_4_in;
  logic lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in;

  logic signed [DATA_W-1:0] lr_data_1_out, lr_data_2_out, lr_data_3_out, lr_data_4_out;
  logic lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out;

  // Final outputs
  logic signed [DATA_W-1:0] final_data_out_1, final_data_out_2, final_data_out_3, final_data_out_4;
  logic final_valid_out_1, final_valid_out_2, final_valid_out_3, final_valid_out_4;

  // Simple forward pass addition (Z' + b)
  logic signed [DATA_W-1:0] fwd_data_out_1, fwd_data_out_2, fwd_data_out_3, fwd_data_out_4;
  logic fwd_valid_out_1, fwd_valid_out_2, fwd_valid_out_3, fwd_valid_out_4;

  // Per-lane counters (only used for bias module)
  logic [$clog2(B)-1:0] row_ctr_1, row_ctr_2, row_ctr_3, row_ctr_4;
  logic [$clog2(D_OUT)-1:0] col_ctr_1, col_ctr_2, col_ctr_3, col_ctr_4;
  logic sa_to_bias_valid_1, sa_to_bias_valid_2, sa_to_bias_valid_3, sa_to_bias_valid_4;
  logic column_start_1, column_start_2, column_start_3, column_start_4;
  logic bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4;

  // SIMPLE FORWARD PASS: Direct addition (Z' + b)
  assign fwd_data_out_1 = vpu_data_in_1 + bias_scalar_in_1;
  assign fwd_data_out_2 = vpu_data_in_2 + bias_scalar_in_2;
  assign fwd_data_out_3 = vpu_data_in_3 + bias_scalar_in_3;
  assign fwd_data_out_4 = vpu_data_in_4 + bias_scalar_in_4;
  
  assign fwd_valid_out_1 = vpu_valid_in_1;
  assign fwd_valid_out_2 = vpu_valid_in_2;
  assign fwd_valid_out_3 = vpu_valid_in_3;
  assign fwd_valid_out_4 = vpu_valid_in_4;

  // Counter logic for bias module (only when bias is active)
  assign sa_to_bias_valid_1 = (vpu_data_pathway[3] || vpu_data_pathway[2]) ? vpu_valid_in_1 : 1'b0;
  assign sa_to_bias_valid_2 = (vpu_data_pathway[3] || vpu_data_pathway[2]) ? vpu_valid_in_2 : 1'b0;
  assign sa_to_bias_valid_3 = (vpu_data_pathway[3] || vpu_data_pathway[2]) ? vpu_valid_in_3 : 1'b0;
  assign sa_to_bias_valid_4 = (vpu_data_pathway[3] || vpu_data_pathway[2]) ? vpu_valid_in_4 : 1'b0;

  // Row/column counters
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        row_ctr_1 <= '0; col_ctr_1 <= '0;
        row_ctr_2 <= '0; col_ctr_2 <= '0;
        row_ctr_3 <= '0; col_ctr_3 <= '0;
        row_ctr_4 <= '0; col_ctr_4 <= '0;
    end else begin
        // Lane 1
        if (sa_to_bias_valid_1) begin
            if (row_ctr_1 == B-1) begin
                row_ctr_1 <= '0;
                col_ctr_1 <= (col_ctr_1 == D_OUT-1) ? '0 : col_ctr_1 + 1'b1;
            end else begin
                row_ctr_1 <= row_ctr_1 + 1'b1;
            end
        end

        // Lane 2
        if (sa_to_bias_valid_2) begin
            if (row_ctr_2 == B-1) begin
                row_ctr_2 <= '0;
                col_ctr_2 <= (col_ctr_2 == D_OUT-1) ? '0 : col_ctr_2 + 1'b1;
            end else begin
                row_ctr_2 <= row_ctr_2 + 1'b1;
            end
        end
        
        // Lane 3
        if (sa_to_bias_valid_3) begin
            if (row_ctr_3 == B-1) begin
                row_ctr_3 <= '0;
                col_ctr_3 <= (col_ctr_3 == D_OUT-1) ? '0 : col_ctr_3 + 1'b1;
            end else begin
                row_ctr_3 <= row_ctr_3 + 1'b1;
            end
        end

        // Lane 4
        if (sa_to_bias_valid_4) begin
            if (row_ctr_4 == B-1) begin
                row_ctr_4 <= '0;
                col_ctr_4 <= (col_ctr_4 == D_OUT-1) ? '0 : col_ctr_4 + 1'b1;
            end else begin
                row_ctr_4 <= row_ctr_4 + 1'b1;
            end
        end
    end
  end

  assign column_start_1 = sa_to_bias_valid_1 && (row_ctr_1 == '0);
  assign column_start_2 = sa_to_bias_valid_2 && (row_ctr_2 == '0);
  assign column_start_3 = sa_to_bias_valid_3 && (row_ctr_3 == '0);
  assign column_start_4 = sa_to_bias_valid_4 && (row_ctr_4 == '0);

  assign bias_load_en_1 = column_start_1;
  assign bias_load_en_2 = column_start_2;
  assign bias_load_en_3 = column_start_3;
  assign bias_load_en_4 = column_start_4;

  // Instantiate bias parent
  bias_parent bias_parent_inst (  
      .clk               (clk),
      .rst               (rst),
      .bias_sys_data_in_1(bias_data_1_in),
      .bias_sys_data_in_2(bias_data_2_in),
      .bias_sys_data_in_3(bias_data_3_in),
      .bias_sys_data_in_4(bias_data_4_in),
      .bias_sys_valid_in_1(bias_valid_1_in),
      .bias_sys_valid_in_2(bias_valid_2_in),
      .bias_sys_valid_in_3(bias_valid_3_in),
      .bias_sys_valid_in_4(bias_valid_4_in),
      .bias_scalar_ub_in_1(bias_scalar_in_1),
      .bias_scalar_ub_in_2(bias_scalar_in_2),
      .bias_scalar_ub_in_3(bias_scalar_in_3),
      .bias_scalar_ub_in_4(bias_scalar_in_4),
      .bias_load_en_1(bias_load_en_1),
      .bias_load_en_2(bias_load_en_2),
      .bias_load_en_3(bias_load_en_3),
      .bias_load_en_4(bias_load_en_4),
      .bias_Z_valid_out_1(bias_valid_1_out),
      .bias_Z_valid_out_2(bias_valid_2_out),
      .bias_Z_valid_out_3(bias_valid_3_out),
      .bias_Z_valid_out_4(bias_valid_4_out),
      .bias_z_data_out_1(bias_z_data_out_1),
      .bias_z_data_out_2(bias_z_data_out_2),
      .bias_z_data_out_3(bias_z_data_out_3),
      .bias_z_data_out_4(bias_z_data_out_4)
  );

  // Instantiate leaky ReLU parent
  leaky_relu_parent leaky_relu_parent_inst (
      .clk(clk),
      .rst(rst),
      .lr_leak_factor_in(lr_leak_factor_in),
      .lr_valid_1_in(lr_valid_1_in),
      .lr_valid_2_in(lr_valid_2_in),
      .lr_valid_3_in(lr_valid_3_in),
      .lr_valid_4_in(lr_valid_4_in),
      .lr_data_1_in(lr_data_1_in),
      .lr_data_2_in(lr_data_2_in),
      .lr_data_3_in(lr_data_3_in),
      .lr_data_4_in(lr_data_4_in),
      .lr_data_1_out(lr_data_1_out),
      .lr_data_2_out(lr_data_2_out),
      .lr_data_3_out(lr_data_3_out),
      .lr_data_4_out(lr_data_4_out),
      .lr_valid_1_out(lr_valid_1_out),
      .lr_valid_2_out(lr_valid_2_out),
      .lr_valid_3_out(lr_valid_3_out),
      .lr_valid_4_out(lr_valid_4_out)
  );

  // Input routing to modules
  always_comb begin
    // Default assignments
    bias_data_1_in = '0; bias_data_2_in = '0; bias_data_3_in = '0; bias_data_4_in = '0;
    bias_valid_1_in = 1'b0; bias_valid_2_in = 1'b0; bias_valid_3_in = 1'b0; bias_valid_4_in = 1'b0;
    lr_data_1_in = '0; lr_data_2_in = '0; lr_data_3_in = '0; lr_data_4_in = '0;
    lr_valid_1_in = 1'b0; lr_valid_2_in = 1'b0; lr_valid_3_in = 1'b0; lr_valid_4_in = 1'b0;

    case (vpu_data_pathway)
      4'b1100: begin // Bias + Leaky ReLU
        bias_data_1_in = vpu_data_in_1; bias_data_2_in = vpu_data_in_2;
        bias_data_3_in = vpu_data_in_3; bias_data_4_in = vpu_data_in_4;
        bias_valid_1_in = vpu_valid_in_1; bias_valid_2_in = vpu_valid_in_2;
        bias_valid_3_in = vpu_valid_in_3; bias_valid_4_in = vpu_valid_in_4;
        
        lr_data_1_in = bias_z_data_out_1; lr_data_2_in = bias_z_data_out_2;
        lr_data_3_in = bias_z_data_out_3; lr_data_4_in = bias_z_data_out_4;
        lr_valid_1_in = bias_valid_1_out; lr_valid_2_in = bias_valid_2_out;
        lr_valid_3_in = bias_valid_3_out; lr_valid_4_in = bias_valid_4_out;
      end
      
      4'b1000: begin // Bias only
        bias_data_1_in = vpu_data_in_1; bias_data_2_in = vpu_data_in_2;
        bias_data_3_in = vpu_data_in_3; bias_data_4_in = vpu_data_in_4;
        bias_valid_1_in = vpu_valid_in_1; bias_valid_2_in = vpu_valid_in_2;
        bias_valid_3_in = vpu_valid_in_3; bias_valid_4_in = vpu_valid_in_4;
      end
      
      4'b0100: begin // Leaky ReLU only
        lr_data_1_in = vpu_data_in_1; lr_data_2_in = vpu_data_in_2;
        lr_data_3_in = vpu_data_in_3; lr_data_4_in = vpu_data_in_4;
        lr_valid_1_in = vpu_valid_in_1; lr_valid_2_in = vpu_valid_in_2;
        lr_valid_3_in = vpu_valid_in_3; lr_valid_4_in = vpu_valid_in_4;
      end
      
      default: begin
        // Other pathways handled by output selection
      end
    endcase
  end

  // Output selection - ADDED FORWARD PASS MODE
  always_comb begin
    // Default: forward pass (Z' + b)
    final_data_out_1 = fwd_data_out_1;
    final_data_out_2 = fwd_data_out_2;
    final_data_out_3 = fwd_data_out_3;
    final_data_out_4 = fwd_data_out_4;
    final_valid_out_1 = fwd_valid_out_1;
    final_valid_out_2 = fwd_valid_out_2;
    final_valid_out_3 = fwd_valid_out_3;
    final_valid_out_4 = fwd_valid_out_4;

    case (vpu_data_pathway)
      4'b1100: begin // Bias + Leaky ReLU
        final_data_out_1 = lr_data_1_out; final_data_out_2 = lr_data_2_out;
        final_data_out_3 = lr_data_3_out; final_data_out_4 = lr_data_4_out;
        final_valid_out_1 = lr_valid_1_out; final_valid_out_2 = lr_valid_2_out;
        final_valid_out_3 = lr_valid_3_out; final_valid_out_4 = lr_valid_4_out;
      end
      4'b1000: begin // Bias only
        final_data_out_1 = bias_z_data_out_1; final_data_out_2 = bias_z_data_out_2;
        final_data_out_3 = bias_z_data_out_3; final_data_out_4 = bias_z_data_out_4;
        final_valid_out_1 = bias_valid_1_out; final_valid_out_2 = bias_valid_2_out;
        final_valid_out_3 = bias_valid_3_out; final_valid_out_4 = bias_valid_4_out;
      end
      4'b0100: begin // Leaky ReLU only
        final_data_out_1 = lr_data_1_out; final_data_out_2 = lr_data_2_out;
        final_data_out_3 = lr_data_3_out; final_data_out_4 = lr_data_4_out;
        final_valid_out_1 = lr_valid_1_out; final_valid_out_2 = lr_valid_2_out;
        final_valid_out_3 = lr_valid_3_out; final_valid_out_4 = lr_valid_4_out;
      end
      // default: forward pass (already set above)
    endcase
  end

  // Output registers
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        vpu_data_out_1 <= '0; vpu_data_out_2 <= '0; vpu_data_out_3 <= '0; vpu_data_out_4 <= '0;
        vpu_valid_out_1 <= 1'b0; vpu_valid_out_2 <= 1'b0; vpu_valid_out_3 <= 1'b0; vpu_valid_out_4 <= 1'b0;
    end else begin
        vpu_data_out_1 <= final_data_out_1; vpu_data_out_2 <= final_data_out_2;
        vpu_data_out_3 <= final_data_out_3; vpu_data_out_4 <= final_data_out_4;
        vpu_valid_out_1 <= final_valid_out_1; vpu_valid_out_2 <= final_valid_out_2;
        vpu_valid_out_3 <= final_valid_out_3; vpu_valid_out_4 <= final_valid_out_4;
    end
  end

endmodule