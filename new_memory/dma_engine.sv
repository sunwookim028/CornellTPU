`timescale 1ns/1ps

module DMAEngine #(
  parameter int ADDR_W = ADDR_WIDTH,
  parameter int DATA_W = DATA_WIDTH
)(
  input  logic                   clk,
  input  logic                   reset,

  // Control
  input  logic                   start,
  input  logic                   write_en,      // 1: DRAM->UB, 0: UB->DRAM
  input  logic [ADDR_W-1:0]      base_addr,
  input  logic [15:0]            length,        // words
  output logic                   done,

  // To Unified Buffer
  output logic                   dma_write_en,
  output logic                   dma_read_en,
  output logic [ADDR_W-1:0]      dma_addr,
  output logic [DATA_W-1:0]      dma_data_in,
  input  logic [DATA_W-1:0]      dma_data_out,

  // Streaming IN (from DRAM)  -> used when write_en=1
  input  logic                   in_valid,
  output logic                   in_ready,
  input  logic [DATA_W-1:0]      in_data,

  // Streaming OUT (to DRAM)    -> used when write_en=0
  output logic                   out_valid,
  input  logic                   out_ready,
  output logic [DATA_W-1:0]      out_data
);
  ub_dma_state_e state;
  logic [15:0]   count;

  // defaults
  always_comb begin
    dma_write_en = 1'b0;
    dma_read_en  = 1'b0;
    in_ready     = 1'b0;
    out_valid    = 1'b0;
    out_data     = dma_data_out;
  end

  // FSM
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state   <= UB_IDLE;
      count   <= '0;
      done    <= 1'b0;
      dma_addr <= '0;
    end else begin
      unique case (state)
        UB_IDLE: begin
          done  <= 1'b0;
          count <= '0;
          if (start) state <= UB_XFER;
        end

        UB_XFER: begin
          dma_addr <= base_addr + count;

          if (write_en) begin
            // DRAM -> UB: consume one beat when valid
            in_ready     <= 1'b1;
            if (in_valid) begin
              dma_write_en <= 1'b1;
              dma_data_in  <= in_data;
              count        <= count + 16'd1;
            end
          end else begin
            // UB -> DRAM: read from UB and present on stream
            dma_read_en <= 1'b1;
            out_valid   <= 1'b1;
            out_data    <= dma_data_out;
            if (out_ready) begin
              count <= count + 16'd1;
            end
          end

          if (count == (length - 1)) state <= UB_DONE;
        end

        UB_DONE: begin
          done  <= 1'b1;
          state <= UB_IDLE;
        end
      endcase
    end
  end
endmodule
