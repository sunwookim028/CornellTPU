module vpu_top #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 13,
  parameter int OP_W = 4,
  parameter int INST_ADDR = 5,
  parameter int M = 4
)(
  input logic clk,
  input logic rst,

  input logic [31:0] inst,
  input logic mem_rdy,
  input logic mem_read_en,
  input logic mem_write_en,

  output logic [ADDR_W-1:0] addr_a,
  output logic [ADDR_W-1:0] addr_b,
  output logic [ADDR_W-1:0] addr_c,

  input logic [DATA_W-1:0] data_a,
  input logic [DATA_W-1:0] data_b,
  output logic [DATA_W-1:0] data_c,
  output logic done
);

// instruction decode -------------------
logic [INST_ADDR-1:0] inst_addr_a, inst_addr_b, inst_addr_c, inst_addr_const;
logic [OP_W-1:0] opcode;

typedef struct packed {
  logic [7:0] reserved;
  logic [INST_ADDR-1:0] const_addr; 
  logic [INST_ADDR-1:0] c_addr;
  logic [INST_ADDR-1:0] b_addr;
  logic [INST_ADDR-1:0] a_addr;
  logic [OP_W-1:0]      opcode;
} inst_t;

inst_t f;
assign f = inst; 

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

// Mem latency counter
logic [1:0] mem_cnt; 
logic       mem_cnt_en; 
logic       mem_cnt_done;

always_ff @(posedge clk) begin
  if (rst) begin
    mem_cnt <= 2'd0;
  end else if (mem_cnt_en) begin
    if(mem_cnt != 2'd0)
    mem_cnt <= mem_cnt - 1; 
  end
end

assign mem_cnt_done = (mem_cnt == 2'd0);


// FSM states
typedef enum logic [3:0] {
  IDLE = 4'd0,
  DATA_A_REQ = 4'd1,
  DATA_A_WAIT = 4'd2,
  DATA_B_REQ = 4'd3,
  DATA_B_WAIT = 4'd4,
  DATA_CONST_REQ = 4'd5,
  DATA_CONST_WAIT = 4'd6,
  PROCESSING = 4'd7,
  DATA_C_REQ = 4'd8,
  DATA_C_WAIT = 4'd9
} state_t;

state_t current_state, next_state;

logic [DATA_W-1:0] a_val, b_val;
logic [DATA_W-1:0] c_val;
logic use_constant;
logic data_a_valid, data_b_valid;

assign use_constant = (inst_addr_b == 0 && inst_addr_const != 0);

logic data_a_captured, data_b_captured;

always_ff @(posedge clk) begin
  if (rst) begin
    current_state <= IDLE;
    a_val <= '0;
    b_val <= '0;
    c_val <= '0;
    data_a_captured <= 1'b0;
    data_b_captured <= 1'b0;
  end else begin
    current_state <= next_state; 
    end 

    if (mem_read_en) begin
      if (current_state == DATA_A_WAIT && mem_cnt_done) begin
        a_val <= data_a;
        data_a_captured <= 1'b1;
        data_a_valid <= 1'b1;
      end
      if ((current_state == DATA_B_WAIT || current_state == DATA_CONST_WAIT) && mem_cnt_done) begin
        b_val <= data_b;
        data_b_captured <= 1'b1;
        data_b_valid <= 1'b1;
      end
    end
    
    if (current_state == IDLE) begin
      data_a_captured <= 1'b0;
      data_b_captured <= 1'b0;
      data_a_valid <= 1'b0;
      data_b_valid <= 1'b0;
      c_val <= '0;
    end
    if (current_state == PROCESSING) begin
      c_val <= op_result;
    end
  end

logic vpu_op_start;
logic [DATA_W-1:0] op_result;
logic comp_done;

always_comb begin
  next_state = current_state;
  vpu_op_start = 1'b0;
  
  addr_a = '0;
  addr_b = '0;
  addr_c = '0;
  data_c = c_val; 
  mem_cnt_en = 1'b0;
  comp_done = 1'b0;
  
  case (current_state)
    IDLE: begin
      if (mem_rdy) begin
        next_state = DATA_A_REQ;
      end
    end
    
    DATA_A_REQ: begin
      addr_a = addr_a_ext;
      mem_cnt = 1'b1;
      next_state = DATA_A_WAIT;
    end

    DATA_A_WAIT: begin
      addr_a = addr_a_ext;
      mem_cnt_en = 1'b1;
      if (mem_cnt_done) begin
        if (opcode == 4'd2) begin
        next_state = PROCESSING;
        end else if (use_constant) begin
        next_state = DATA_CONST_REQ;
        end else begin
        next_state = DATA_B_REQ;
        end
      end
    end
    
    DATA_B_REQ: begin
      addr_b = addr_b_ext;
      mem_cnt = 1'b1;
      next_state = DATA_B_WAIT;
    end

    DATA_B_WAIT: begin
      addr_b = addr_b_ext;
      mem_cnt_en = 1'b1;
      if (mem_cnt_done) begin
        next_state = PROCESSING;
      end
    end
    
    DATA_CONST_REQ: begin
      addr_b = addr_const_ext;
      mem_cnt_en = 1'b1;
      next_state = DATA_CONST_WAIT;
    end

    DATA_CONST_WAIT: begin
      addr_b = addr_const_ext;
      mem_cnt_en = 1'b1;
      if (mem_cnt_done) begin
        next_state = PROCESSING;
      end
    end
    
    PROCESSING: begin
      vpu_op_start = 1'b1;
      next_state = DATA_C_REQ;
    end
    
    DATA_C_REQ: begin
      addr_c = addr_c_ext;
      mem_cnt = 1'b1;
      next_state = DATA_C_WAIT;
    end

    DATA_C_WAIT: begin
      addr_c = addr_c_ext;
      mem_cnt_en = 1'b1;
      if (mem_cnt_done) begin
        comp_done = 1'b1;
        next_state = IDLE;
      end
    end
    
    default: begin
      next_state = IDLE;
    end
  endcase
end

vpu_op #(
  .DATA_W(DATA_W),
  .OP_W(OP_W)
) op_1 (
  .start(vpu_op_start),
  .operand0(a_val),
  .operand1(b_val),
  .opcode(opcode),
  .result_out(op_result)
);

assign done = comp_done;

endmodule