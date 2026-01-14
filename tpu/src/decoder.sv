`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 05:41:52 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input logic [63:0] instr_decode,
    output logic [22:0] len_decode,
    output logic [9:0] opcode_decode,
    output logic [12:0] addr_const_decode,
    output logic [12:0] addr_out_decode,
    output logic [12:0] addr_b_decode,
    output logic [12:0] addr_a_decode,
    output logic [1:0] mode_decode
    );
    
    assign len_decode = instr_decode[22:0];
    assign opcode_decode = instr_decode[9:0];
    assign addr_const_decode = instr_decode[22:10];
    assign addr_out_decode = instr_decode[35:23];
    assign addr_b_decode = instr_decode[48:36];
    assign addr_a_decode = instr_decode[61:49];
    assign mode_decode = instr_decode[63:62];
    
    
endmodule
