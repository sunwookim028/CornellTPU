`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 12:44:49 AM
// Design Name: 
// Module Name: const_driver
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


module const_driver#(
    parameter DATA_BIT_WIDTH = 32,
    parameter VALUE = 32'hDEADBEEF
)(
    input logic clk, 
    input logic rst_n,
    
    output logic [DATA_BIT_WIDTH-1:0] out_data
    );

    always_ff @( clk ) begin 
        if(!rst_n) begin
            out_data <= '0;
        end else begin
            out_data <= VALUE;
        end
    end

endmodule
