`timescale 1ns/1ps

module tb_dma_ub;

  // -----------------------------
  // Parameters for UB and PEs
  // -----------------------------
  localparam DATA_W = 32;
  localparam ADDR_W = 10;
  localparam NB     = 4;
  localparam BANK_BITS = 2; // for 4 banks

  // -----------------------------
  // Clock & Reset
  // -----------------------------
  logic clk = 0;
  logic reset = 1;
  always #5 clk = ~clk; // 100 MHz

  // -----------------------------
  // DMA interface
  // -----------------------------
  logic dma_write_en, dma_read_en;
  logic [ADDR_W-1:0] dma_addr;
  logic [DATA_W-1:0] dma_data_in;
  logic [DATA_W-1:0] dma_data_out;

  // -----------------------------
  // PE interface (one per bank)
  // -----------------------------
  logic [NB-1:0] pe_read_en, pe_write_en;
  logic [NB-1:0][ADDR_W-1:0] pe_addr;
  logic [NB-1:0][DATA_W-1:0] pe_data_in, pe_data_out;

  // -----------------------------
  // Instantiate the UnifiedBuffer
  // -----------------------------
  UnifiedBuffer #(
    .DATA_W(DATA_W),
    .ADDR_W(ADDR_W),
    .NB(NB)
  ) ub (
    .clk(clk),
    .reset(reset),
    .dma_write_en(dma_write_en),
    .dma_read_en(dma_read_en),
    .dma_addr(dma_addr),
    .dma_data_in(dma_data_in),
    .dma_data_out(dma_data_out),
    .pe_read_en(pe_read_en),
    .pe_write_en(pe_write_en),
    .pe_addr(pe_addr),
    .pe_data_in(pe_data_in),
    .pe_data_out(pe_data_out)
  );

  // -----------------------------
  // Utility task for checking results
  // -----------------------------
  task automatic check_output(input [DATA_W-1:0] expected, input [DATA_W-1:0] actual, input string label);
    if (actual === expected)
      $display("\033[0;32m[PASS]\033[0m %s: Expected = 0x%0h, Got = 0x%0h", label, expected, actual);
    else
      $display("\033[0;31m[FAIL]\033[0m %s: Expected = 0x%0h, Got = 0x%0h", label, expected, actual);
  endtask

  integer i;

  // -----------------------------
  // Main test sequence
  // -----------------------------
  initial begin
    // Initialize signals
    reset = 1;
    dma_write_en = 0;
    dma_read_en  = 0;
    dma_addr = 0;
    dma_data_in = 0;
    pe_read_en  = 0;
    pe_write_en = 0;
    pe_addr     = 0;
    pe_data_in  = 0;

    #20 reset = 0;
    #20;

    $display("===== DMA Write Test =====");
    for (i = 0; i < 8; i=i+1) begin
      dma_write_en = 1;
      dma_addr = i;
      dma_data_in = 32'hA000 + i;
      #10;
    end
    dma_write_en = 0;

    #20;

    $display("===== DMA Read Test =====");
    for (i = 0; i < 8; i=i+1) begin
      dma_read_en = 1;
      dma_addr = i;
      #10;
      check_output(32'hA000 + i, dma_data_out, $sformatf("DMA Read Addr %0d", i));
    end
    dma_read_en = 0;

    #20;

    $display("===== PE Write Test =====");
    for (i = 0; i < NB; i=i+1) begin
      pe_write_en[i] = 1;
      pe_addr[i]     = 10'h200 + i;
      pe_data_in[i]  = 32'hB0000 + i;
    end
    #10;
    pe_write_en = 0;

    #20;

    $display("===== PE Read Test =====");
    for (i = 0; i < NB; i=i+1) pe_read_en[i] = 1;
    #10;
    for (i = 0; i < NB; i=i+1)
      check_output(32'hB0000 + i, pe_data_out[i], $sformatf("PE[%0d] Read Addr 0x%0h", i, pe_addr[i]));
    pe_read_en = 0;

    #20;
    $display("===== TEST COMPLETE =====");
    $finish;
  end

endmodule
