`timescale 1ns/1ps

module MemoryBank #(
  parameter int DATA_W = DATA_WIDTH,
  parameter int ADDR_W = ADDR_WIDTH
)(
  input  logic                 clk,
  input  logic                 we,
  input  logic [ADDR_W-1:0]    addr,
  input  logic [DATA_W-1:0]    din,
  output logic [DATA_W-1:0]    dout
);
  // Simple synchronous 1R/1W (write-first) BRAM model
  logic [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

  always_ff @(posedge clk) begin
    if (we) mem[addr] <= din;
    dout <= mem[addr];
  end
endmodule
