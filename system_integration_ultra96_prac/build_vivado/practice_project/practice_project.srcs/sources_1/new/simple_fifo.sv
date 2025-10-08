`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2025 
// Design Name: simple fifo module to test integrating rtl modules in development flow
// Module Name: simple_fifo
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


module simple_fifo #(
    parameter DATA_BIT_WIDTH = 32,
    parameter DEPTH = 32,
    parameter ADDR_BIT_WIDTH = $clog2(DEPTH)
    )(
    input logic clk,
    input logic rst_n,

    input logic [DATA_BIT_WIDTH-1:0] in_data,
    input logic in_valid,
    output logic in_ready,

    output logic [DATA_BIT_WIDTH-1:0] out_data,
    output logic out_valid,
    input logic out_ready
    );

    logic [DATA_BIT_WIDTH-1:0] fifo_mem [DEPTH-1:0];
    logic [ADDR_BIT_WIDTH-1:0] w_ptr, r_ptr;
    logic [ADDR_BIT_WIDTH:0] count;

    always_comb begin 
        in_ready = count < DEPTH;
        out_valid = count > 0;
        out_data = fifo_mem[r_ptr];
    end

    always_ff @( posedge clk ) begin 
        if(!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
        end else begin
            //write
            if(in_valid && in_ready) begin
                fifo_mem[w_ptr] <= in_data;
                w_ptr <= w_ptr+1;
                count <= count + 1;
            end

            //read
            if(out_valid & out_ready) begin
                r_ptr <= (r_ptr + 1);
                count <= count-1;
            end
        end
    end





endmodule
