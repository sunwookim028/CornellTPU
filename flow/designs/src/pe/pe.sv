// Synthesis-friendly PE module with synchronous reset
// Modified from original async reset for Yosys compatibility
`timescale 1ns/1ps

module pe #(
    parameter int DATA_WIDTH = 32
) (
    input  logic clk,
    input  logic rst_n,

    // North wires of PE (partial sum + weight input)
    input  logic [DATA_WIDTH-1:0] pe_psum_in, 
    input  logic [DATA_WIDTH-1:0] pe_weight_in,
    input  logic                  pe_accept_w_in, 
    
    // West wires of PE (activation + control)
    input  logic [DATA_WIDTH-1:0] pe_input_in, 
    input  logic                  pe_valid_in, 
    input  logic                  pe_switch_in, 
    input  logic                  pe_enabled,

    // South wires of the PE (partial sum + weight output)
    output logic [DATA_WIDTH-1:0] pe_psum_out,
    output logic [DATA_WIDTH-1:0] pe_weight_out,

    // East wires of the PE (activation + control out)
    output logic [DATA_WIDTH-1:0] pe_input_out,
    output logic                  pe_valid_out,
    output logic                  pe_switch_out
);

    // Internal data paths (FP32)
    logic [DATA_WIDTH-1:0] mult_out;
    logic [DATA_WIDTH-1:0] mac_out;
    logic [DATA_WIDTH-1:0] weight_reg_active;    // foreground weight register
    logic [DATA_WIDTH-1:0] weight_reg_inactive;  // background weight register

    // ------------------------------------------------------------------------
    // FP32 multiply: mult_out = pe_input_in * weight_reg_active
    // ------------------------------------------------------------------------
    fp32_mul #(
        .FORMAT   ("FP32"),
        .INT_BITS (16),
        .FRAC_BITS(16),
        .WIDTH    (DATA_WIDTH)
    ) mult (
        .a      ( pe_input_in        ),
        .b      ( weight_reg_active  ),
        .result ( mult_out           )
    );

    // ------------------------------------------------------------------------
    // FP32 add: mac_out = mult_out + pe_psum_in
    // ------------------------------------------------------------------------
    fp32_add #(
        .FORMAT   ("FP32"),
        .INT_BITS (16),
        .FRAC_BITS(16),
        .WIDTH    (DATA_WIDTH)
    ) adder (
        .a      ( mult_out     ),
        .b      ( pe_psum_in   ),
        .result ( mac_out      )
    );

    // ------------------------------------------------------------------------
    // Sequential control + register updates (synchronous reset for Yosys)
    // ------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (!rst_n || !pe_enabled) begin
            pe_input_out        <= '0;
            pe_psum_out         <= '0;
            pe_weight_out       <= '0;
            pe_valid_out        <= 1'b0;
            pe_switch_out       <= 1'b0;
            weight_reg_active   <= '0;
            weight_reg_inactive <= '0;
        end
        else begin
            // Pass-through control signals
            pe_valid_out  <= pe_valid_in;
            pe_switch_out <= pe_switch_in;

            // Weight register updates
            if (pe_accept_w_in) begin
                // Load new weight into inactive register and forward it south
                weight_reg_inactive <= pe_weight_in;
                pe_weight_out       <= pe_weight_in;
            end
            else begin
                pe_weight_out <= '0;
            end

            // Swap active weight when switch is asserted
            if (pe_switch_in) begin
                if (pe_accept_w_in) begin
                    // Directly load the new weight as active this cycle
                    weight_reg_active <= pe_weight_in;
                end
                else begin
                    // Promote previously loaded inactive weight
                    weight_reg_active <= weight_reg_inactive;
                end
            end
            // else: retain weight_reg_active

            // Data path: MAC + propagate input east
            if (pe_valid_in) begin
                pe_input_out <= pe_input_in;
                pe_psum_out  <= mac_out;   // FP32 MAC result
            end
            else begin
                pe_valid_out <= 1'b0;
                pe_psum_out  <= '0;
            end
        end
    end

endmodule
