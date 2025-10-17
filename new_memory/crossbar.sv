`timescale 1ns/1ps

module Crossbar #(
  parameter int DATA_W = DATA_WIDTH,
  parameter int ADDR_W = ADDR_WIDTH,
  parameter int NB     = NUM_BANKS
)(
  // ==== DMA side ====
  input  logic                      dma_write_en,
  input  logic                      dma_read_en,
  input  logic [BANK_BITS-1:0]      dma_bank_sel,
  input  logic [ADDR_W-1:0]         dma_local_addr,
  input  logic [DATA_W-1:0]         dma_data_in,
  input  logic [NB-1:0][DATA_W-1:0] bank_data_out, // from banks
  output logic [DATA_W-1:0]         dma_data_out,

  // ==== Compute side (1 port per bank) ====
  input  logic [NB-1:0]                 pe_read_en,
  input  logic [NB-1:0]                 pe_write_en,
  input  logic [NB-1:0][ADDR_W-1:0]     pe_addr,
  input  logic [NB-1:0][DATA_W-1:0]     pe_data_in,

  // ==== To banks ====
  output logic [NB-1:0]                 bank_we,
  output logic [NB-1:0][ADDR_W-1:0]     bank_addr,
  output logic [NB-1:0][DATA_W-1:0]     bank_din
);
  // Default: compute owns each bank. If DMA active, it overrides the selected bank.
  always_comb begin
    for (int i = 0; i < NB; i++) begin
      bank_we[i]   = pe_write_en[i];
      bank_addr[i] = pe_addr[i];
      bank_din[i]  = pe_data_in[i];
    end

    if (dma_write_en || dma_read_en) begin
      bank_we[dma_bank_sel]   = dma_write_en;
      bank_addr[dma_bank_sel] = dma_local_addr;
      bank_din[dma_bank_sel]  = dma_data_in;
    end
  end

  assign dma_data_out = bank_data_out[dma_bank_sel];
endmodule
