// module vpu_top #(
//   parameter int DATA_W = 32,
//   parameter int ADDR_W = 13,
//   parameter int OP_W = 4,
//   parameter int INST_ADDR = 5,
//   parameter int M = 4
// )(
//   input logic clk,
//   input logic rst,

//   input logic [31:0] inst[M],
//   input logic mem_rdy[M],
//   input logic mem_read_en[M],
//   input logic mem_write_en[M],

//   output logic [ADDR_W-1:0] addr_a[M]
//   output logic [ADDR_W-1:0] addr_b[M]
//   output logic [ADDR_W-1:0] addr_c[M]

//   input logic [DATA_W-1:0] data_a[M],
//   input logic [DATA_W-1:0] data_b[M],
//   output logic [DATA_W-1:0] data_c[M],

//   output logic done
// );



// endmodule