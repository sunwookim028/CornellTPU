module vpu_top #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 13,
  parameter int OP_W = 10,
  parameter int INST_ADDR = 5,
  parameter int M = 4
)(
  input logic clk,
  input logic rst_n,

  input logic [12:0] inst_addr_a,
  input logic [12:0] inst_addr_b,
  input logic [12:0] inst_addr_c,
  input logic [12:0] inst_addr_const,
  input logic [9:0] opcode,
  input logic start,

  output logic [ADDR_W-1:0] bram_addr,
  output logic [DATA_W-1:0] bram_din,
  input logic [DATA_W-1:0] bram_dout,
  output logic bram_en,
  output logic bram_we,
  output logic done
);

// instruction decode -------------------
//logic [INST_ADDR-1:0] inst_addr_a, inst_addr_b, inst_addr_c, inst_addr_const;
//logic [OP_W-1:0] opcode;
//logic [DATA_W-1:0] data_a, data_b;
 logic use_constant;
 logic [DATA_W-1:0] op_result;

//typedef struct packed {
//  logic [7:0] reserved;
//  logic [INST_ADDR-1:0] const_addr; 
//  logic [INST_ADDR-1:0] c_addr;
//  logic [INST_ADDR-1:0] b_addr;
//  logic [INST_ADDR-1:0] a_addr;
//  logic [OP_W-1:0]      opcode;
//} inst_t;

//inst_t f;
//assign f = inst; 

//assign opcode = f.opcode;
//assign inst_addr_a = f.a_addr;
//assign inst_addr_b = f.b_addr;
//assign inst_addr_c = f.c_addr;
//assign inst_addr_const = f.const_addr;
//---------------------------------------

// zero-extending addr from inst decode
//logic [ADDR_W-1:0] addr_a_ext, addr_b_ext, addr_c_ext, addr_const_ext;
//assign addr_a_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_a};
//assign addr_b_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_b};
//assign addr_c_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_c};
//assign addr_const_ext = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_const};
 assign use_constant = (inst_addr_b == 0 && inst_addr_const != 0);


// FSM state definitions
    typedef enum logic [4:0] {
        IDLE,
        READ_A,
        READ_B,
        WAIT_1,
        WAIT_2,
        WAIT_3,
        WRITE_OUT,
        DONE
    } state_t;

state_t state = IDLE;

logic [DATA_W-1:0] a_val, b_val;
logic [DATA_W-1:0] c_val;

// FSM behavior
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            done         <= 1'b0;
            bram_en    <= 1'b0;
            bram_we    <= 1'b0;
            bram_addr  <= '0;
            bram_din   <= '0;
            a_val       <= '0;
            b_val       <= '0;
        end else begin
            done      <= 1'b0;
            bram_we <= 1'b0;

            case (state)
                // Wait for start signal
                IDLE: begin
                    if (start) begin
                        state <= READ_A;
                    end
                end

                // Read A[i] from BRAM
                READ_A: begin
                    bram_en   <= 1'b1;
                    bram_we   <= 1'b0;
                    bram_addr <= inst_addr_a;
                    state       <= READ_B;
                end
                

                // Read B[i] from BRAM
                READ_B: begin
                    bram_en   <= 1'b1;
                    bram_we   <= 1'b0;
                    bram_addr <= (use_constant) ? inst_addr_const : inst_addr_b;
                    state       <= WAIT_1;
                end
                
                WAIT_1: begin
                    state <= WAIT_2;
                end
                
                WAIT_2: begin
                    state <= WAIT_3;
                    a_val <= bram_dout;
                end
                
                WAIT_3: begin
                    state <= WRITE_OUT;
                    b_val <= bram_dout;
                end

                // Write SUM to C[i] in BRAM
                WRITE_OUT: begin
                    bram_en   <= 1'b1;
                    bram_we   <= 1'b1;
                    bram_addr <= inst_addr_c;
                    bram_din  <= op_result;

                    
                    state <= DONE;
                    end

                // Raise done and return to idle
                DONE: begin
                    done  <= 1'b1;
                    bram_en <= 1'b0;
                    state <= IDLE;
                end
            endcase
        end
end

vpu_op #(
  .DATA_W(DATA_W),
  .OP_W(OP_W)
) op_1 (
  .start(start),
  .operand0(a_val),
  .operand1(b_val),
  .opcode(opcode),
  .result_out(op_result)
);


endmodule