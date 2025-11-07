`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 01:23:07 AM
// Design Name: 
// Module Name: bram_top
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


module bram_top #(
    parameter ADDR_WIDTH = 13,
    parameter DATA_WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     rst_n,

    // Control interface
    input  logic                     start_write,
    input  logic                     start_read,
    input  logic [ADDR_WIDTH-1:0]    base_addr,
    input  logic [31:0]              len,
    output logic                     done,

    // AXI4-Stream Slave interface (input from DMA MM2S)
    input  logic                   s_axis_valid,
    input  logic [DATA_WIDTH-1:0]  s_axis_data,
    input  logic                   s_axis_last,
    output logic                   s_axis_ready,
    
    // AXI4-Stream Master interface (output to DMA S2MM)
    output logic                    m_axis_valid,
    output logic  [DATA_WIDTH-1:0]  m_axis_data,
    output logic                    m_axis_last,
    input  logic                   m_axis_ready,

    // Compute-side BRAM port (Port B)
    input  logic [ADDR_WIDTH-1:0]    comp_addr_b,
    input  logic [DATA_WIDTH-1:0]    comp_din_b,
    output logic [DATA_WIDTH-1:0]    comp_dout_b,
    input  logic                     comp_en_b,
    input  logic                     comp_we_b
);

    // Internal signals
    typedef enum logic [1:0] {IDLE, WRITE_STREAM, READ_STREAM, DONE} state_t;
    state_t state = IDLE;

    logic [ADDR_WIDTH-1:0] addr_a;
    logic [31:0] word_count;
    logic [DATA_WIDTH-1:0] bram_dout_a;
    logic bram_en_a, bram_we_a;
    logic [DATA_WIDTH-1:0] bram_din_a;
    logic [DATA_WIDTH-1:0] bram_dout_a_reg;
    logic [1:0] read_latency;

    // FSM for DMA transfer
    always_ff @(posedge clk) begin
        bram_dout_a_reg <= bram_dout_a;
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_latency <= 0;
        end else if (state != READ_STREAM) begin
            // Reset latency counter when leaving this state
            read_latency <= 0;
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            word_count   <= 0;
            addr_a       <= 0;
            m_axis_valid <= 0;
            m_axis_data  <= 0;
            m_axis_last  <= 0;
            bram_en_a     <= 0;
            bram_we_a     <= 0;
            done         <= 0;
        end else begin
            // Default values
            bram_en_a     <= 0;
            bram_we_a     <= 0;
            done          <= 0;

            case (state)
                IDLE: begin
                    if (start_write) begin
                        state      <= WRITE_STREAM;
                        addr_a     <= base_addr;
                        word_count <= 0;
                    end else if (start_read) begin
                        state      <= READ_STREAM;
                        addr_a     <= base_addr;
                        word_count <= 0;
                    end
                end
                
                // dram to bram
                WRITE_STREAM: begin
                    bram_en_a     <= 1;
                    s_axis_ready <= 1;
                    if (s_axis_valid && s_axis_ready) begin
                        bram_we_a   <= 1;
                        bram_din_a  <= s_axis_data;
                        addr_a      <= addr_a + 1;
                        word_count  <= word_count + 1;
                        if (s_axis_last || word_count == len - 1) state <= DONE;
                    end
                end
                
                //bram to dram
                READ_STREAM:  begin
                   bram_en_a <= 1;
                    bram_we_a <= 0;
                
                    // Wait for BRAM to produce first word (2-cycle latency)
                    if (read_latency < 2) begin
                        read_latency <= read_latency + 1;
                        m_axis_valid <= 0;
                    end else begin
                        // Stream data continuously
                        m_axis_valid <= 1;
                        m_axis_data  <= bram_dout_a_reg;
                        m_axis_last  <= (word_count == len - 1);
                
                        if (m_axis_ready) begin
                            addr_a     <= addr_a + 1;
                            word_count <= word_count + 1;
                
                            if (word_count == len - 1) begin
                                state        <= DONE;
                            end
                        end
                    end
                    
                end 

                DONE: begin
                    m_axis_valid <= 0;
                    done  <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

    //-----------------------------------------------
    // BRAM instantiation (true dual-port)
    //-----------------------------------------------
    blk_mem_gen_0 u_bram (
        // Port A - DMA side (FSM-controlled)
        .clka(clk),
        .ena(bram_en_a),
        .wea(bram_we_a),
        .addra(addr_a),
        .dina(bram_din_a),
        .douta(bram_dout_a),

        // Port B - Compute side
        .clkb(clk),
        .enb(comp_en_b),
        .web(comp_we_b),
        .addrb(comp_addr_b),
        .dinb(comp_din_b),
        .doutb(comp_dout_b)
    );

endmodule

