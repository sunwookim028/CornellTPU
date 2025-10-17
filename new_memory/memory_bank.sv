`timescale 1ns/1ps

module MemoryBank #(
  parameter int DATA_W = DATA_WIDTH, // Width of each memory word
  parameter int ADDR_W = ADDR_WIDTH  // Width of address bus
)(
  input  logic                 clk,   // Clock signal
  input  logic                 we,    // Write enable
  input  logic [ADDR_W-1:0]    addr,  // Address for read/write
  input  logic [DATA_W-1:0]    din,   // Data input for write
  output logic [DATA_W-1:0]    dout   // Data output for read
);

  // ----------------------------------------------------------
  // Memory array
  // Indexed by 'addr', stores 'DATA_W'-bit words
  // Size = 2^ADDR_W
  // ----------------------------------------------------------
  logic [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

  // ----------------------------------------------------------
  // Synchronous read/write (1R/1W)
  // Write-first behavior: writing an address updates memory
  // before reading it in the same clock cycle
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (we) mem[addr] <= din; // Write data if enabled
    dout <= mem[addr];         // Read current (or newly written) value
  end

endmodule
