`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 01:18:23 AM
// Design Name: 
// Module Name: const_driver_tb
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

// tb module for verifying simple const_driver module

module const_driver_tb;
    localparam CLK_PERIOD_NS = 10;
    localparam RST_CYCLES = 5;
    localparam DATA_BIT_WIDTH = 32;
    localparam VALUE = 32'hDEADBEEF;

    logic clk;
    logic rst_n;
    logic [31:0] out_data;

    always #(CLK_PERIOD_NS/2) clk = ~clk;
    

    const_driver #(
        .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
        .VALUE(VALUE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .out_data(out_data)
    );

    initial clk = 0;

    initial begin
        //init reset
        rst_n = 0;
        #(CLK_PERIOD_NS * RST_CYCLES) @(posedge clk);
        rst_n = 1;
        

        //run for some time
        #(CLK_PERIOD_NS * 50) @(posedge clk);

        // reset
        rst_n = 0;
        #(CLK_PERIOD_NS * RST_CYCLES) @(posedge clk);
        rst_n = 1;

        //continue running
        #(CLK_PERIOD_NS * 100) @(posedge clk);
        
        $finish;
    end
endmodule

