`timescale 1ns/1ps

module tb_dma_ub;

  // -----------------------------
  // Parameters for UB and PEs
  // -----------------------------
  localparam DATA_W = 32;                 // Data width per word
  localparam ADDR_W = 10;                  // Address width per bank
  localparam NB     = 4;                  // Number of banks
  localparam BANK_BITS = 2;      // Bits needed to select a bank

  // -----------------------------
  // Clock & Reset
  // -----------------------------
  logic clk = 0;
  logic reset = 1;
  always #5 clk = ~clk; // 100 MHz clock: toggle every 5 ns

  // -----------------------------
  // DMA interface signals
  // -----------------------------
  logic dma_write_en, dma_read_en;
  logic [ADDR_W-1:0] dma_addr;
  logic [DATA_W-1:0] dma_data_in;
  logic [DATA_W-1:0] dma_data_out; // from UnifiedBuffer

  // -----------------------------
  // PE interface signals (one per bank)
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
  // Test loop variables
  // -----------------------------
  integer i;

  // -----------------------------
  // Initialize signals and run tests
  // -----------------------------
  initial begin
    // --- Reset ---
    reset = 1;
    dma_write_en = 0;
    dma_read_en  = 0;
    dma_addr = 0;
    dma_data_in = 0;
    pe_read_en  = 0;
    pe_write_en = 0;
    pe_addr     = 0;
    pe_data_in  = 0;
    #20 reset = 0; // Release reset after 20 ns

    #20; // wait a few cycles

    $display("===== DMA Write Test =====");
    // --- DMA Write: DRAM -> UB ---
    // We write 8 words via DMA to the Unified Buffer
    // Expectation: bank selected by AddressTranslation gets updated
    for (i = 0; i < 8; i=i+1) begin
      dma_write_en = 1;               // Enable DMA write
      dma_addr = i;                    // Global address (maps to a bank)
      dma_data_in = 32'hA000 + i;       // Sample data pattern: 0xA0, 0xA1, ...
      #10;                             // Wait 1 clock cycle for write
    end
    dma_write_en = 0;                  // Disable DMA write

    #20;

    $display("===== DMA Read Test =====");
    // --- DMA Read: UB -> DRAM ---
    // Read back the previously written data
    // Expectation: dma_data_out matches dma_data_in
    for (i = 0; i < 8; i=i+1) begin
      dma_read_en = 1;                 // Enable DMA read
      dma_addr = i;                     // Address to read
      #10;                              // Wait 1 clock cycle
      $display("DMA Read: Addr %0d, Data Out: 0x%0h", i, dma_data_out);
    end
    dma_read_en = 0;

    #20;

    $display("===== PE Access Test =====");
    // --- PE Write: each PE writes to its own bank ---
    // Expectation: each bank gets the correct PE data
    for (i = 0; i < NB; i=i+1) begin
      pe_write_en[i] = 1;              // Enable write for PE i
      pe_addr[i]     = 10'h200 + i;      // Local address per bank
      pe_data_in[i]  = 32'hB0000 + i;     // Sample pattern
    end
    #10;                                // Wait 1 cycle
    pe_write_en = 0;                     // Disable PE writes

    // --- PE Read: read back from each bank ---
    // Expectation: pe_data_out[i] matches pe_data_in[i]
    for (i = 0; i < NB; i=i+1) begin
      pe_read_en[i] = 1;                 // Enable read for PE i
    end
    #10;                                 // Wait 1 cycle
    for (i = 0; i < NB; i=i+1) begin