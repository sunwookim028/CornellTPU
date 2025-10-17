`timescale 1ns/1ps

module tb_dma_ub_complex;

  // -----------------------------
  // Parameters
  // -----------------------------
  localparam DATA_W = 32;
  localparam ADDR_W = 10;
  localparam NB     = 4;
  localparam BANK_BITS = 2;

  // -----------------------------
  // Clock & Reset
  // -----------------------------
  logic clk = 0, reset = 1;
  always #5 clk = ~clk; // 100 MHz clock

  // -----------------------------
  // DMA interface
  // -----------------------------
  logic dma_write_en, dma_read_en;
  logic [ADDR_W-1:0] dma_addr;
  logic [DATA_W-1:0] dma_data_in, dma_data_out;

  // -----------------------------
  // PE interface
  // -----------------------------
  logic [NB-1:0] pe_read_en, pe_write_en;
  logic [NB-1:0][ADDR_W-1:0] pe_addr;
  logic [NB-1:0][DATA_W-1:0] pe_data_in, pe_data_out;

  // -----------------------------
  // Unified Buffer DUT
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
  // Variables
  // -----------------------------
  int i;
  logic [DATA_W-1:0] expected_data [0:255];

  // -----------------------------
  // Task helpers
  // -----------------------------
  task dma_write(input int addr, input [DATA_W-1:0] data);
    begin
      dma_write_en = 1;
      dma_addr = addr;
      dma_data_in = data;
      #10;
      dma_write_en = 0;
      #5;
    end
  endtask

  task dma_read(input int addr, output [DATA_W-1:0] data_out);
    begin
      dma_read_en = 1;
      dma_addr = addr;
      #10;
      data_out = dma_data_out;
      dma_read_en = 0;
      #5;
    end
  endtask

  // -----------------------------
  // Test sequence
  // -----------------------------
  initial begin
    // --- Reset phase ---
    dma_write_en = 0;
    dma_read_en  = 0;
    pe_read_en   = 0;
    pe_write_en  = 0;
    dma_addr     = 0;
    pe_addr      = 0;
    pe_data_in   = 0;

    #20 reset = 0;
    $display("\n=== Testbench start ===\n");

    // -----------------------------
    // 1. DMA burst write test
    // -----------------------------
    $display("=== [1] DMA Burst Write Test ===");
    for (i = 0; i < 16; i++) begin
      expected_data[i] = 32'hDEAD0000 + i;
      dma_write(i, expected_data[i]);
    end
    #20;

    // -----------------------------
    // 2. DMA read verify
    // -----------------------------
    $display("=== [2] DMA Read Verification ===");
    for (i = 0; i < 16; i++) begin
      logic [DATA_W-1:0] rd;
      dma_read(i, rd);
      if (rd !== expected_data[i]) begin
        $fatal(1, "DMA Read Mismatch at addr %0d: got 0x%0h expected 0x%0h", i, rd, expected_data[i]);
      end else begin
        $display("DMA Read OK: Addr %0d = 0x%0h", i, rd);
      end
    end
    #20;

    // -----------------------------
    // 3. Concurrent PE writes while DMA reads
    // -----------------------------
    $display("=== [3] Concurrent PE Writes vs DMA Reads ===");
    fork
      begin
        // PE writes unique patterns to each bank
        for (int j = 0; j < NB; j++) begin
          pe_write_en[j] = 1;
          pe_addr[j]     = 10'h100 + j;
          pe_data_in[j]  = 32'hBEEF0000 + j;
        end
        #10;
        pe_write_en = 0;
      end
      begin
        // DMA reads overlapping region
        for (int k = 0; k < 8; k++) begin
          logic [DATA_W-1:0] rd;
          dma_read(k, rd);
          $display("DMA concurrent read @%0d -> 0x%0h", k, rd);
        end
      end
    join
    #20;

    // -----------------------------
    // 4. PE readback test
    // -----------------------------
    $display("=== [4] PE Readback Test ===");
    for (int j = 0; j < NB; j++) begin
      pe_read_en[j] = 1;
      pe_addr[j]    = 10'h100 + j;
    end
    #10;
    for (int j = 0; j < NB; j++) begin
      $display("PE[%0d] read -> 0x%0h", j, pe_data_out[j]);
      if (pe_data_out[j] !== (32'hBEEF0000 + j))
        $fatal(1, "PE[%0d] readback mismatch", j);
    end
    pe_read_en = 0;
    #20;

    // -----------------------------
    // 5. DMA overwrite partial region
    // -----------------------------
    $display("=== [5] DMA Overwrite Test ===");
    for (i = 4; i < 8; i++) begin
      dma_write(i, 32'hABCD1000 + i);
    end

    $display("DMA overwrote addresses 4–7, verifying...");
    for (i = 0; i < 8; i++) begin
      logic [DATA_W-1:0] rd;
      dma_read(i, rd);
      $display("DMA Read Addr %0d -> 0x%0h", i, rd);
    end

    #50;
    $display("\n=== Test Complete: all checks passed ===\n");
    $finish;
  end

endmodule
