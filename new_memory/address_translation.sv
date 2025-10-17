`timescale 1ns/1ps

module AddressTranslation #(
  parameter int ADDR_W = 10,  // Width of the full global address
  parameter int NB     = 4   // Number of memory banks
)(
  input  logic [ADDR_W-1:0]    global_addr,   // Incoming global address
  output logic [2-1:0] bank_sel,      // Which bank to access
  output logic [ADDR_W-1:0]    local_addr     // Address inside that bank
);

  // ------------------------------------------------------------
  // Address decoding scheme:
  // - Lower BANK_BITS of the global address select the memory bank
  // - Remaining upper bits form the local (intra-bank) address
  // ------------------------------------------------------------

  // Extract bank index from lower bits
  assign bank_sel   = global_addr[2-1:0];

  // Shift right by BANK_BITS to remove bank bits -> local address
  assign local_addr = global_addr >> 2;

endmodule
