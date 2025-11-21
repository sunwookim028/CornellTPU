module vpu_top_multi #(
  parameter int DATA_W     = 32,
  parameter int ADDR_W     = 13,
  parameter int OP_W       = 4,
  parameter int INST_ADDR  = 5,
  parameter int M          = 4,

  // Memory hit latency model (counter width and load value)
  parameter int MEM_LAT_W  = 4,
  parameter int MEM_HIT_LAT= 1
)(
  input  logic                         clk,
  input  logic                         rst,

  // Per-lane instruction + simple handshake
  input  logic [31:0]                  inst         [M],
  input  logic                         mem_rdy      [M],
  input  logic                         mem_read_en  [M],
  input  logic                         mem_write_en [M], // (kept for parity; not used in this FSM)

  // Per-lane memory interface addresses
  output logic [ADDR_W-1:0]            addr_a       [M],
  output logic [ADDR_W-1:0]            addr_b       [M],
  output logic [ADDR_W-1:0]            addr_c       [M],

  // Per-lane memory data
  input  logic [DATA_W-1:0]            data_a       [M],
  input  logic [DATA_W-1:0]            data_b       [M],
  output logic [DATA_W-1:0]            data_c       [M],

  // Aggregate completion: all lanes done in their current op
  output logic                         done
);

  // -------- Instruction decode layout (must sum to 32b) --------
  typedef struct packed {
    logic [7:0]              reserved;
    logic [INST_ADDR-1:0]    const_addr;
    logic [INST_ADDR-1:0]    c_addr;
    logic [INST_ADDR-1:0]    b_addr;
    logic [INST_ADDR-1:0]    a_addr;
    logic [OP_W-1:0]         opcode;
  } inst_t;

  // -------- FSM states --------
  typedef enum logic [3:0] {
    IDLE           = 4'd0,
    DATA_A_REQ     = 4'd1,
    DATA_A_WAIT    = 4'd2,
    DATA_B_REQ     = 4'd3,
    DATA_B_WAIT    = 4'd4,
    DATA_CONST_REQ = 4'd5,
    DATA_CONST_WAIT= 4'd6,
    PROCESSING     = 4'd7,
    DATA_C_REQ     = 4'd8,
    DATA_C_WAIT    = 4'd9
  } state_t;

  // -------- Per-lane storage --------
  inst_t                      f               [M];

  // Decoded fields
  logic [OP_W-1:0]            opcode          [M];
  logic [INST_ADDR-1:0]       inst_addr_a     [M];
  logic [INST_ADDR-1:0]       inst_addr_b     [M];
  logic [INST_ADDR-1:0]       inst_addr_c     [M];
  logic [INST_ADDR-1:0]       inst_addr_const [M];

  // Zero-extended addresses
  logic [ADDR_W-1:0]          addr_a_ext      [M];
  logic [ADDR_W-1:0]          addr_b_ext      [M];
  logic [ADDR_W-1:0]          addr_c_ext      [M];
  logic [ADDR_W-1:0]          addr_const_ext  [M];

  // Per-lane FSM, counters, and datapath regs
  state_t                     current_state   [M];
  state_t                     next_state      [M];

  logic [DATA_W-1:0]          a_val           [M];
  logic [DATA_W-1:0]          b_val           [M];
  logic [DATA_W-1:0]          c_val           [M];

  logic                       use_constant    [M];

  logic [MEM_LAT_W-1:0]       mem_cnt         [M];
  logic                       mem_cnt_en      [M];
  logic                       mem_cnt_load    [M];
  logic                       mem_cnt_done    [M];

  // Operation block control/result per lane
  logic                       vpu_op_start    [M];
  logic [DATA_W-1:0]          op_result       [M];
  logic                       comp_done       [M];

  // Assign decoded struct and fields
  genvar gi;
  generate
    for (gi = 0; gi < M; gi++) begin : g_decode
      assign f[gi]              = inst[gi];
      assign opcode[gi]         = f[gi].opcode;
      assign inst_addr_a[gi]    = f[gi].a_addr;
      assign inst_addr_b[gi]    = f[gi].b_addr;
      assign inst_addr_c[gi]    = f[gi].c_addr;
      assign inst_addr_const[gi]= f[gi].const_addr;

      assign addr_a_ext[gi]     = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_a[gi]};
      assign addr_b_ext[gi]     = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_b[gi]};
      assign addr_c_ext[gi]     = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_c[gi]};
      assign addr_const_ext[gi] = {{(ADDR_W-INST_ADDR){1'b0}}, inst_addr_const[gi]};
      assign use_constant[gi]   = (inst_addr_b[gi] == '0) && (inst_addr_const[gi] != '0);
    end
  endgenerate

  // Aggregate done = all lanes completed their current transaction
  assign done = &comp_done;

  // -------- Per-lane FSM + datapath --------
  generate
    for (gi = 0; gi < M; gi++) begin : g_lane

      // Sequential: state, counters, capture operands/results
      always_ff @(posedge clk) begin
        if (rst) begin
          current_state[gi] <= IDLE;
          a_val[gi]         <= '0;
          b_val[gi]         <= '0;
          c_val[gi]         <= '0;
          mem_cnt[gi]       <= '0;
        end
        else begin
          current_state[gi] <= next_state[gi];

          // Memory latency counter
          if (mem_cnt_load[gi]) begin
            mem_cnt[gi] <= MEM_HIT_LAT[MEM_LAT_W-1:0];
          end
          else if (mem_cnt_en[gi] && (mem_cnt[gi] != '0)) begin
            mem_cnt[gi] <= mem_cnt[gi] - {{(MEM_LAT_W-1){1'b0}}, 1'b1};
          end

          // Capture A/B when wait finishes and mem_read_en asserted
          if (mem_read_en[gi]) begin
            if (current_state[gi] == DATA_A_WAIT && mem_cnt_done[gi]) begin
              a_val[gi] <= data_a[gi];
            end
            if ((current_state[gi] == DATA_B_WAIT || current_state[gi] == DATA_CONST_WAIT) && mem_cnt_done[gi]) begin
              b_val[gi] <= data_b[gi];
            end
          end

          // Latch result during PROCESSING
          if (current_state[gi] == PROCESSING) begin
            c_val[gi] <= op_result[gi];
          end

          // Clear per-op registers when returning to IDLE
          if (current_state[gi] == DATA_C_WAIT && mem_cnt_done[gi]) begin
            // write completed; next cycle we’ll go IDLE
          end
          if (next_state[gi] == IDLE) begin
            c_val[gi] <= '0;
          end
        end
      end

      assign mem_cnt_done[gi] = (mem_cnt[gi] == '0);

      // Combinational: default drives and next-state logic
      always_comb begin
        next_state[gi]   = current_state[gi];

        vpu_op_start[gi] = 1'b0;
        comp_done[gi]    = 1'b0;

        // Default outputs
        addr_a[gi]       = '0;
        addr_b[gi]       = '0;
        addr_c[gi]       = '0;
        data_c[gi]       = c_val[gi];

        mem_cnt_en[gi]   = 1'b0;
        mem_cnt_load[gi] = 1'b0;

        unique case (current_state[gi])

          IDLE: begin
            if (mem_rdy[gi]) begin
              next_state[gi] = DATA_A_REQ;
            end
          end

          DATA_A_REQ: begin
            addr_a[gi]       = addr_a_ext[gi];
            mem_cnt_load[gi] = 1'b1;
            next_state[gi]   = DATA_A_WAIT;
          end

          DATA_A_WAIT: begin
            addr_a[gi]     = addr_a_ext[gi];
            mem_cnt_en[gi] = 1'b1;
            if (mem_cnt_done[gi]) begin
              if (opcode[gi] == 4'd2) begin
                next_state[gi] = PROCESSING;         // unary op (just A)
              end
              else if (use_constant[gi]) begin
                next_state[gi] = DATA_CONST_REQ;     // B from const space
              end
              else begin
                next_state[gi] = DATA_B_REQ;         // B from B addr
              end
            end
          end

          DATA_B_REQ: begin
            addr_b[gi]       = addr_b_ext[gi];
            mem_cnt_load[gi] = 1'b1;
            next_state[gi]   = DATA_B_WAIT;
          end

          DATA_B_WAIT: begin
            addr_b[gi]     = addr_b_ext[gi];
            mem_cnt_en[gi] = 1'b1;
            if (mem_cnt_done[gi]) begin
              next_state[gi] = PROCESSING;
            end
          end

          DATA_CONST_REQ: begin
            addr_b[gi]       = addr_const_ext[gi];
            mem_cnt_load[gi] = 1'b1;
            next_state[gi]   = DATA_CONST_WAIT;
          end

          DATA_CONST_WAIT: begin
            addr_b[gi]     = addr_const_ext[gi];
            mem_cnt_en[gi] = 1'b1;
            if (mem_cnt_done[gi]) begin
              next_state[gi] = PROCESSING;
            end
          end

          PROCESSING: begin
            vpu_op_start[gi] = 1'b1;
            next_state[gi]   = DATA_C_REQ;
          end

          DATA_C_REQ: begin
            addr_c[gi]       = addr_c_ext[gi];
            mem_cnt_load[gi] = 1'b1;
            next_state[gi]   = DATA_C_WAIT;
          end

          DATA_C_WAIT: begin
            addr_c[gi]     = addr_c_ext[gi];
            mem_cnt_en[gi] = 1'b1;
            if (mem_cnt_done[gi]) begin
              comp_done[gi]  = 1'b1;
              next_state[gi] = IDLE;
            end
          end

          default: begin
            next_state[gi] = IDLE;
          end
        endcase
      end

      // Per-lane operation unit
      vpu_op #(
        .DATA_W (DATA_W),
        .OP_W   (OP_W )
      ) op_i (
        .start     ( vpu_op_start[gi] ),
        .operand0  ( a_val[gi]        ),
        .operand1  ( b_val[gi]        ),
        .opcode    ( opcode[gi]       ),
        .result_out( op_result[gi]    )
      );

    end // g_lane
  endgenerate

endmodule

