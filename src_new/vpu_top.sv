// new VPU top-level module with standard interfacing
// VPU (opcode, addrA, addrB, addrC, addrconstant, M)
// combine addrB and addrconstant; i.e., use same comm channel
// opcode bits = 4
// M : fixed

module vpu_top (
  parameter int DATA_W = 32,
  parameter int ADDR_W = 16,
  parameter int OP_W = 4,
  parameter int INST_ADDR = 5,
  parameter int M = 4
)(
  input logic clk,
  input logic rst,

  input logic [31:0] inst,
  input logic mem_rdy, // memory rdy to accept addr
  input logic mem_valid, // memory has sent valid data

  output logic [ADDR_W-1:0] addr_a, // instruction decode addr 
  output logic [ADDR_W-1:0] addr_b,
  output logic [ADDR_W-1:0] addr_c,

  input logic [DATA_W-1:0] data_a,
  input logic [DATA_W-1:0] data_b,
  output logic [DATA_W-1:0] data_c,
);

// instruction decode -------------------
logic [INST_ADDR-1:0] inst_addr_a, inst_addr_b, inst_addr_c, inst_addr_const;
logic [OP_W-1:0] opcode;
typedef struct packed {
  logic [INST_ADDR-1:0] const_addr; 
  logic [INST_ADDR-1:0] c_addr;
  logic [INST_ADDR-1:0] b_addr;
  logic [INST_ADDR-1:0] a_addr;
  logic [OP_W-1:0]      opcode;
} inst_t;

inst_t f = inst;

assign opcode = f.opcode;
assign inst_addr_a = f.a_addr;
assign inst_addr_b = f.b_addr;
assign inst_addr_c = f.c_addr;
assign inst_addr_const = f.const_addr;
//---------------------------------------

// zero-extending addr from inst decode
logic [ADDR_W-1:0] addr_a_ext, addr_b_ext, addr_c_ext, addr_const_ext;
assign addr_a_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_a};
assign addr_b_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_b};
assign addr_c_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_c};
assign addr_const_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_const};

// FSM states
localparam IDLE = 3'd0;
localparam DATA_A = 3'd1;
localparam DATA_B = 3'd2;
localparam DATA_CONST = 3'd3;
localparam PROCESSING = 3'd4;
localparam DATA_C = 3'd5;

logic [2:0] current_state, next_state;

always_ff @(posedge clk) begin
  if (rst) begin
    current_state <= IDLE;
  end else begin
    current_state <= next_state;
  end
end

// local var for data
logic [DATA_W-1:0] a_val, b_val, c_val, const_val;
logic vpu_op_start;

always_comb begin
  next_state = current_state;
  vpu_op_start = 1'b0;
  count = 3'd0;
  case (current_state)
  IDLE: begin
    if(mem_rdy) begin
      next_state = DATA_A;
    end
  end

  DATA_A: begin
    addr_a = addr_a_ext;
    if(mem_valid) begin
      a_val = data_a;
      next_state = DATA_B;
    end
  end

  DATA_B: begin
    addr_b = addr_b_ext;
    if(mem_valid) begin
      b_val = data_b;
      next_state = DATA_CONST;
    end
  end

  DATA_CONST: begin
    addr_b = addr_const_ext;
    if(mem_valid) begin
      const_val = data_b;
      next_state = PROCESSING;
    end
  end

  PROCESSING: begin
    vpu_op_start = 1'b1;
    next_state = DATA_C;
  end

  DATA_C: begin
    if(mem_rdy) begin
      addr_c = addr_c_ext;
      data_c = c_val;
      next_state = IDLE;
    end
  end
  endcase
end

logic [DATA_W-1:0] op_1_result, op_2_result;
vpu_op#(DATA_W,OP_W) op_1
(
  .start(vpu_op_start),
  .operand0(a_val),
  .operand1(b_val),
  .opcode(opcode),
  .output(op_1_result),
);

vpu_op#(DATA_W,OP_W) op_2
(
  .start(vpu_op_start),
  .operand0(a_val),
  .operand1(const_val),
  .opcode(opcode),
  .output(op_2_result)
);

/* 
if the operation is done with the constant, depending on opcode, then accept 
result from vpu_op using operand1 = const_val
*/
assign c_val = (opcode == 2) ? op_2_result : op_1_result;

endmodule