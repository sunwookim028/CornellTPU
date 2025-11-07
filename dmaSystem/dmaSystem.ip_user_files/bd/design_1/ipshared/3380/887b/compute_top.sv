`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 12:56:43 AM
// Design Name: 
// Module Name: compute_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module compute_top #(
    parameter ADDR_WIDTH = 13,
    parameter DATA_WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     start,
    input  logic [ADDR_WIDTH-1:0]    addr_a,
    input  logic [ADDR_WIDTH-1:0]    addr_b,
    input  logic [ADDR_WIDTH-1:0]    addr_out,
    input  logic [31:0]              len,
    output logic                     done,

    // BRAM Port B Interface
    output logic [ADDR_WIDTH-1:0]    bram_addr_b,
    output logic [DATA_WIDTH-1:0]    bram_din_b,
    input  logic [DATA_WIDTH-1:0]    bram_dout_b,
    output logic                     bram_en_b,
    output logic                     bram_we_b
);

    // FSM state definitions
    typedef enum logic [4:0] {
        IDLE,
        READ_A,
        READ_A_W1,
        READ_A_W2,
        READ_B,
        READ_B_W1,
        READ_B_W2,
        WRITE_OUT,
        DONE
    } state_t;

    state_t state = IDLE;

    // Loop counter and temporary storage
    logic [31:0] i;
    logic [DATA_WIDTH-1:0] data_a, data_b, data_sum;

    // Instantiate the compute unit. here- (vadd)
    vadd #(.DATA_WIDTH(DATA_WIDTH)) u_vadd (
        .a(data_a),
        .b(data_b),
        .sum(data_sum)
    );

    // FSM behavior
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            done         <= 1'b0;
            i            <= '0;
            bram_en_b    <= 1'b0;
            bram_we_b    <= 1'b0;
            bram_addr_b  <= '0;
            bram_din_b   <= '0;
            data_a       <= '0;
            data_b       <= '0;
        end else begin
            done      <= 1'b0;
            bram_we_b <= 1'b0;

            case (state)
                // Wait for start signal
                IDLE: begin
                    if (start) begin
                        i     <= 0;
                        state <= READ_A;
                    end
                end

                // Read A[i] from BRAM
                READ_A: begin
                    bram_en_b   <= 1'b1;
                    bram_we_b   <= 1'b0;
                    bram_addr_b <= addr_a + i;
                    state       <= READ_A_W1;
                end
                
                READ_A_W1: begin 
                    state <= READ_A_W2;
                end
                
                READ_A_W2: begin
                    data_a <= bram_dout_b;
                    state <= READ_B;
                end

                // Read B[i] from BRAM
                READ_B: begin
                    bram_en_b   <= 1'b1;
                    bram_we_b   <= 1'b0;
                    bram_addr_b <= addr_b + i;
                    state       <= READ_B_W1;
                end
                
                READ_B_W1: begin
                    state <= READ_B_W2;
                end
                
                READ_B_W2: begin
                    data_b <= bram_dout_b;
                    state <= WRITE_OUT;
                end

                // Write SUM to C[i] in BRAM
                WRITE_OUT: begin
                    bram_en_b   <= 1'b1;
                    bram_we_b   <= 1'b1;
                    bram_addr_b <= addr_out + i;
                    bram_din_b  <= data_sum;

                    if (i >= len - 1) begin
                        state <= DONE;
                    end else begin
                        i     <= i + 1;
                        state <= READ_A;
                    end
                end

                // Raise done and return to idle
                DONE: begin
                    done  <= 1'b1;
                    bram_en_b <= 1'b0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
