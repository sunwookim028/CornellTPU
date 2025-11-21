import os
import subprocess

def test_vpu_top():
    """Test the VPU top module with memory interface signals"""

    os.makedirs("build", exist_ok=True)

    # Create testbench
    testbench_code = """
`timescale 1ns/1ps

module test_vpu_top;
    parameter DATA_W = 32;
    parameter ADDR_W = 16;
    parameter OP_W = 4;
    parameter INST_ADDR = 5;
    
    // Clock and reset
    reg clk;
    reg rst;
    
    // VPU inputs
    reg [31:0] inst;
    reg mem_rdy;
    reg mem_read_en;
    reg mem_write_en;
    
    // VPU outputs
    wire [ADDR_W-1:0] addr_a;
    wire [ADDR_W-1:0] addr_b;
    wire [ADDR_W-1:0] addr_c;
    wire [DATA_W-1:0] data_c;
    wire done;
    
    // Memory interface inputs
    reg [DATA_W-1:0] data_a;
    reg [DATA_W-1:0] data_b;
    
    // Test memory
    reg [31:0] test_memory [0:31];
    integer test_count;
    integer error_count;
    
    // Instantiate DUT
    vpu_top dut (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .mem_rdy(mem_rdy),
        .mem_read_en(mem_read_en),
        .mem_write_en(mem_write_en),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .addr_c(addr_c),
        .data_a(data_a),
        .data_b(data_b),
        .data_c(data_c),
        .done(done)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Helper function to create instruction
    function [31:0] create_instruction;
        input [INST_ADDR-1:0] a_addr;
        input [INST]()