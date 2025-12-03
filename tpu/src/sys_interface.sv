`timescale 1ns/1ps
`default_nettype none

module systolic_iface_4x4 #(
  parameter int DW = 16
)(
  input  logic        clk,
  input  logic        rst,

  input  logic        start,         // pulse high for 1+ cycles to begin
  output logic        busy,          // high while interface is loading/running
  output logic        valid,         // all four bottom outputs valid this cycle
  output logic        done,          // 1-cycle pulse when valid first goes high

  //input stream
  input  logic [DW-1:0] data_in_11,
  input  logic [DW-1:0] data_in_21,
  input  logic [DW-1:0] data_in_31,
  input  logic [DW-1:0] data_in_41,

  // results from bottom of array 
  output logic [DW-1:0] data_out_41,
  output logic [DW-1:0] data_out_42,
  output logic [DW-1:0] data_out_43,
  output logic [DW-1:0] data_out_44
);

  // ------------------------------------------------------------
  // Constant 4×4 weight matrix (editable)
  // Row-major: W[row][col], rows top→bottom, cols left→right
  // NOTE on shift-load mapping below.
  // ------------------------------------------------------------
  localparam logic [DW-1:0] W [0:3][0:3] = '{
    '{16'd1, 16'd2, 16'd3, 16'd4},
    '{16'd5, 16'd6, 16'd7, 16'd8},
    '{16'd9, 16'd10,16'd11,16'd12},
    '{16'd13,16'd14,16'd15,16'd16}
  };

  // ------------------------------------------------------------
  // Wires to DUT
  // ------------------------------------------------------------

  logic sys_start_1, sys_start_2, sys_start_3, sys_start_4;

  logic [DW-1:0] sys_weight_in_11, sys_weight_in_12, sys_weight_in_13, sys_weight_in_14;

  logic sys_accept_w_1, sys_accept_w_2, sys_accept_w_3, sys_accept_w_4;

  logic sys_switch_in;

  // Bottom valid signals
  wire  v41, v42, v43, v44;

  logic [DW-1:0] sys_data_in_11, sys_data_in_21, sys_data_in_31, sys_data_in_41;
  assign sys_data_in_11 = data_in_11;
  assign sys_data_in_21 = data_in_21;
  assign sys_data_in_31 = data_in_31;
  assign sys_data_in_41 = data_in_41;

  // SYSTOLIC INSTANTIATION
  systolic dut (
    .clk(clk),
    .rst(rst),

    .sys_data_in_11(sys_data_in_11),
    .sys_data_in_21(sys_data_in_21),
    .sys_data_in_31(sys_data_in_31),
    .sys_data_in_41(sys_data_in_41),

    .sys_start_1(sys_start_1),
    .sys_start_2(sys_start_2),
    .sys_start_3(sys_start_3),
    .sys_start_4(sys_start_4),

    .sys_data_out_41(data_out_41),
    .sys_data_out_42(data_out_42),
    .sys_data_out_43(data_out_43),
    .sys_data_out_44(data_out_44),
    .sys_valid_out_41(v41),
    .sys_valid_out_42(v42),
    .sys_valid_out_43(v43),
    .sys_valid_out_44(v44),

    .sys_weight_in_11(sys_weight_in_11),
    .sys_weight_in_12(sys_weight_in_12),
    .sys_weight_in_13(sys_weight_in_13),
    .sys_weight_in_14(sys_weight_in_14),

    .sys_accept_w_1(sys_accept_w_1),
    .sys_accept_w_2(sys_accept_w_2),
    .sys_accept_w_3(sys_accept_w_3),
    .sys_accept_w_4(sys_accept_w_4),

    .sys_switch_in(sys_switch_in),

    .ub_rd_col_size_in('0),
    .ub_rd_col_size_valid_in(1'b0)
  );

  // ------------------------------------------------------------
  // FSM to (1) load weights, (2) switch, (3) launch rows, (4) wait done
  //
  // Assumptions (matches your column accept semantics):
  //  • Each column is a 4-stage shift path top→bottom. When sys_accept_w_j=1,
  //    the value on sys_weight_in_1j advances down one PE per cycle.
  //  • To place W[row][col] into row=row, col=col, we clock in one value per cycle
  //    for 4 cycles (row=0..3). After 4 cycles the column holds those 4 values.
  //  • After LOAD, we pulse sys_switch_in for 1 cycle so each PE copies its
  //    shadow weight into the active register.
  //  • Then we strobe starts top→bottom one-per-cycle to create the diagonal wave.
  //
  // Timing for N=4:
  //   LOAD: 4 cycles with all sys_accept_w_* = 1 (one value per column per cycle)
  //   SWITCH: 1 cycle pulse
  //   LAUNCH: 4 cycles (start row1..row4)
  //   RUN/FLUSH until bottom-right valid appears; we detect bottom-row all-valid
  // ------------------------------------------------------------

  typedef enum logic [2:0] {
    S_IDLE,
    S_LOAD,      
    S_SWITCH,     
    S_LAUNCH,     
    S_WAIT_VALID, 
    S_DONE        
  } state_e;

  state_e state, state_n;

  logic [2:0] cnt;             
  logic      valid_all;     
  assign     valid_all = v41 & v42 & v43 & v44;
  assign     valid     = valid_all;

  // Default drives
  always_comb begin
    // defaults
    sys_accept_w_1 = 1'b0;
    sys_accept_w_2 = 1'b0;
    sys_accept_w_3 = 1'b0;
    sys_accept_w_4 = 1'b0;
    sys_switch_in  = 1'b0;

    sys_start_1    = 1'b0;
    sys_start_2    = 1'b0;
    sys_start_3    = 1'b0;
    sys_start_4    = 1'b0;

    sys_weight_in_11 = W[cnt][0];
    sys_weight_in_12 = W[cnt][1];
    sys_weight_in_13 = W[cnt][2];
    sys_weight_in_14 = W[cnt][3];

    busy = 1'b1;
    done = 1'b0;

    unique case (state)
      S_IDLE: begin
        busy = 1'b0;
      end

      S_LOAD: begin
        sys_accept_w_1 = 1'b1;
        sys_accept_w_2 = 1'b1;
        sys_accept_w_3 = 1'b1;
        sys_accept_w_4 = 1'b1;
      end

      S_SWITCH: begin
        sys_switch_in = 1'b1;
      end

      S_LAUNCH: begin
        sys_start_1 = (cnt == 3'd0);
        sys_start_2 = (cnt == 3'd1);
        sys_start_3 = (cnt == 3'd2);
        sys_start_4 = (cnt == 3'd3);
      end

      S_WAIT_VALID: begin
      end

      S_DONE: begin
        done = 1'b1; 
      end

      default: ;
    endcase
  end

//Control logic 
  always_comb begin
    state_n = state;
    unique case (state)
      S_IDLE:       state_n = start ? S_LOAD : S_IDLE;

      S_LOAD:       state_n = (cnt == 3'd3) ? S_SWITCH : S_LOAD;

      S_SWITCH:     state_n = S_LAUNCH;

      S_LAUNCH:     state_n = (cnt == 3'd3) ? S_WAIT_VALID : S_LAUNCH;

      S_WAIT_VALID: state_n = valid_all ? S_DONE : S_WAIT_VALID;

      S_DONE:       state_n = S_IDLE;

      default:      state_n = S_IDLE;
    endcase
  end

  // Counter logic
  logic cnt_clr, cnt_en;
  always_comb begin
    cnt_clr = 1'b0;
    cnt_en  = 1'b0;
    unique case (state)
      S_LOAD:   cnt_en  = 1'b1;              
      S_LAUNCH: cnt_en  = 1'b1;              
      default:  cnt_clr = 1'b1;
    endcase
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= S_IDLE;
      cnt   <= '0;
    end else begin
      state <= state_n;
      if (cnt_clr)    cnt <= '0;
      else if (cnt_en) cnt <= cnt + 3'd1;
    end
  end

endmodule
