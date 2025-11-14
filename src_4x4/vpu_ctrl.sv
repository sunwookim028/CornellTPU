// VPU controller unit for communication control b/w VPU and UB
`timescale 1ns/1ps
`default_nettype none

module vpu_ctrl#(
  parameter int DATA_W = 16,
  parameter int ADDR_W = 10,
  parameter int SIZE   = 8   // single size knob; rows=B and lanes=D_OUT
)(
  input  logic clk,
  input  logic rst,

  // UB Interface
  input  logic                  ub_req_rdy,   // UB ready to accept request for data
  output logic                  ub_req_val,   // VPU ctrl sending valid addr request
  
  // Address outputs to UB
  output logic [ADDR_W-1:0]     addr_Z_prime, // Systolic array data address (Z')
  output logic [ADDR_W-1:0]     addr_b,       // Bias data address  
  output logic [ADDR_W-1:0]     addr_Z,       // VPU output data address

  // Data interfaces with UB (SIZE banks x VEC_W bits)
  input  logic [DATA_W*SIZE-1:0] data_Z_prime [0:SIZE-1], // SIZE vectors, each SIZE*DATA_W
  input  logic [DATA_W*SIZE-1:0] data_b,                  // Bias vector (SIZE scalars)
  output logic [DATA_W*SIZE-1:0] data_Z       [0:SIZE-1], // Outputs back to UB

  // VPU Interface: SIZE parallel lanes
  output logic signed [DATA_W-1:0] vpu_data_in   [SIZE],
  output logic                     vpu_valid_in  [SIZE],

  // Bias inputs to VPU - SIZE scalars (one per output neuron)
  output logic signed [DATA_W-1:0] bias_scalar_in [SIZE],

  // Learning rate/leak factor (shared)
  output logic signed [DATA_W-1:0] lr_leak_factor_in,

  // VPU outputs to be stored in UB
  input  logic signed [DATA_W-1:0] vpu_data_out  [SIZE],
  input  logic                     vpu_valid_out [SIZE],

  // Control
  input  logic [3:0]               vpu_data_pathway,    // Operation mode control
  output logic                     vpu_busy             // VPU controller busy signal
);

  localparam int VEC_W = DATA_W*SIZE;

  // States
  localparam IDLE            = 3'd0;
  localparam REQUEST_Z_PRIME = 3'd1;
  localparam WAIT_Z_PRIME    = 3'd2;
  localparam REQUEST_BIAS    = 3'd3;
  localparam WAIT_BIAS       = 3'd4;
  localparam PROCESSING      = 3'd5;
  localparam WRITE_Z         = 3'd6;

  logic [2:0] current_state, next_state;

  // Address counters
  logic [ADDR_W-1:0] Z_prime_addr_ctr;
  logic [ADDR_W-1:0] bias_addr_ctr; 
  logic [ADDR_W-1:0] Z_out_addr_ctr;

  // Vector processing counters
  logic [$clog2(SIZE)-1:0] vector_ctr;   // 0..SIZE-1 for SIZE vectors per batch
  logic [$clog2(SIZE)-1:0] element_ctr;  // 0..SIZE-1 for SIZE elems per vector
  
  // Data buffers
  logic [VEC_W-1:0] Z_prime_buffer [0:SIZE-1];  // Store all SIZE vectors
  logic [VEC_W-1:0] bias_buffer;                // Store bias vector
  logic [VEC_W-1:0] Z_out_buffer [0:SIZE-1];    // Store output vectors

  // Control flags
  logic bias_loaded;
  logic data_loaded;

  // Pipeline delay tracking
  logic [$clog2(2*SIZE+2)-1:0] pipeline_delay_ctr; // generous width
  logic [1:0]                  mem_delay_ctr;
  logic [SIZE-1:0]             vector_processed;

  // All vectors processed
  logic all_vectors_processed;
  assign all_vectors_processed = &vector_processed;

  logic all_vectors_processed_flag;

  // State reg
  always_ff @(posedge clk or posedge rst) begin
    if (rst) current_state <= IDLE;
    else     current_state <= next_state;
  end

  // Next state
  always_comb begin
    next_state = current_state;
    unique case (current_state)
      IDLE: if (ub_req_rdy && (|vpu_data_pathway)) next_state = REQUEST_Z_PRIME;

      REQUEST_Z_PRIME: next_state = WAIT_Z_PRIME;

      WAIT_Z_PRIME: if (mem_delay_ctr == 2'd2) next_state = REQUEST_BIAS;

      REQUEST_BIAS: next_state = WAIT_BIAS;

      WAIT_BIAS: if (mem_delay_ctr == 2'd2) next_state = PROCESSING;

      PROCESSING: begin
        // after last input presented, wait some pipeline cycles (~SIZE is a reasonable bound)
        if (all_vectors_processed && (pipeline_delay_ctr >= SIZE[$bits(pipeline_delay_ctr)-1:0]))
          next_state = WRITE_Z;
      end

      WRITE_Z: begin
        if (ub_req_rdy && (Z_out_addr_ctr >= (SIZE-1)))
          next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end

  // Memory delay counter (simple 2-cycle "latency model")
  always_ff @(posedge clk or posedge rst) begin
    if (rst) mem_delay_ctr <= '0;
    else begin
      if (current_state == WAIT_Z_PRIME || current_state == WAIT_BIAS) begin
        if (mem_delay_ctr < 2'd2) mem_delay_ctr <= mem_delay_ctr + 1'b1;
      end else begin
        mem_delay_ctr <= '0;
      end
    end
  end

  // Counters & flags
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      vector_ctr                <= '0;
      element_ctr               <= '0;
      Z_prime_addr_ctr          <= '0;
      bias_addr_ctr             <= '0;
      Z_out_addr_ctr            <= '0;
      pipeline_delay_ctr        <= '0;
      bias_loaded               <= 1'b0;
      data_loaded               <= 1'b0;
      vector_processed          <= '0;
      all_vectors_processed_flag<= 1'b0;
    end else begin
      unique case (current_state)
        IDLE: begin
          if (ub_req_rdy && (|vpu_data_pathway)) begin
            Z_prime_addr_ctr           <= '0;
            bias_addr_ctr              <= '0;
            Z_out_addr_ctr             <= '0;
            vector_ctr                 <= '0;
            element_ctr                <= '0;
            vector_processed           <= '0;
            all_vectors_processed_flag <= 1'b0;
          end
        end

        REQUEST_Z_PRIME: if (ub_req_rdy) Z_prime_addr_ctr <= Z_prime_addr_ctr + 1'b1;

        WAIT_Z_PRIME: if (mem_delay_ctr == 2'd1) data_loaded <= 1'b1;

        REQUEST_BIAS: if (ub_req_rdy) bias_addr_ctr <= bias_addr_ctr + 1'b1;

        WAIT_BIAS: if (mem_delay_ctr == 2'd1) bias_loaded <= 1'b1;

        PROCESSING: begin
          if (data_loaded && bias_loaded) begin
            // element_ctr goes 0..SIZE-1, then move to next vector
            if (element_ctr == SIZE-1) begin
              element_ctr <= '0;
              if (vector_ctr == (SIZE-1)) begin
                vector_ctr                 <= '0;
                all_vectors_processed_flag <= 1'b1;
              end else begin
                vector_ctr <= vector_ctr + 1'b1;
              end
            end else begin
              element_ctr <= element_ctr + 1'b1;
            end
          end

          if (all_vectors_processed_flag) begin
            if (pipeline_delay_ctr < (2*SIZE)) pipeline_delay_ctr <= pipeline_delay_ctr + 1'b1;
          end else begin
            pipeline_delay_ctr <= '0;
          end
        end

        WRITE_Z: begin
          if (ub_req_rdy) begin
            if (Z_out_addr_ctr < (SIZE-1)) Z_out_addr_ctr <= Z_out_addr_ctr + 1'b1;
          end
        end

        default: begin
          if (current_state != PROCESSING && current_state != WRITE_Z) begin
            bias_loaded                <= 1'b0;
            data_loaded                <= 1'b0;
            vector_processed           <= '0;
            all_vectors_processed_flag <= 1'b0;
          end
        end
      endcase
    end
  end

  // Address outputs
  assign addr_Z_prime = (current_state == REQUEST_Z_PRIME) ? Z_prime_addr_ctr : '0;
  assign addr_b       = (current_state == REQUEST_BIAS)    ? bias_addr_ctr    : '0;  
  assign addr_Z       = (current_state == WRITE_Z)         ? Z_out_addr_ctr   : '0;

  // Request valid
  assign ub_req_val = ((current_state == REQUEST_Z_PRIME) || 
                       (current_state == REQUEST_BIAS)    || 
                       (current_state == WRITE_Z)) && ub_req_rdy;

  // ==== Datapath fanout: slice Z' vector into SIZE lanes ====
  // drive inputs only during PROCESSING when buffers are loaded
  integer li;
  always_comb begin
    for (li = 0; li < SIZE; li++) begin
      vpu_data_in [li] = '0;
      vpu_valid_in[li] = 1'b0;
    end
    if (current_state == PROCESSING && data_loaded && bias_loaded) begin
      for (li = 0; li < SIZE; li++) begin
        // MSB element = lane 0, like before
        vpu_data_in[li] = Z_prime_buffer[vector_ctr][ DATA_W*(SIZE-1-li) +: DATA_W ];
        vpu_valid_in[li]= 1'b1;
      end
    end
  end

  // ==== Bias slicing to SIZE lanes ====
  genvar bi;
  generate
    for (bi = 0; bi < SIZE; bi++) begin : g_bias_slice
      assign bias_scalar_in[bi] = bias_buffer[ DATA_W*(SIZE-1-bi) +: DATA_W ];
    end
  endgenerate

  // ==== Capture outputs back into the Z_out_buffer ====
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < SIZE; i++) Z_out_buffer[i] <= '0;
      vector_processed <= '0;
    end else begin
      // Use lane 0 valid as a group-valid (lanes should be aligned)
      if (vpu_valid_out[0] && (current_state == PROCESSING)) begin
        for (int j = 0; j < SIZE; j++) begin
          Z_out_buffer[vector_ctr][ DATA_W*(SIZE-1-j) +: DATA_W ] <= vpu_data_out[j];
        end
        vector_processed[vector_ctr] <= 1'b1;
      end
    end
  end

  // ==== Drive UB output only in WRITE_Z ====
  integer zi;
  always_comb begin
    for (zi = 0; zi < SIZE; zi++) begin
      data_Z[zi] = (current_state == WRITE_Z) ? Z_out_buffer[zi] : '0;
    end
  end

  // ==== Buffer incoming data/bias when "memory" is ready ====
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < SIZE; i++) Z_prime_buffer[i] <= '0;
      bias_buffer      <= '0;
      lr_leak_factor_in<= 16'sh001A; // default 0.1 in Q8.8
    end else begin
      if (current_state == WAIT_Z_PRIME && mem_delay_ctr == 2'd1) begin
        for (int i = 0; i < SIZE; i++) Z_prime_buffer[i] <= data_Z_prime[i];
      end
      if (current_state == WAIT_BIAS && mem_delay_ctr == 2'd1) begin
        bias_buffer <= data_b;
      end
      // you can program this elsewhere; keep default each cycle
      lr_leak_factor_in <= 16'sh001A;
    end
  end

  // Busy
  assign vpu_busy = (current_state != IDLE);

endmodule
