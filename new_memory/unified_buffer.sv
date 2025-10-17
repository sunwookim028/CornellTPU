`timescale 1ns/1ps

module UnifiedBuffer #(
  parameter int DATA_W = DATA_WIDTH, // Width of data
  parameter int ADDR_W = ADDR_WIDTH, // Width of address
  parameter int NB     = NUM_BANKS   // Number of banks
)(
  input  logic                       clk,
  input  logic                       reset,

  // ==== DMA side (from DMAEngine) ====
  input  logic                       dma_write_en,
  input  logic                       dma_read_en,
  input  logic [ADDR_W-1:0]          dma_addr,
  input  logic [DATA_W-1:0]          dma_data_in,
  output logic [DATA_W-1:0]          dma_data_out,

  // ==== Compute side (1 port per bank) ====
  input  logic [NB-1:0]                 pe_read_en,
  input  logic [NB-1:0]                 pe_write_en,
  input  logic [NB-1:0][ADDR_W-1:0]     pe_addr,
  input  logic [NB-1:0][DATA_W-1:0]     pe_data_in,
  output logic [NB-1:0][DATA_W-1:0]     pe_data_out
);

  // -------------------------------
  // Internal wires between submodules
  // -------------------------------
  logic [BANK_BITS-1:0]              dma_bank_sel;     // Bank selected by DMA
  logic [ADDR_W-1:0]                 dma_local_addr;   // Address within bank

  logic [NB-1:0]                     bank_we;          // Write enable per bank
  logic [NB-1:0][ADDR_W-1:0]         bank_addr;        // Address per bank
  logic [NB-1:0][DATA_W-1:0]         bank_din;         // Data in per bank
  logic [NB-1:0][DATA_W-1:0]         bank_dout;        // Data out per bank

  // -------------------------------
  // Address translation: global DMA addr -> bank + local addr
  // -------------------------------
  AddressTranslation #(
    .ADDR_W(ADDR_W),
    .NB(NB)
  ) u_addr_xlat (
    .global_addr(dma_addr),
    .bank_sel(dma_bank_sel),
    .local_addr(dma_local_addr)
  );

  // -------------------------------
  // Crossbar: routes DMA or PE signals to the correct bank
  // -------------------------------
  Crossbar #(
    .DATA_W(DATA_W),
    .ADDR_W(ADDR_W),
    .NB(NB)
  ) u_xbar (
    .dma_write_en (dma_write_en),
    .dma_read_en  (dma_read_en),
    .dma_bank_sel (dma_bank_sel),
    .dma_local_addr(dma_local_addr),
    .dma_data_in  (dma_data_in),
    .bank_data_out(bank_dout),
    .dma_data_out (dma_data_out),

    .pe_read_en (pe_read_en),
    .pe_write_en(pe_write_en),
    .pe_addr    (pe_addr),
    .pe_data_in (pe_data_in),

    .bank_we   (bank_we),
    .bank_addr (bank_addr),
    .bank_din  (bank_din)
  );

  // -------------------------------
  // Instantiate memory banks
  // -------------------------------
  generate
    genvar i;
    for (i = 0; i < NB; i++) begin : g_banks
      MemoryBank #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
      ) u_bank (
        .clk (clk),
        .we  (bank_we[i]),
        .addr(bank_addr[i]),
        .din (bank_din[i]),
        .dout(bank_dout[i])
      );

      // Connect each bank's output to its PE port
      assign pe_data_out[i] = bank_dout[i];
    end
  endgenerate

endmodule
