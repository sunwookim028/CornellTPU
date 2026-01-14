`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 10:01:43 AM
// Design Name: 
// Module Name: compute_core
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


module compute_core #(
    parameter ADDR_WIDTH = 13,
    parameter DATA_WIDTH = 32,

    // VPU-specific params
    parameter VPU_DATA_W  = 32,
    parameter VPU_ADDR_W  = 13,
    parameter VPU_OP_W    = 4,
    parameter VPU_IADDR_W = 5
)(
    input  logic clk,
    input  logic rst_n,
    input logic [1:0] mode_compute,
    input  logic [ADDR_WIDTH-1:0]    addr_a_compute,
    input  logic [ADDR_WIDTH-1:0]    addr_b_compute,
    input  logic [ADDR_WIDTH-1:0]    addr_out_compute,
    input logic [ADDR_WIDTH-1:0]     addr_const_compute,
    input logic [9:0] opcode_compute,
    input  logic [22:0]              len_compute,
    input logic start_systolic_compute,
    input logic start_vadd_compute,
    input logic start_vpu_compute,
    output logic systolic_done_compute,
    output logic vadd_done_compute,
    output logic vpu_done_compute,
    
    // BRAM Port B Interface
    output logic [ADDR_WIDTH-1:0]    bram_addr_b,
    output logic [DATA_WIDTH-1:0]    bram_din_b,
    input  logic [DATA_WIDTH-1:0]    bram_dout_b,
    output logic                     bram_en_b,
    output logic                     bram_we_b
);

    logic [ADDR_WIDTH-1:0]    addr;
    logic [DATA_WIDTH-1:0]    din_b;
    logic [DATA_WIDTH-1:0]    dout_b;
    logic                     en_b;
    logic                     we_b;
    
    logic [ADDR_WIDTH-1:0]    vadd_addr;
    logic [DATA_WIDTH-1:0]    vadd_din_b;
    logic [DATA_WIDTH-1:0]    vadd_dout_b;
    logic                     vadd_en_b;
    logic                     vadd_we_b;
    
    logic [ADDR_WIDTH-1:0]    systolic_addr;
    logic [DATA_WIDTH-1:0]    systolic_din_b;
    logic [DATA_WIDTH-1:0]    systolic_dout_b;
    logic                     systolic_en_b;
    logic                     systolic_we_b;
    
    logic [ADDR_WIDTH-1:0]    vpu_addr;
    logic [DATA_WIDTH-1:0]    vpu_din_b;
    logic [DATA_WIDTH-1:0]    vpu_dout_b;
    logic                     vpu_en_b;
    logic                     vpu_we_b;
    

    compute_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_compute_top (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_vadd_compute),
        .done(vadd_done_compute),

        // BRAM B port
        .bram_addr_b(vadd_addr),
        .bram_din_b (vadd_din_b),
        .bram_dout_b(vadd_dout_b),
        .bram_en_b  (vadd_en_b),
        .bram_we_b  (vadd_we_b),

        .addr_a_vadd(addr_a_compute),
        .addr_b_vadd(addr_b_compute),
        .addr_out_vadd(addr_out_compute),
        .len_vadd(len_compute)
    );

    systolic_wrapper #(
        .N(4),
        .DATA_WIDTH(DATA_WIDTH),
        .BANKING_FACTOR(1),
        .ADDRESS_WIDTH(ADDR_WIDTH),
        .MEM_LATENCY(3)
    ) u_systolic (
        .clk(clk),
        .rst_n(rst_n),

        .start(start_systolic_compute),
        .done(systolic_done_compute),

        .base_addr_w(addr_a_compute),
        .base_addr_x(addr_b_compute),
        .base_addr_out(addr_out_compute),
        
        // BRAM port
        .mem_req_addr(systolic_addr),
        .mem_req_data(systolic_din_b),
        .mem_resp_data(systolic_dout_b),
        .mem_read_en (systolic_en_b),
        .mem_write_en(systolic_we_b)
    );



    vpu_top #(
        .DATA_W(VPU_DATA_W),
        .ADDR_W(VPU_ADDR_W),
        .OP_W(VPU_OP_W),
        .INST_ADDR(VPU_IADDR_W),
        .M(4)
    )u_vpu_top (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_vpu_compute),
        .inst_addr_a(addr_a_compute),
        .inst_addr_b(addr_b_compute),
        .inst_addr_c(addr_out_compute),
        .inst_addr_const(addr_const_compute),
        .opcode(opcode_compute),
        
        // BRAM B port
        .bram_addr(vpu_addr),
        .bram_din(vpu_din_b),
        .bram_dout(vpu_dout_b),
        .bram_en(vpu_en_b),
        .bram_we(vpu_we_b),
        .done(vpu_done_compute)

    );
    
    //---------------------------------------------
// BRAM PORT B ARBITRATION
//---------------------------------------------
always_comb begin
    // default safe values
    bram_addr_b = '0;
    bram_din_b  = '0;
    bram_en_b   = 1'b0;
    bram_we_b   = 1'b0;

    // default passthrough dout to all units
    vadd_dout_b      = bram_dout_b;
    systolic_dout_b  = bram_dout_b;
    vpu_dout_b       = bram_dout_b;

    case (mode_compute)
        
        2'b00: begin  // VPU
            bram_addr_b = vpu_addr;
            bram_din_b  = vpu_din_b;
            bram_en_b   = vpu_en_b;
            bram_we_b   = vpu_we_b;
        end

        2'b01: begin  // Systolic
            
            bram_addr_b = systolic_addr;
            bram_din_b  = systolic_din_b;
            bram_en_b   = systolic_en_b;
            bram_we_b   = systolic_we_b;
        end

        2'b10: begin  // Vadd
            bram_addr_b = vadd_addr;
            bram_din_b  = vadd_din_b;
            bram_en_b   = vadd_en_b;
            bram_we_b   = vadd_we_b;
        end

        default: begin
            // No-op, keep BRAM idle
            bram_addr_b = '0;
            bram_din_b  = '0;
            bram_en_b   = 1'b0;
            bram_we_b   = 1'b0;
        end
    endcase
end


endmodule