`timescale 1ns/1ps
`default_nettype none

module top_systolic_test;

    localparam int N = 4;
    localparam int DATA_WIDTH = 16;
    localparam int BANKING_FACTOR = 1;
    localparam int ADDRESS_WIDTH = 13;
    localparam int MEM_LATENCY = 3;

    localparam logic [ADDRESS_WIDTH-1:0] BASE_ADDR_W = 13'h000;
    localparam logic [ADDRESS_WIDTH-1:0] BASE_ADDR_X = 13'h100;
    localparam logic [ADDRESS_WIDTH-1:0] BASE_ADDR_OUT = 13'h010;

    // Clock/reset
    logic clk;
    logic rst;

    // Interconnect wires
    logic [ADDRESS_WIDTH-1:0] mem_req_addr;
    logic [BANKING_FACTOR*DATA_WIDTH-1:0] mem_req_data;
    logic [BANKING_FACTOR*DATA_WIDTH-1:0] mem_resp_data;
    logic mem_read_en;
    logic mem_write_en;

    logic start;
    logic done;

    logic [ADDRESS_WIDTH-1:0] base_addr_w;
    logic [ADDRESS_WIDTH-1:0] base_addr_x;
    logic [ADDRESS_WIDTH-1:0] base_addr_out;

    assign base_addr_w = BASE_ADDR_W;
    assign base_addr_x = BASE_ADDR_X;
    assign base_addr_out = BASE_ADDR_OUT;

    logic signed [DATA_WIDTH-1:0] out_matrix [N*N-1:0];

    // DUT
    systolic_wrapper #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .BANKING_FACTOR(BANKING_FACTOR),
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .MEM_LATENCY(MEM_LATENCY)
    ) wrapper_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .base_addr_w(base_addr_w),
        .base_addr_x(base_addr_x),
        .base_addr_out(base_addr_out),

        .mem_req_addr(mem_req_addr),
        .mem_req_data(mem_req_data),
        .mem_resp_data(mem_resp_data),
        .mem_read_en(mem_read_en),
        .mem_write_en(mem_write_en),

        .out_matrix(out_matrix)
    );

    mock_memory #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .BANKING_FACTOR(BANKING_FACTOR),
        .MEM_LATENCY(MEM_LATENCY-2),
        .BASE_ADDR_X(BASE_ADDR_X),
        .BASE_ADDR_W(BASE_ADDR_W)
    ) mem_inst (
        .clk(clk),
        .rst(rst),
        .mem_read_en(mem_read_en),
        .mem_req_addr(mem_req_addr),
        .mem_resp_data(mem_resp_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

endmodule
