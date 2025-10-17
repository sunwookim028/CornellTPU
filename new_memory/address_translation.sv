`timescale 1ns/1ps

module AddressTranslation #(
  parameter int ADDR_W = ADDR_WIDTH,
  parameter int NB     = NUM_BANKS
)(
  input  logic [ADDR_W-1:0]          global_addr,
  output logic [BANK_BITS-1:0]       bank_sel,
  output logic [ADDR_W-1:0]          local_addr
);
  // Lower BANK_BITS choose bank; remaining bits index within the bank.
  assign bank_sel   = global_addr[BANK_BITS-1:0];
  assign local_addr = global_addr >> BANK_BITS;
endmodule
