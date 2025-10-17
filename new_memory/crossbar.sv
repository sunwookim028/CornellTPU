`timescale 1ns/1ps

module Crossbar #(
  parameter int DATA_W = 32,  // Width of each data word
  parameter int ADDR_W = 10,  // Width of address within a bank
  parameter int NB     = 4   // Number of banks
)(
  // ==== DMA side (global access path) ====
  input  logic                      dma_write_en,    // DMA write enable
  input  logic                      dma_read_en,     // DMA read enable
  input  logic [2-1:0]      dma_bank_sel,    // Which bank DMA targets
  input  logic [ADDR_W-1:0]         dma_local_addr,  // Address within that bank
  input  logic [DATA_W-1:0]         dma_data_in,     // Data written by DMA
  input  logic [NB-1:0][DATA_W-1:0] bank_data_out,   // Data read from all banks
  output logic [DATA_W-1:0]         dma_data_out,    // Data sent back to DMA

  // ==== Compute side (1 dedicated port per bank) ====
  input  logic [NB-1:0]                 pe_read_en,   // Per-bank read enables
  input  logic [NB-1:0]                 pe_write_en,  // Per-bank write enables
  input  logic [NB-1:0][ADDR_W-1:0]     pe_addr,      // Per-bank local addresses
  input  logic [NB-1:0][DATA_W-1:0]     pe_data_in,   // Per-bank write data

  // ==== Connections to actual memory banks ====
  output logic [NB-1:0]                 bank_we,      // Write enable per bank
  output logic [NB-1:0][ADDR_W-1:0]     bank_addr,    // Address per bank
  output logic [NB-1:0][DATA_W-1:0]     bank_din      // Write data per bank
);

  // -------------------------------------------------------------------------
  // Default: Each compute PE controls its own bank directly.
  // If DMA is active (read or write), it temporarily overrides that one bank.
  // -------------------------------------------------------------------------
  always_comb begin
    // Default connections from PEs
    for (int i = 0; i < NB; i++) begin
      bank_we[i]   = pe_write_en[i];
      bank_addr[i] = pe_addr[i];
      bank_din[i]  = pe_data_in[i];
    end

    // Override selected bank when DMA is active
    if (dma_write_en || dma_read_en) begin
      bank_we[dma_bank_sel]   = dma_write_en;
      bank_addr[dma_bank_sel] = dma_local_addr;
      bank_din[dma_bank_sel]  = dma_data_in;
    end
  end

  // DMA reads data from its selected bank
  assign dma_data_out = bank_data_out[dma_bank_sel];

endmodule
