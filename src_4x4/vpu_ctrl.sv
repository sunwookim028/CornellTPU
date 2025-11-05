// VPU controller unit for communication control b/w VPU and UB
// UB <-> VPU ctrl <-> VPU
`timescale 1ns/1ps
`default_nettype none

module vpu_ctrl#(
  parameter int DATA_W = 16,
  parameter int ADDR_W = 10,
  parameter int B = 8,        // batch size (rows) - K in spec
  parameter int D_OUT = 4     // output features (columns) - M in spec
)(
  input logic clk,
  input logic rst,

  // UB Interface
  input logic ub_req_rdy,           // UB ready to accept request for data
  output logic ub_req_val,          // VPU ctrl sending valid addr request
  
  // Address outputs to UB
  output logic [ADDR_W-1:0] addr_Z_prime,  // Systolic array data address (Z')
  output logic [ADDR_W-1:0] addr_b,        // Bias data address  
  output logic [ADDR_W-1:0] addr_Z,        // VPU output data address

  // Data interfaces with UB 
  input logic [63:0] data_Z_prime [0:B-1],   // 8 banks x 64b from UB (8 vectors)
  input logic [63:0] data_b,                 // Bias data (64b)
  output logic [63:0] data_Z [0:B-1],        // 8 banks x 64b to UB (8 vectors)

  // VPU Interface
  // Inputs to VPU datapath - 4 parallel lanes
  output logic signed [DATA_W-1:0] vpu_data_in_1,
  output logic signed [DATA_W-1:0] vpu_data_in_2, 
  output logic signed [DATA_W-1:0] vpu_data_in_3,
  output logic signed [DATA_W-1:0] vpu_data_in_4,
  output logic vpu_valid_in_1,
  output logic vpu_valid_in_2,
  output logic vpu_valid_in_3,
  output logic vpu_valid_in_4,

  // Bias inputs to VPU - 1D: D_OUT elements (one per output neuron)
  output logic signed [DATA_W-1:0] bias_scalar_in_1,
  output logic signed [DATA_W-1:0] bias_scalar_in_2,
  output logic signed [DATA_W-1:0] bias_scalar_in_3, 
  output logic signed [DATA_W-1:0] bias_scalar_in_4,

  // Learning rate/leak factor
  output logic signed [DATA_W-1:0] lr_leak_factor_in,

  // VPU outputs to be stored in UB
  input logic signed [DATA_W-1:0] vpu_data_out_1,
  input logic signed [DATA_W-1:0] vpu_data_out_2,
  input logic signed [DATA_W-1:0] vpu_data_out_3,
  input logic signed [DATA_W-1:0] vpu_data_out_4,
  input logic vpu_valid_out_1,
  input logic vpu_valid_out_2,
  input logic vpu_valid_out_3,
  input logic vpu_valid_out_4,

  // Control signals
  input logic [3:0] vpu_data_pathway,    // Operation mode control
  output logic vpu_busy                  // VPU controller busy signal
);

  // Internal state and counters
  localparam IDLE = 3'd0;
  localparam REQUEST_Z_PRIME = 3'd1;
  localparam WAIT_Z_PRIME = 3'd2;
  localparam REQUEST_BIAS = 3'd3;
  localparam WAIT_BIAS = 3'd4;
  localparam PROCESSING = 3'd5;
  localparam WRITE_Z = 3'd6;

  logic [2:0] current_state, next_state;

  // Address counters
  logic [ADDR_W-1:0] Z_prime_addr_ctr;
  logic [ADDR_W-1:0] bias_addr_ctr; 
  logic [ADDR_W-1:0] Z_out_addr_ctr;

  // Vector processing counters
  logic [2:0] vector_ctr;           // Counts 0-7 for 8 vectors per batch
  logic [1:0] element_ctr;          // Counts 0-3 for 4 elements per vector
  
  // Data buffers for vector processing
  logic [63:0] Z_prime_buffer [0:B-1];  // Store all 8 vectors from UB
  logic [63:0] bias_buffer;           // Store bias vector
  logic [63:0] Z_out_buffer [0:B-1];    // Store output vectors for UB
  
  // Control signals
  logic bias_loaded;
  logic data_loaded;

  // Pipeline delay tracking
  logic [2:0] pipeline_delay_ctr;
  logic [1:0] mem_delay_ctr;
  logic [B-1:0] vector_processed;  // Track which vectors have been processed

  // All vectors processed signal - SINGLE ASSIGNMENT
  logic all_vectors_processed;
  assign all_vectors_processed = &vector_processed;

  // Additional flag for processing completion
  logic all_vectors_processed_flag;

  // State register
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic - FIXED with proper memory timing
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (ub_req_rdy && (|vpu_data_pathway)) begin
          next_state = REQUEST_Z_PRIME;
        end
      end
      
      REQUEST_Z_PRIME: begin
        next_state = WAIT_Z_PRIME;
      end
      
      WAIT_Z_PRIME: begin
        if (mem_delay_ctr == 2'd2) begin  // Wait 2 cycles for memory
          next_state = REQUEST_BIAS;
        end
      end
      
      REQUEST_BIAS: begin
        next_state = WAIT_BIAS;
      end
      
      WAIT_BIAS: begin
        if (mem_delay_ctr == 2'd2) begin  // Wait 2 cycles for memory
          next_state = PROCESSING;
        end
      end
      
      PROCESSING: begin
        // Wait for all vectors to be processed AND pipeline to complete
        if (all_vectors_processed && (pipeline_delay_ctr >= 3'd5)) begin
          next_state = WRITE_Z;
        end
      end
      
      WRITE_Z: begin
        // Stay in WRITE_Z until all vectors are written to UB
        if (ub_req_rdy && (Z_out_addr_ctr >= (B-1))) begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end

  // Memory delay counter
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      mem_delay_ctr <= '0;
    end else begin
      if (current_state == WAIT_Z_PRIME || current_state == WAIT_BIAS) begin
        if (mem_delay_ctr < 2'd2) begin
          mem_delay_ctr <= mem_delay_ctr + 1'b1;
        end
      end else begin
        mem_delay_ctr <= '0;
      end
    end
  end

  // Vector and element counters for processing - FIXED: Better timing
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      vector_ctr <= '0;
      element_ctr <= '0;
      Z_prime_addr_ctr <= '0;
      bias_addr_ctr <= '0;
      Z_out_addr_ctr <= '0;
      pipeline_delay_ctr <= '0;
      bias_loaded <= 1'b0;
      data_loaded <= 1'b0;
      vector_processed <= '0;
      all_vectors_processed_flag <= 1'b0;
    end else begin
      case (current_state)
        IDLE: begin
          // Reset counters when starting new operation
          if (ub_req_rdy && (|vpu_data_pathway)) begin
            Z_prime_addr_ctr <= '0;
            bias_addr_ctr <= '0;
            Z_out_addr_ctr <= '0;
            vector_ctr <= '0;
            element_ctr <= '0;
            vector_processed <= '0;
            all_vectors_processed_flag <= 1'b0;
          end
        end
        
        REQUEST_Z_PRIME: begin
          if (ub_req_rdy) begin
            Z_prime_addr_ctr <= Z_prime_addr_ctr + 1'b1;
          end
        end
        
        WAIT_Z_PRIME: begin
          if (mem_delay_ctr == 2'd1) begin
            // Data should now be available in buffers
            data_loaded <= 1'b1;
          end
        end
        
        REQUEST_BIAS: begin
          if (ub_req_rdy) begin
            bias_addr_ctr <= bias_addr_ctr + 1'b1;
          end
        end
        
        WAIT_BIAS: begin
          if (mem_delay_ctr == 2'd1) begin
            bias_loaded <= 1'b1;
          end
        end
        
        PROCESSING: begin
          // Increment element counter each cycle
          if (data_loaded && bias_loaded) begin
            if (element_ctr == 2'd3) begin
              element_ctr <= '0;
              if (vector_ctr == (B-1)) begin
                vector_ctr <= '0;
                all_vectors_processed_flag <= 1'b1;
              end else begin
                vector_ctr <= vector_ctr + 1'b1;
              end
            end else begin
              element_ctr <= element_ctr + 1'b1;
            end
          end
          
          // Track pipeline delay after last input
          if (all_vectors_processed_flag) begin
            if (pipeline_delay_ctr < 3'd6) begin
              pipeline_delay_ctr <= pipeline_delay_ctr + 1'b1;
            end
          end else begin
            pipeline_delay_ctr <= '0;
          end
        end
        
        WRITE_Z: begin
          if (ub_req_rdy) begin
            // Increment address for each write
            if (Z_out_addr_ctr < (B-1)) begin
              Z_out_addr_ctr <= Z_out_addr_ctr + 1'b1;
            end
          end
        end
        
        default: begin
          // Reset flags when not in processing states
          if (current_state != PROCESSING && current_state != WRITE_Z) begin
            bias_loaded <= 1'b0;
            data_loaded <= 1'b0;
            vector_processed <= '0;
            all_vectors_processed_flag <= 1'b0;
          end
        end
      endcase
    end
  end

  // Output address assignment - FIXED: Conditional assignment
  assign addr_Z_prime = (current_state == REQUEST_Z_PRIME) ? Z_prime_addr_ctr : '0;
  assign addr_b = (current_state == REQUEST_BIAS) ? bias_addr_ctr : '0;  
  assign addr_Z = (current_state == WRITE_Z) ? Z_out_addr_ctr : '0;

  // Request validation - FIXED: Only assert during appropriate states
  assign ub_req_val = ((current_state == REQUEST_Z_PRIME) || 
                      (current_state == REQUEST_BIAS) || 
                      (current_state == WRITE_Z)) && 
                      ub_req_rdy;

  // Data routing to VPU - FIXED: Send ALL elements to ALL lanes in parallel
  always_comb begin
    // Default assignments
    vpu_data_in_1 = '0;
    vpu_data_in_2 = '0;
    vpu_data_in_3 = '0;
    vpu_data_in_4 = '0;
    
    if (current_state == PROCESSING && data_loaded && bias_loaded) begin
      // Send all 4 elements of current vector to all 4 lanes
      vpu_data_in_1 = Z_prime_buffer[vector_ctr][63:48];  // Element 0
      vpu_data_in_2 = Z_prime_buffer[vector_ctr][47:32];  // Element 1
      vpu_data_in_3 = Z_prime_buffer[vector_ctr][31:16];  // Element 2
      vpu_data_in_4 = Z_prime_buffer[vector_ctr][15:0];   // Element 3
    end
  end

  // Valid signals for VPU input
  assign vpu_valid_in_1 = (current_state == PROCESSING) && data_loaded && bias_loaded;
  assign vpu_valid_in_2 = (current_state == PROCESSING) && data_loaded && bias_loaded;
  assign vpu_valid_in_3 = (current_state == PROCESSING) && data_loaded && bias_loaded;
  assign vpu_valid_in_4 = (current_state == PROCESSING) && data_loaded && bias_loaded;

  // Bias routing - distribute 4 bias elements to 4 lanes
  assign bias_scalar_in_1 = bias_buffer[63:48]; // Bias for lane 1
  assign bias_scalar_in_2 = bias_buffer[47:32]; // Bias for lane 2  
  assign bias_scalar_in_3 = bias_buffer[31:16]; // Bias for lane 3
  assign bias_scalar_in_4 = bias_buffer[15:0];  // Bias for lane 4

  // Data routing from VPU to UB - FIXED: Proper output reconstruction
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < B; i++) begin
        Z_out_buffer[i] <= '0;
      end
      vector_processed <= '0;
    end else begin
      // Capture outputs when first valid signal is high (all should be synchronized)
      if (vpu_valid_out_1 && (current_state == PROCESSING)) begin
        // All 4 lanes have valid outputs - reconstruct the complete 64-bit vector
        Z_out_buffer[vector_ctr] <= {vpu_data_out_1, vpu_data_out_2, vpu_data_out_3, vpu_data_out_4};
        vector_processed[vector_ctr] <= 1'b1;
      end
    end
  end

  // Output data to UB - FIXED: Only drive during WRITE_Z state
  always_comb begin
    for (int i = 0; i < B; i++) begin
      if (current_state == WRITE_Z) begin
        data_Z[i] = Z_out_buffer[i];
      end else begin
        data_Z[i] = '0;  // Drive zeros when not writing
      end
    end
  end

  // Data buffering from UB - FIXED: Proper data capture with timing
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < B; i++) begin
        Z_prime_buffer[i] <= '0;
      end
      bias_buffer <= '0;
      lr_leak_factor_in <= 16'sh001A; // 0.1 in Q8.8 format
    end else begin
      // Buffer Z' data from UB - capture when memory provides data (after 1 cycle delay)
      if (current_state == WAIT_Z_PRIME && mem_delay_ctr == 2'd1) begin
        for (int i = 0; i < B; i++) begin
          Z_prime_buffer[i] <= data_Z_prime[i];
        end
      end
      
      // Buffer bias data from UB - capture when memory provides data (after 1 cycle delay)
      if (current_state == WAIT_BIAS && mem_delay_ctr == 2'd1) begin
        bias_buffer <= data_b;
      end
      
      // Set learning rate/leak factor (0.1 for leaky ReLU)
      lr_leak_factor_in <= 16'sh001A; // 0.1 in Q8.8 (0.1 * 256 = 25.6 ≈ 26 = 0x1A)
    end
  end

  // Busy signal - busy when not idle
  assign vpu_busy = (current_state != IDLE);

endmodule