`timescale 1ns/1ps
`default_nettype none

module systolic #(
    parameter int N           = 4,
    parameter int DATA_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst,

    input  logic [DATA_WIDTH-1:0] sys_data_in   [N],
    input  logic                  sys_start     [N],

    output logic [DATA_WIDTH-1:0] sys_data_out  [N],
    output logic                  sys_valid_out [N],

    input  logic [DATA_WIDTH-1:0] sys_weight_in [N],
    input  logic                  sys_accept_w  [N],

    input  logic                  sys_switch_in,

    input  logic [DATA_WIDTH-1:0] ub_rd_col_size_in,
    input  logic                  ub_rd_col_size_valid_in
);

    // =====================================================================
    // Internal interconnect signals
    // =====================================================================

    // Data flowing to the right
    logic [DATA_WIDTH-1:0] pe_input_out  [N][N];

    // Partial sums flowing downward
    logic [DATA_WIDTH-1:0] pe_psum_out   [N][N];

    // Weights flowing downward
    logic [DATA_WIDTH-1:0] pe_weight_out [N][N];

    // Switch propagation (down-right)
    logic pe_switch_out [N][N];

    // Valid propagation (to the right)
    logic pe_valid_out  [N][N];

    // PE column enables (for now, all enabled)
    logic [N-1:0] pe_enabled;
    assign pe_enabled = '1; // all ones

    // =====================================================================
    // Generate the N x N mesh of PEs
    // =====================================================================

    genvar r, c;
    generate
        for (r = 0; r < N; r++) begin : ROW
            for (c = 0; c < N; c++) begin : COL

                // Local wires for each PE's inputs
                logic [DATA_WIDTH-1:0] pe_input_in;
                logic [DATA_WIDTH-1:0] pe_psum_in;
                logic [DATA_WIDTH-1:0] pe_weight_in;
                logic                  pe_valid_in;
                logic                  pe_accept_w_in;
                logic                  pe_switch_in_local;

                if (r == 0 && c == 0) begin : TOP_LEFT
                    assign pe_valid_in        = sys_start[0];
                    assign pe_input_in        = sys_data_in[0];
                    assign pe_psum_in         = '0;
                    assign pe_weight_in       = sys_weight_in[0];
                    assign pe_accept_w_in     = sys_accept_w[0];
                    assign pe_switch_in_local = sys_switch_in;
                end
                else if (r == 0) begin : TOP_ROW
                    assign pe_valid_in        = pe_valid_out[r][c-1];
                    assign pe_input_in        = pe_input_out[r][c-1];
                    assign pe_psum_in         = '0;
                    assign pe_weight_in       = sys_weight_in[c];
                    assign pe_accept_w_in     = sys_accept_w[c];
                    assign pe_switch_in_local = pe_switch_out[r][c-1];
                end
                else if (c == 0) begin : LEFT_COL
                    assign pe_valid_in        = sys_start[r];
                    assign pe_input_in        = sys_data_in[r];
                    assign pe_psum_in         = pe_psum_out[r-1][c];
                    assign pe_weight_in       = pe_weight_out[r-1][c];
                    assign pe_accept_w_in     = sys_accept_w[0];
                    assign pe_switch_in_local = pe_switch_out[r-1][c];
                end
                else begin : INNER
                    // Inner PEs
                    assign pe_valid_in        = pe_valid_out[r][c-1];
                    assign pe_input_in        = pe_input_out[r][c-1];
                    assign pe_psum_in         = pe_psum_out[r-1][c];
                    assign pe_weight_in       = pe_weight_out[r-1][c];
                    assign pe_accept_w_in     = sys_accept_w[c];
                    assign pe_switch_in_local = pe_switch_out[r-1][c-1];
                end

                pe #(
                    .DATA_WIDTH(DATA_WIDTH)
                ) pe_inst (
                    .clk          (clk),
                    .rst          (rst),
                    .pe_enabled   (pe_enabled[c]),

                    .pe_valid_in   (pe_valid_in),
                    .pe_valid_out  (pe_valid_out[r][c]),

                    .pe_accept_w_in(pe_accept_w_in),
                    .pe_switch_in  (pe_switch_in_local),
                    .pe_switch_out (pe_switch_out[r][c]),

                    .pe_input_in   (pe_input_in),
                    .pe_psum_in    (pe_psum_in),
                    .pe_weight_in  (pe_weight_in),

                    .pe_input_out  (pe_input_out[r][c]),
                    .pe_psum_out   (pe_psum_out[r][c]),
                    .pe_weight_out (pe_weight_out[r][c])
                );

            end
        end
    endgenerate

    generate
        for (c = 0; c < N; c++) begin : BOTTOM_ROW_OUTPUT
            assign sys_data_out[c]  = pe_psum_out[N-1][c];
            assign sys_valid_out[c] = pe_valid_out[N-1][c];
        end
    endgenerate

endmodule
