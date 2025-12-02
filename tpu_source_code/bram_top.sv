`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2025 09:19:48 PM
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
    input  logic [ADDR_WIDTH-1:0]    base_addr,

    // Write interface (from Slave Stream)
    input  logic dma_wr_en,                    // asserts when data is valid
    input  logic [DATA_WIDTH-1:0] dma_wr_data,
    input logic [15:0] dma_write_pointer,

    // Read interface (to Master Stream)
    input  logic dma_rd_en,                    // asserts when it wants next word
    output logic [DATA_WIDTH-1:0] dma_rd_data,
    input logic [15:0] dma_read_pointer,

    // Compute-side BRAM port (Port B)
    input  logic [ADDR_WIDTH-1:0]    dma_comp_addr_b,
    input  logic [DATA_WIDTH-1:0]    dma_comp_din_b,
    output logic [DATA_WIDTH-1:0]    dma_comp_dout_b,
    input  logic                     dma_comp_en_b,
    input  logic                     dma_comp_we_b
);

    // Internal signals
    logic [ADDR_WIDTH-1:0] dma_addr = base_addr;

    // address counters
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dma_addr <= 0;
        else if (dma_wr_en)
            dma_addr <= base_addr + dma_write_pointer;
        else if (dma_rd_en)
            dma_addr <= base_addr + dma_read_pointer;
    end

    //-----------------------------------------------
    // BRAM instantiation (true dual-port)
    //-----------------------------------------------
    blk_mem_gen_0 u_bram (
        // Port A - DMA side (FSM-controlled)
        .clka(clk),
        .ena(1'b1),
        .wea(dma_wr_en),
        .addra(dma_addr),
        .dina(dma_wr_data),
        .douta(dma_rd_data),

        // Port B - Compute side
        .clkb(clk),
        .enb(1'b1),
        .web(dma_comp_we_b),
        .addrb(dma_comp_addr_b),
        .dinb(dma_comp_din_b),
        .doutb(dma_comp_dout_b)
    );

endmodule


