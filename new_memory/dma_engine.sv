`timescale 1ns/1ps

module DMAEngine #(
  parameter int ADDR_W = ADDR_WIDTH, // Width of UB addresses
  parameter int DATA_W = DATA_WIDTH  // Width of data bus
)(
  input  logic                   clk,
  input  logic                   reset,

  // ---- Control interface ----
  input  logic                   start,       // Begin a transfer
  input  logic                   write_en,    // 1: DRAM->UB, 0: UB->DRAM
  input  logic [ADDR_W-1:0]      base_addr,   // Start address in UB
  input  logic [15:0]            length,      // Number of words to transfer
  output logic                   done,        // Transfer complete

  // ---- To Unified Buffer ----
  output logic                   dma_write_en,
  output logic                   dma_read_en,
  output logic [ADDR_W-1:0]      dma_addr,
  output logic [DATA_W-1:0]      dma_data_in,
  input  logic [DATA_W-1:0]      dma_data_out,

  // ---- Streaming IN (from DRAM) ----
  input  logic                   in_valid,    // Data valid from DRAM
  output logic                   in_ready,    // Ready to accept data
  input  logic [DATA_W-1:0]      in_data,

  // ---- Streaming OUT (to DRAM) ----
  output logic                   out_valid,   // Data valid to DRAM
  input  logic                   out_ready,   // DRAM ready to accept
  output logic [DATA_W-1:0]      out_data
);

  // FSM state type
  ub_dma_state_e state;
  logic [15:0]   count;  // Tracks number of words transferred

  // ---- Default combinational outputs ----
  always_comb begin
    dma_write_en = 1'b0;
    dma_read_en  = 1'b0;
    in_ready     = 1'b0;
    out_valid    = 1'b0;
    out_data     = dma_data_out; // default read data from UB
  end

  // ---- Main FSM ----
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state   <= UB_IDLE;
      count   <= '0;
      done    <= 1'b0;
      dma_addr <= '0;
    end else begin
      unique case (state)
        // -----------------------
        UB_IDLE: begin
          done  <= 1'b0;
          count <= '0;
          if (start) state <= UB_XFER; // Begin transfer
        end

        // -----------------------
        UB_XFER: begin
          dma_addr <= base_addr + count; // Address in UB

          if (write_en) begin
            // ---- DRAM -> UB ----
            in_ready <= 1'b1;             // Accept external stream
            if (in_valid) begin
              dma_write_en <= 1'b1;       // Write into UB
              dma_data_in  <= in_data;    // Capture incoming data
              count        <= count + 16'd1;
            end
          end else begin
            // ---- UB -> DRAM ----
            dma_read_en <= 1'b1;          // Read from UB
            out_valid   <= 1'b1;          // Present on output stream
            out_data    <= dma_data_out;
            if (out_ready) begin
              count <= count + 16'd1;
            end
          end

          // If transfer done, move to done state
          if (count == (length - 1)) state <= UB_DONE;
        end

        // -----------------------
        UB_DONE: begin
          done  <= 1'b1;    // Signal completion
          state <= UB_IDLE;  // Wait for next start
        end
      endcase
    end
  end

endmodule
