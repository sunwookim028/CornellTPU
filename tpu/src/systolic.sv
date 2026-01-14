`timescale 1ns/1ps

// 4x4 systolic array
module systolic #(
    parameter int SYSTOLIC_ARRAY_WIDTH = 4
)(
    input logic clk,
    input logic rst_n,

    // input signals from left side of systolic array
    input logic [31:0] sys_data_in_11,
    input logic [31:0] sys_data_in_21,
    input logic [31:0] sys_data_in_31,
    input logic [31:0] sys_data_in_41,

    input logic sys_start_1,    // start signal for row 1
    input logic sys_start_2,    // start signal for row 2
    input logic sys_start_3,    // start signal for row 3
    input logic sys_start_4,    // start signal for row 4

    // output signals from bottom of systolic array 
    output logic [31:0] sys_data_out_41,
    output logic [31:0] sys_data_out_42,
    output logic [31:0] sys_data_out_43,
    output logic [31:0] sys_data_out_44,
    output wire sys_valid_out_41, 
    output wire sys_valid_out_42,
    output wire sys_valid_out_43, 
    output wire sys_valid_out_44,

    // input signals from top of systolic array
    input logic [31:0] sys_weight_in_11, 
    input logic [31:0] sys_weight_in_12,
    input logic [31:0] sys_weight_in_13, 
    input logic [31:0] sys_weight_in_14,
    input logic sys_accept_w_1,             // accept weight signal propagates only from top to bottom in column 1
    input logic sys_accept_w_2,             // accept weight signal propagates only from top to bottom in column 2
    input logic sys_accept_w_3,             // accept weight signal propagates only from top to bottom in column 3
    input logic sys_accept_w_4,             // accept weight signal propagates only from top to bottom in column 4

    input logic sys_switch_in,               // switch signal copies weight from shadow buffer to active buffer. propagates from top left to bottom right

    input logic [31:0] ub_rd_col_size_in,
    input logic ub_rd_col_size_valid_in
);

    // input_out for each PE (left to right)
    logic [31:0] pe_input_out_11;
    logic [31:0] pe_input_out_21;
    logic [31:0] pe_input_out_31;
    logic [31:0] pe_input_out_41;

    logic [31:0] pe_input_out_12;
    logic [31:0] pe_input_out_22;
    logic [31:0] pe_input_out_32;
    logic [31:0] pe_input_out_42;
    
    logic [31:0] pe_input_out_13;
    logic [31:0] pe_input_out_23;
    logic [31:0] pe_input_out_33;
    logic [31:0] pe_input_out_43;


    // psum_out for each PE (top to bottom)
    logic [31:0] pe_psum_out_11;
    logic [31:0] pe_psum_out_12;
    logic [31:0] pe_psum_out_13;
    logic [31:0] pe_psum_out_14;

    logic [31:0] pe_psum_out_21;
    logic [31:0] pe_psum_out_22;
    logic [31:0] pe_psum_out_23;
    logic [31:0] pe_psum_out_24;

    logic [31:0] pe_psum_out_31;
    logic [31:0] pe_psum_out_32;
    logic [31:0] pe_psum_out_33;
    logic [31:0] pe_psum_out_34;

    logic [31:0] pe_psum_out_41;
    logic [31:0] pe_psum_out_42;
    logic [31:0] pe_psum_out_43;
    logic [31:0] pe_psum_out_44;


    // weight_out for each PE (top to bottom)
    logic [31:0] pe_weight_out_11;
    logic [31:0] pe_weight_out_12;
    logic [31:0] pe_weight_out_13;
    logic [31:0] pe_weight_out_14;

    logic [31:0] pe_weight_out_21;
    logic [31:0] pe_weight_out_22;
    logic [31:0] pe_weight_out_23;
    logic [31:0] pe_weight_out_24;

    logic [31:0] pe_weight_out_31;
    logic [31:0] pe_weight_out_32;
    logic [31:0] pe_weight_out_33;
    logic [31:0] pe_weight_out_34;

    // switch_out for each PE
    logic pe_switch_out_11;
    logic pe_switch_out_12;
    logic pe_switch_out_13;
    logic pe_switch_out_14;

    logic pe_switch_out_21;
    logic pe_switch_out_22;
    logic pe_switch_out_23;
    logic pe_switch_out_24;

    logic pe_switch_out_31;
    logic pe_switch_out_32;
    logic pe_switch_out_33;
    logic pe_switch_out_34;

    logic pe_switch_out_41;
    logic pe_switch_out_42;
    logic pe_switch_out_43;
    logic pe_switch_out_44;
    
    
    // valid_out for each PE (top to bottom)
    wire pe_valid_out_11;   // this wire will connect the valid signal from pe11 to pe12
    wire pe_valid_out_12;   // this wire will connect the valid signal from pe21 to pe22
    wire pe_valid_out_13;
    wire pe_valid_out_14;

    wire pe_valid_out_21;
    wire pe_valid_out_22;
    wire pe_valid_out_23;
    wire pe_valid_out_24;

    wire pe_valid_out_31;
    wire pe_valid_out_32;
    wire pe_valid_out_33;
    wire pe_valid_out_34;

    wire pe_valid_out_41;
    wire pe_valid_out_42;
    wire pe_valid_out_43;
    wire pe_valid_out_44;

    // PE columns to enable
    logic [3:0] pe_enabled; // This should be 4'b1111 for now! But will have to change when we parametrize
    assign pe_enabled = 4'b1111;

    pe pe11 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[0]),

        .pe_valid_in(sys_start_1),
        .pe_valid_out(pe_valid_out_11),

        .pe_accept_w_in(sys_accept_w_1),
        .pe_switch_in(sys_switch_in),
        .pe_switch_out(pe_switch_out_11),

        .pe_input_in(sys_data_in_11),
        .pe_psum_in(32'b0),
        .pe_weight_in(sys_weight_in_11),

        .pe_input_out(pe_input_out_11),
        .pe_psum_out(pe_psum_out_11),
        .pe_weight_out(pe_weight_out_11)
    );

    pe pe12 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[1]),

        .pe_valid_in(pe_valid_out_11),
        .pe_valid_out(pe_valid_out_12),

        .pe_accept_w_in(sys_accept_w_2),
        .pe_switch_in(pe_switch_out_11),
        .pe_switch_out(pe_switch_out_12),

        .pe_input_in(pe_input_out_11),
        .pe_psum_in(32'b0),
        .pe_weight_in(sys_weight_in_12),

        .pe_input_out(pe_input_out_12),
        .pe_psum_out(pe_psum_out_12),
        .pe_weight_out(pe_weight_out_12)
    );

    pe pe13 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[2]),

        .pe_valid_in(pe_valid_out_12),
        .pe_valid_out(pe_valid_out_13),

        .pe_accept_w_in(sys_accept_w_3),
        .pe_switch_in(pe_switch_out_12),
        .pe_switch_out(pe_switch_out_13),

        .pe_input_in(pe_input_out_12),
        .pe_psum_in(32'b0),
        .pe_weight_in(sys_weight_in_13),

        .pe_input_out(pe_input_out_13),
        .pe_psum_out(pe_psum_out_13),
        .pe_weight_out(pe_weight_out_13)
    );

    pe pe14 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[3]),

        .pe_valid_in(pe_valid_out_13),
        .pe_valid_out(pe_valid_out_14),

        .pe_accept_w_in(sys_accept_w_4),
        .pe_switch_in(pe_switch_out_13),
        .pe_switch_out(pe_switch_out_14),

        .pe_input_in(pe_input_out_13),
        .pe_psum_in(32'b0),
        .pe_weight_in(sys_weight_in_14),

        .pe_input_out(/* right edge unused */),
        .pe_psum_out(pe_psum_out_14),
        .pe_weight_out(pe_weight_out_14)
    );

    // ===================== PE row 2 =====================

    pe pe21 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[0]),

        .pe_valid_in(sys_start_2),
        .pe_valid_out(pe_valid_out_21),

        .pe_accept_w_in(sys_accept_w_1),
        .pe_switch_in(pe_switch_out_11),
        .pe_switch_out(pe_switch_out_21),

        .pe_input_in(sys_data_in_21),
        .pe_psum_in(pe_psum_out_11),
        .pe_weight_in(pe_weight_out_11),

        .pe_input_out(pe_input_out_21),
        .pe_psum_out(pe_psum_out_21),
        .pe_weight_out(pe_weight_out_21)
    );

    pe pe22 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[1]),

        .pe_valid_in(pe_valid_out_21),
        .pe_valid_out(pe_valid_out_22),

        .pe_accept_w_in(sys_accept_w_2),
        .pe_switch_in(pe_switch_out_12),
        .pe_switch_out(pe_switch_out_22),

        .pe_input_in(pe_input_out_21),
        .pe_psum_in(pe_psum_out_12),
        .pe_weight_in(pe_weight_out_12),

        .pe_input_out(pe_input_out_22),
        .pe_psum_out(pe_psum_out_22),
        .pe_weight_out(pe_weight_out_22)
    );

    pe pe23 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[2]),

        .pe_valid_in(pe_valid_out_22),
        .pe_valid_out(pe_valid_out_23),

        .pe_accept_w_in(sys_accept_w_3),
        .pe_switch_in(pe_switch_out_13),
        .pe_switch_out(pe_switch_out_23),

        .pe_input_in(pe_input_out_22),
        .pe_psum_in(pe_psum_out_13),
        .pe_weight_in(pe_weight_out_13),

        .pe_input_out(pe_input_out_23),
        .pe_psum_out(pe_psum_out_23),
        .pe_weight_out(pe_weight_out_23)
    );

    pe pe24 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[3]),

        .pe_valid_in(pe_valid_out_23),
        .pe_valid_out(pe_valid_out_24),

        .pe_accept_w_in(sys_accept_w_4),
        .pe_switch_in(pe_switch_out_14),
        .pe_switch_out(pe_switch_out_24),

        .pe_input_in(pe_input_out_23),
        .pe_psum_in(pe_psum_out_14),
        .pe_weight_in(pe_weight_out_14),

        .pe_input_out(/* right edge unused */),
        .pe_psum_out(pe_psum_out_24),
        .pe_weight_out(pe_weight_out_24)
    );

    // ===================== PE row 3 =====================

    pe pe31 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[0]),

        .pe_valid_in(sys_start_3),
        .pe_valid_out(pe_valid_out_31),

        .pe_accept_w_in(sys_accept_w_1),
        .pe_switch_in(pe_switch_out_21),
        .pe_switch_out(pe_switch_out_31),

        .pe_input_in(sys_data_in_31),
        .pe_psum_in(pe_psum_out_21),
        .pe_weight_in(pe_weight_out_21),

        .pe_input_out(pe_input_out_31),
        .pe_psum_out(pe_psum_out_31),
        .pe_weight_out(pe_weight_out_31)
    );

    pe pe32 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[1]),

        .pe_valid_in(pe_valid_out_31),
        .pe_valid_out(pe_valid_out_32),

        .pe_accept_w_in(sys_accept_w_2),
        .pe_switch_in(pe_switch_out_22),
        .pe_switch_out(pe_switch_out_32),

        .pe_input_in(pe_input_out_31),
        .pe_psum_in(pe_psum_out_22),
        .pe_weight_in(pe_weight_out_22),

        .pe_input_out(pe_input_out_32),
        .pe_psum_out(pe_psum_out_32),
        .pe_weight_out(pe_weight_out_32)
    );

    pe pe33 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[2]),

        .pe_valid_in(pe_valid_out_32),
        .pe_valid_out(pe_valid_out_33),

        .pe_accept_w_in(sys_accept_w_3),
        .pe_switch_in(pe_switch_out_23),
        .pe_switch_out(pe_switch_out_33),

        .pe_input_in(pe_input_out_32),
        .pe_psum_in(pe_psum_out_23),
        .pe_weight_in(pe_weight_out_23),

        .pe_input_out(pe_input_out_33),
        .pe_psum_out(pe_psum_out_33),
        .pe_weight_out(pe_weight_out_33)
    );

    pe pe34 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[3]),

        .pe_valid_in(pe_valid_out_33),
        .pe_valid_out(pe_valid_out_34),

        .pe_accept_w_in(sys_accept_w_4),
        .pe_switch_in(pe_switch_out_24),
        .pe_switch_out(pe_switch_out_34),

        .pe_input_in(pe_input_out_33),
        .pe_psum_in(pe_psum_out_24),
        .pe_weight_in(pe_weight_out_24),

        .pe_input_out(/* right edge unused */),
        .pe_psum_out(pe_psum_out_34),
        .pe_weight_out(pe_weight_out_34)
    );

    // ===================== PE row 4 =====================

    pe pe41 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[0]),

        .pe_valid_in(sys_start_4),
        .pe_valid_out(pe_valid_out_41),

        .pe_accept_w_in(sys_accept_w_1),
        .pe_switch_in(pe_switch_out_31),
        .pe_switch_out(pe_switch_out_41),

        .pe_input_in(sys_data_in_41),
        .pe_psum_in(pe_psum_out_31),
        .pe_weight_in(pe_weight_out_31),

        .pe_input_out(pe_input_out_41),
        .pe_psum_out(pe_psum_out_41),
        .pe_weight_out(/* bottom-most; not used further */)
    );

    pe pe42 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[1]),

        .pe_valid_in(pe_valid_out_41),
        .pe_valid_out(pe_valid_out_42),

        .pe_accept_w_in(sys_accept_w_2),
        .pe_switch_in(pe_switch_out_32),
        .pe_switch_out(pe_switch_out_42),

        .pe_input_in(pe_input_out_41),
        .pe_psum_in(pe_psum_out_32),
        .pe_weight_in(pe_weight_out_32),

        .pe_input_out(pe_input_out_42),
        .pe_psum_out(pe_psum_out_42),
        .pe_weight_out(/* bottom-most; not used further */)
    );

    pe pe43 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[2]),

        .pe_valid_in(pe_valid_out_42),
        .pe_valid_out(pe_valid_out_43),

        .pe_accept_w_in(sys_accept_w_3),
        .pe_switch_in(pe_switch_out_33),
        .pe_switch_out(pe_switch_out_43),

        .pe_input_in(pe_input_out_42),
        .pe_psum_in(pe_psum_out_33),
        .pe_weight_in(pe_weight_out_33),

        .pe_input_out(pe_input_out_43),
        .pe_psum_out(pe_psum_out_43),
        .pe_weight_out(/* bottom-most; not used further */)
    );

    pe pe44 (
        .clk(clk),
        .rst_n(rst_n),
        .pe_enabled(pe_enabled[3]),

        .pe_valid_in(pe_valid_out_43),
        .pe_valid_out(pe_valid_out_44),

        .pe_accept_w_in(sys_accept_w_4),
        .pe_switch_in(pe_switch_out_34),
        .pe_switch_out(pe_switch_out_44),

        .pe_input_in(pe_input_out_43),
        .pe_psum_in(pe_psum_out_34),
        .pe_weight_in(pe_weight_out_34),

        .pe_input_out(/* right edge unused */),
        .pe_psum_out(pe_psum_out_44),
        .pe_weight_out(/* bottom-most; not used further */)
    );

    // Connect bottom row of PEs to systolic output wires
    assign sys_data_out_41 = pe_psum_out_41;
    assign sys_data_out_42 = pe_psum_out_42;
    assign sys_data_out_43 = pe_psum_out_43;
    assign sys_data_out_44 = pe_psum_out_44;

    assign sys_valid_out_41 = pe_valid_out_41;
    assign sys_valid_out_42 = pe_valid_out_42;
    assign sys_valid_out_43 = pe_valid_out_43;
    assign sys_valid_out_44 = pe_valid_out_44;


endmodule