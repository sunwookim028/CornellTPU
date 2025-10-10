`timescale 1ns/1ps
`default_nettype none

// three data pathways:
// (forward pass hidden layer computations) input from sys --> bias --> leaky relu --> output
// (transition) input from sys --> bias --> leaky relu --> loss --> leaky relu derivative --> output
// (backward pass) input from sys --> leaky relu derivative --> output
// during the transition pathway we need to store the H matrices that come out of the leaky relu modules AND pass them to the loss modules

/* 
|bias control bit| |lr control bit| |loss control bit| |lr_d control bit|

0000: activate no modules
1100: forward pass pathway (sys --> bias --> leaky relu --> output)
JUST working on forward pass
*/

module vpu (
    input logic clk,
    input logic rst,

    input logic [3:0] vpu_data_pathway, // 4-bits to signify which modules to route the inputs to (1 bit for each module)

    // Inputs from systolic array
    input logic signed [15:0] vpu_data_in_1,
    input logic signed [15:0] vpu_data_in_2,
    input logic signed [15:0] vpu_data_in_3,
    input logic signed [15:0] vpu_data_in_4,
    input logic vpu_valid_in_1,
    input logic vpu_valid_in_2,
    input logic vpu_valid_in_3,
    input logic vpu_valid_in_4,

    // Inputs from UB
    input logic signed [15:0] bias_scalar_in_1,             // For bias modules
    input logic signed [15:0] bias_scalar_in_2,             // For bias modules
    input logic signed [15:0] bias_scalar_in_3,             // For bias modules
    input logic signed [15:0] bias_scalar_in_4,             // For bias modules
    input logic signed [15:0] lr_leak_factor_in,            // For leaky relu modules

    // Outputs to UB
    output logic signed [15:0] vpu_data_out_1,
    output logic signed [15:0] vpu_data_out_2,
    output logic signed [15:0] vpu_data_out_3,
    output logic signed [15:0] vpu_data_out_4,
    output logic vpu_valid_out_1,
    output logic vpu_valid_out_2,
    output logic vpu_valid_out_3,
    output logic vpu_valid_out_4
);
  // bias
  logic [15:0] bias_data_1_in; 
  logic bias_valid_1_in;
  logic [15:0] bias_data_2_in;
  logic bias_valid_2_in;
  logic [15:0] bias_data_3_in; 
  logic bias_valid_3_in;
  logic [15:0] bias_data_4_in;
  logic bias_valid_4_in;

  logic [15:0] bias_z_data_out_1;
  logic bias_valid_1_out;
  logic [15:0] bias_z_data_out_2;
  logic bias_valid_2_out;
  logic [15:0] bias_z_data_out_3;
  logic bias_valid_3_out;
  logic [15:0] bias_z_data_out_4;
  logic bias_valid_4_out;

  // bias to lr intermediate values
  logic [15:0] b_to_lr_data_in_1;
  logic b_to_lr_valid_in_1;
  logic [15:0] b_to_lr_data_in_2;
  logic b_to_lr_valid_in_2;
  logic [15:0] b_to_lr_data_in_3;
  logic b_to_lr_valid_in_3;
  logic [15:0] b_to_lr_data_in_4;
  logic b_to_lr_valid_in_4;

  // lr
  logic [15:0] lr_data_1_in; 
  logic lr_valid_1_in;
  logic [15:0] lr_data_2_in;
  logic lr_valid_2_in;
  logic [15:0] lr_data_3_in; 
  logic lr_valid_3_in;
  logic [15:0] lr_data_4_in;
  logic lr_valid_4_in;

  logic [15:0] lr_data_1_out;
  logic lr_valid_1_out;
  logic [15:0] lr_data_2_out;
  logic lr_valid_2_out;
  logic [15:0] lr_data_3_out;
  logic lr_valid_3_out;
  logic [15:0] lr_data_4_out;
  logic lr_valid_4_out;

  // rows (batch elements) per column/neuron, output neurons
  parameter int B      = 8; 
  parameter int D_OUT  = 4;

  // per-lane counters (you have two lanes: *_1 and *_2)
  logic [$clog2(B    )-1:0] row_ctr_1, row_ctr_2, row_ctr_3, row_ctr_4;
  logic [$clog2(D_OUT)-1:0] col_ctr_1, col_ctr_2, col_ctr_3, col_ctr_4;

  // valid that represents entering the bias stage from sys array
  logic sa_to_bias_valid_1, sa_to_bias_valid_2, sa_to_bias_valid_3, sa_to_bias_valid_4;

  // Column (neuron) boundary pulses
  logic column_start_1, column_start_2, column_start_3, column_start_4;

  // Bias load enables (one-cycle pulses)
  logic bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4; // two bias child instances

  assign sa_to_bias_valid_1 = vpu_data_pathway[3] ? vpu_valid_in_1 : 1'b0;
  assign sa_to_bias_valid_2 = vpu_data_pathway[3] ? vpu_valid_in_2 : 1'b0;
  assign sa_to_bias_valid_3 = vpu_data_pathway[3] ? vpu_valid_in_3 : 1'b0;
  assign sa_to_bias_valid_4 = vpu_data_pathway[3] ? vpu_valid_in_4 : 1'b0;

    // dummy signals for forward-pass only build
  logic [15:0] lr_to_loss_data_in_1, lr_to_loss_data_in_2, lr_to_loss_data_in_3, lr_to_loss_data_in_4;
  logic        lr_to_loss_valid_in_1, lr_to_loss_valid_in_2, lr_to_loss_valid_in_3, lr_to_loss_valid_in_4;
  logic [15:0] last_H_data_1_in, last_H_data_2_in, last_H_data_3_in, last_H_data_4_in;
  logic [15:0] last_H_data_1_out, last_H_data_2_out, last_H_data_3_out, last_H_data_4_out;

  // row/column counters to detect the start of each neuron column
  always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
      row_ctr_1 <= '0;  col_ctr_1 <= '0;
      row_ctr_2 <= '0;  col_ctr_2 <= '0;
      row_ctr_3 <= '0;  col_ctr_3 <= '0;
      row_ctr_4 <= '0;  col_ctr_4 <= '0;
  end else begin
      // lane 1
      if (sa_to_bias_valid_1) begin
      if (row_ctr_1 == B-1) begin
          row_ctr_1 <= '0;
          col_ctr_1 <= (col_ctr_1 == D_OUT-1) ? '0 : col_ctr_1 + 1'b1;
      end else begin
          row_ctr_1 <= row_ctr_1 + 1'b1;
      end
      end

      // lane 2
      if (sa_to_bias_valid_2) begin
      if (row_ctr_2 == B-1) begin
          row_ctr_2 <= '0;
          col_ctr_2 <= (col_ctr_2 == D_OUT-1) ? '0 : col_ctr_2 + 1'b1;
      end else begin
          row_ctr_2 <= row_ctr_2 + 1'b1;
      end
      end
      
      // lane 3
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


  bias_parent bias_parent_inst (  
      .clk               ( clk ),
      .rst               ( rst ),

      // stream from SA
      .bias_sys_data_in_1( bias_data_1_in ),
      .bias_sys_data_in_2( bias_data_2_in ),
      .bias_sys_data_in_3( bias_data_3_in ),
      .bias_sys_data_in_4( bias_data_4_in ),

      .bias_sys_valid_in_1( bias_valid_1_in ),
      .bias_sys_valid_in_2( bias_valid_2_in ),
      .bias_sys_valid_in_3( bias_valid_3_in ),
      .bias_sys_valid_in_4( bias_valid_4_in ),

      // UB bias + load enables (NEW/renamed)
      .bias_scalar_ub_in_1( bias_scalar_in_1 ),
      .bias_scalar_ub_in_2( bias_scalar_in_2 ),
      .bias_scalar_ub_in_3( bias_scalar_in_3 ),
      .bias_scalar_ub_in_4( bias_scalar_in_4 ),

      .bias_load_en_1     ( bias_load_en_1 ),
      .bias_load_en_2     ( bias_load_en_2 ),
      .bias_load_en_3     ( bias_load_en_3 ),
      .bias_load_en_4     ( bias_load_en_4 ),

      // outputs
      .bias_Z_valid_out_1 ( bias_valid_1_out ),
      .bias_Z_valid_out_2 ( bias_valid_2_out ),
      .bias_Z_valid_out_3 ( bias_valid_3_out ),
      .bias_Z_valid_out_4 ( bias_valid_4_out ),

      .bias_z_data_out_1  ( bias_z_data_out_1 ),
      .bias_z_data_out_2  ( bias_z_data_out_2 ),
      .bias_z_data_out_3  ( bias_z_data_out_3 ),
      .bias_z_data_out_4  ( bias_z_data_out_4 )
  );


  leaky_relu_parent leaky_relu_parent_inst (
      .clk(clk),
      .rst(rst),

      .lr_leak_factor_in(lr_leak_factor_in),      // input from UB

      .lr_valid_1_in(lr_valid_1_in),              // input
      .lr_valid_2_in(lr_valid_2_in),              // input
      .lr_valid_3_in(lr_valid_3_in),              // input
      .lr_valid_4_in(lr_valid_4_in),              // input

      .lr_data_1_in(lr_data_1_in),                // input
      .lr_data_2_in(lr_data_2_in),                // input
      .lr_data_3_in(lr_data_3_in),                // input
      .lr_data_4_in(lr_data_4_in),                // input
      
      .lr_data_1_out(lr_data_1_out),              // output 
      .lr_data_2_out(lr_data_2_out),              // output
      .lr_data_3_out(lr_data_3_out),              // output 
      .lr_data_4_out(lr_data_4_out),              // output

      .lr_valid_1_out(lr_valid_1_out),            // output
      .lr_valid_2_out(lr_valid_2_out),             // output
      .lr_valid_3_out(lr_valid_3_out),            // output
      .lr_valid_4_out(lr_valid_4_out)             // output
  );

  always @(*) begin
        if (rst) begin
            vpu_data_out_1 = 16'b0;
            vpu_data_out_2 = 16'b0;
            vpu_data_out_3 = 16'b0;
            vpu_data_out_4 = 16'b0;
            
            vpu_valid_out_1 = 1'b0;
            vpu_valid_out_2 = 1'b0;
            vpu_valid_out_3 = 1'b0;
            vpu_valid_out_4 = 1'b0;
            
            // default internal wire assignments during reset
            bias_data_1_in = 16'b0;
            bias_data_2_in = 16'b0;
            bias_data_3_in = 16'b0;
            bias_data_4_in = 16'b0;

            bias_valid_1_in = 1'b0;
            bias_valid_2_in = 1'b0;
            bias_valid_3_in = 1'b0;
            bias_valid_4_in = 1'b0;

            lr_data_1_in = 16'b0;
            lr_data_2_in = 16'b0;
            lr_data_3_in = 16'b0;
            lr_data_4_in = 16'b0;

            lr_valid_1_in = 1'b0;
            lr_valid_2_in = 1'b0;
            lr_valid_3_in = 1'b0;
            lr_valid_4_in = 1'b0;
        end else begin
            // bias module
            if(vpu_data_pathway[3]) begin
                // connect vpu inputs to bias module
                bias_data_1_in = vpu_data_in_1;
                bias_data_2_in = vpu_data_in_2;
                bias_data_3_in = vpu_data_in_3;
                bias_data_4_in = vpu_data_in_4;
                
                bias_valid_1_in = vpu_valid_in_1;
                bias_valid_2_in = vpu_valid_in_2;
                bias_valid_1_in = vpu_valid_in_1;
                bias_valid_2_in = vpu_valid_in_2;

                // connect bias output to intermediate values
                b_to_lr_data_in_1 = bias_z_data_out_1;
                b_to_lr_data_in_2 = bias_z_data_out_2;
                b_to_lr_valid_in_1 = bias_valid_1_out;
                b_to_lr_valid_in_2 = bias_valid_2_out;
            end else begin
                // disable inputs
                bias_data_1_in = 16'b0;
                bias_data_2_in = 16'b0;
                bias_data_3_in = 16'b0;
                bias_data_4_in = 16'b0;

                bias_valid_1_in = 1'b0;
                bias_valid_2_in = 1'b0;
                bias_valid_3_in = 1'b0;
                bias_valid_4_in = 1'b0;

                // connect vpu input to intermediate values
                b_to_lr_data_in_1 = vpu_data_in_1;
                b_to_lr_data_in_2 = vpu_data_in_2;
                b_to_lr_data_in_3 = vpu_data_in_3;
                b_to_lr_data_in_4 = vpu_data_in_4;

                b_to_lr_valid_in_1 = vpu_valid_in_1;
                b_to_lr_valid_in_2 = vpu_valid_in_2;
                b_to_lr_valid_in_3 = vpu_valid_in_3;
                b_to_lr_valid_in_4 = vpu_valid_in_4;
            end

            // leaky relu module
            if(vpu_data_pathway[2]) begin
                // connect lr inputs to intermediate values
                lr_data_1_in = b_to_lr_data_in_1;
                lr_data_2_in = b_to_lr_data_in_2;
                lr_data_3_in = b_to_lr_data_in_3;
                lr_data_4_in = b_to_lr_data_in_4;
                
                lr_valid_1_in = b_to_lr_valid_in_1;
                lr_valid_2_in = b_to_lr_valid_in_2;
                lr_valid_3_in = b_to_lr_valid_in_3;
                lr_valid_4_in = b_to_lr_valid_in_4;

                // connect lr outputs to intermediate values
                lr_to_loss_data_in_1 = lr_data_1_out;
                lr_to_loss_data_in_2 = lr_data_2_out;
                lr_to_loss_data_in_3 = lr_data_3_out;
                lr_to_loss_data_in_4 = lr_data_4_out;
                
                lr_to_loss_valid_in_1 = lr_valid_1_out;
                lr_to_loss_valid_in_2 = lr_valid_2_out;
                lr_to_loss_valid_in_3 = lr_valid_3_out;
                lr_to_loss_valid_in_4 = lr_valid_4_out;

            end else begin
                // disable inputs
                lr_data_1_in = 16'b0;
                lr_data_2_in = 16'b0;
                lr_data_3_in = 16'b0;
                lr_data_4_in = 16'b0;

                lr_valid_1_in = 1'b0;
                lr_valid_2_in = 1'b0;
                lr_valid_3_in = 1'b0;
                lr_valid_4_in = 1'b0;

                // connect intermediate values to each other
                lr_to_loss_data_in_1 = b_to_lr_data_in_1;
                lr_to_loss_data_in_2 = b_to_lr_data_in_2;
                lr_to_loss_data_in_3 = b_to_lr_data_in_3;
                lr_to_loss_data_in_4 = b_to_lr_data_in_4;

                lr_to_loss_valid_in_1 = b_to_lr_valid_in_1;
                lr_to_loss_valid_in_2 = b_to_lr_valid_in_2;
                lr_to_loss_valid_in_3 = b_to_lr_valid_in_3;
                lr_to_loss_valid_in_4 = b_to_lr_valid_in_4;
            end
            
            // loss module & leaky relu derivative module omitted; not needed for forward pass
        end
    end

    // sequential logic to cache last H???
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          last_H_data_1_in <= 0;
          last_H_data_2_in <= 0;
          last_H_data_3_in <= 0;
          last_H_data_4_in <= 0;

          last_H_data_1_out <= 0;
          last_H_data_2_out <= 0;
          last_H_data_3_out <= 0;
          last_H_data_4_out <= 0;
      end else begin
          if (vpu_data_pathway[1]) begin
              last_H_data_1_out <= last_H_data_1_in;
              last_H_data_2_out <= last_H_data_2_in;
              last_H_data_3_out <= last_H_data_3_in;
              last_H_data_4_out <= last_H_data_4_in;
          end else begin
              last_H_data_1_out <= 0;
              last_H_data_2_out <= 0;
              last_H_data_3_out <= 0;
              last_H_data_4_out <= 0;
          end 
      end
  end
endmodule
