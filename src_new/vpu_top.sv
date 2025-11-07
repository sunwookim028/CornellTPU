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
  input logic mem_read_en, // memory ready to send data to vpu
  input logic mem_write_en, // memory ready to accept data from vpu

  output logic [ADDR_W-1:0] addr_a, // instruction decode addr 
  output logic [ADDR_W-1:0] addr_b,
  output logic [ADDR_W-1:0] addr_c,

  input logic [DATA_W-1:0] data_a,
  input logic [DATA_W-1:0] data_b,
  output logic [DATA_W-1:0] data_c
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

inst_t f;
assign f = inst;  // Fixed struct assignment

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
typedef enum logic [2:0] {
  IDLE = 3'd0,
  DATA_A = 3'd1,
  DATA_B = 3'd2,
  DATA_CONST = 3'd3,
  PROCESSING = 3'd4,
  DATA_C = 3'd5
} state_t;

state_t current_state, next_state;


logic [DATA_W-1:0] a_val, b_val, const_val;
always_ff @(posedge clk) begin
  if (rst) begin
    current_state <= IDLE;
    a_val <= '0;
    b_val <= '0;
    const_val <= '0;
  end else begin
    current_state <= next_state;
    
    // registering inputs between states
    if (current_state == DATA_A && mem_read_en) begin
      a_val <= data_a;
    end
    if (current_state == DATA_B && mem_read_en) begin
      b_val <= data_b;
    end
    if (current_state == DATA_CONST && mem_write_en) begin
      const_val <= data_b;
    end
  end
end

// control signals
logic vpu_op_start;
logic [DATA_W-1:0] op_result;

always_comb begin
  next_state = current_state;
  vpu_op_start = 1'b0;
  
  addr_a = '0;
  addr_b = '0;
  addr_c = '0;
  data_c = '0;
  
  case (current_state)
    IDLE: begin
      if (mem_rdy) begin
        next_state = DATA_A;
      end
    end
    
    DATA_A: begin
      addr_a = addr_a_ext;
      if (mem_read_en) begin
        next_state = DATA_B;
      end
    end
    
    DATA_B: begin
      addr_b = addr_b_ext;
      if (mem_read_en) begin
        next_state = DATA_CONST;
      end
    end
    
    DATA_CONST: begin
      addr_b = addr_const_ext;
      if (mem_read_en) begin
        next_state = PROCESSING;
      end
    end
    
    PROCESSING: begin
      vpu_op_start = 1'b1;
      next_state = DATA_C;
    end
    
    DATA_C: begin
      if (mem_write_en) begin
        addr_c = addr_c_ext;
        data_c = op_result;
        next_state = IDLE;
      end
    end
    
    default: begin
      next_state = IDLE;
    end
  endcase
end

logic [DATA_W-1:0] op_1_result, op_2_result;

vpu_op #(
  .DATA_W(DATA_W),
  .OP_W(OP_W)
) op_1 (
  .start(vpu_op_start),
  .operand0(a_val),
  .operand1(b_val),
  .opcode(opcode),
  .result_out(op_1_result)
);

vpu_op #(
  .DATA_W(DATA_W),
  .OP_W(OP_W)
) op_2 (
  .start(vpu_op_start),
  .operand0(a_val),
  .operand1(const_val),
  .opcode(opcode),
  .result_out(op_2_result)
);

// result selection based on opcode
assign op_result = (opcode == 4'd2) ? op_2_result : op_1_result;

endmodule