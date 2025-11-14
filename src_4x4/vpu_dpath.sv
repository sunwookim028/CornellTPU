`timescale 1ns/1ps
`default_nettype none

module vpu_dpath #(
    parameter int DATA_W = 16,
    parameter int SIZE   = 8,  // number of lanes / outputs
    parameter int DBITS  = 8   // frac bits for fixed-point (Qm.DBITS)
)(
    input  logic clk,
    input  logic rst,

    input  logic [3:0] vpu_data_pathway,

    // Inputs from systolic array (controller fanout) — SIZE lanes
    input  logic signed [DATA_W-1:0] vpu_data_in  [SIZE],
    input  logic                     vpu_valid_in [SIZE],

    // Bias + leaky params
    input  logic signed [DATA_W-1:0] bias_scalar_in [SIZE],
    input  logic signed [DATA_W-1:0] lr_leak_factor_in, // shared

    // Outputs to UB
    output logic signed [DATA_W-1:0] vpu_data_out  [SIZE],
    output logic                     vpu_valid_out [SIZE]
);

  // Inline per-lane bias add and optional leaky-ReLU
  // Pathways:
  // 1100: bias then leaky
  // 1000: bias only
  // 0100: leaky only
  // default: forward pass (bias only, matches your previous default)
  genvar i;
  generate
    for (i = 0; i < SIZE; i++) begin : g_lane
      logic signed [DATA_W-1:0] x_in, b_in;
      logic signed [DATA_W  :0] bias_sum_wide;      // +1 bit for add
      logic signed [DATA_W-1:0] bias_sum_narrow;

      logic signed [2*DATA_W-1:0] mult_full;       // for leaky
      logic signed [DATA_W-1:0]    lrelu_val;

      assign x_in = vpu_data_in[i];
      assign b_in = bias_scalar_in[i];

      // bias add
      assign bias_sum_wide   = x_in + b_in;
      assign bias_sum_narrow = bias_sum_wide[DATA_W-1:0];

      // leaky relu on some input "t"
      // t >= 0 ? t : (t * alpha) >>> DBITS
      // note: assume lr_leak_factor_in is Q(?, DBITS)
      always_comb begin
        logic signed [DATA_W-1:0] t;
        // choose t based on mode
        unique case (vpu_data_pathway)
          4'b0100: t = x_in;               // leaky only
          4'b1100: t = bias_sum_narrow;    // bias then leaky
          default: t = bias_sum_narrow;    // bias only/forward
        endcase

        if (t >= 0) begin
          lrelu_val = t;
        end else begin
          mult_full = t * lr_leak_factor_in;           // Q(DATA_W) * Q(DBITS)
          lrelu_val = mult_full[DBITS +: DATA_W];       // arithmetic shift by DBITS
        end
      end

      // final select
      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          vpu_data_out[i]  <= '0;
          vpu_valid_out[i] <= 1'b0;
        end else begin
          unique case (vpu_data_pathway)
            4'b1100: begin // bias + leaky
              vpu_data_out[i]  <= lrelu_val;
              vpu_valid_out[i] <= vpu_valid_in[i];
            end
            4'b1000: begin // bias only
              vpu_data_out[i]  <= bias_sum_narrow;
              vpu_valid_out[i] <= vpu_valid_in[i];
            end
            4'b0100: begin // leaky only
              vpu_data_out[i]  <= lrelu_val;
              vpu_valid_out[i] <= vpu_valid_in[i];
            end
            default: begin // forward: treat as bias only
              vpu_data_out[i]  <= bias_sum_narrow;
              vpu_valid_out[i] <= vpu_valid_in[i];
            end
          endcase
        end
      end
    end
  endgenerate

endmodule
