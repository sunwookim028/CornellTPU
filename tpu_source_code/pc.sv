`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 05:41:52 PM
// Design Name: 
// Module Name: pc
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


module pc #(
    parameter PC_WIDTH = 8
)(
    input  logic                 clk,
    input  logic                 rst_n,

    input  logic                 PC_enable,       // advance
    input  logic                 PC_load,         // jump
    input  logic [PC_WIDTH-1:0]  PC_load_val,     // jump target

    output logic [PC_WIDTH-1:0]  PC
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            PC <= '0;
        end else begin
            if (PC_load)
                PC <= PC_load_val;
            else if (PC_enable)
                PC <= PC + 1;
        end
    end

endmodule
