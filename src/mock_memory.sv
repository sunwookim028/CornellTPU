`timescale 1ns/1ps
`default_nettype none

module mock_memory #(
    parameter int N = 4,
    parameter int DATA_WIDTH = 16,
    parameter int BANKING_FACTOR = 1,
    parameter int ADDRESS_WIDTH = 32,
    parameter logic [ADDRESS_WIDTH-1:0] BASE_ADDR_W = 32'h00000000,
    parameter logic [ADDRESS_WIDTH-1:0] BASE_ADDR_X = 32'h00001000,
    parameter int MEM_LATENCY = 2  // desired: 2-cycle latency total
)(
    input  logic clk,
    input  logic rst,

    // Request
    input  logic mem_read_en,
    input  logic [ADDRESS_WIDTH-1:0] mem_req_addr,

    // Response
    output logic [BANKING_FACTOR*DATA_WIDTH-1:0] mem_resp_data
);

    // --------------------------------------------------------------------
    // Simple repeating pattern: 0x0000, 0x0100, 0x0200, 0x0300, repeat
    // --------------------------------------------------------------------
    localparam int TOTAL_ELEMS = N*N;
    logic [DATA_WIDTH-1:0] weight_matrix [0:TOTAL_ELEMS-1];
    logic [DATA_WIDTH-1:0] x_matrix      [0:TOTAL_ELEMS-1];

    initial begin
        integer i;
        for (i = 0; i < TOTAL_ELEMS; i++) begin
            weight_matrix[i] = (i % N) << 8;  // 0000, 0100, 0200, 0300
            x_matrix[i]      = ((i % N) << 8) + 16'h0001; // 0001, 0101, ...
        end
    end

    // --------------------------------------------------------------------
    // Simple 2-cycle latency model (no pipelining)
    // --------------------------------------------------------------------
    logic pending;
    logic [ADDRESS_WIDTH-1:0] addr_reg;
    integer latency_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_resp_data <= '0;
            pending       <= 1'b0;
            addr_reg      <= '0;
            latency_cnt   <= 0;
        end else begin
            // Capture request
            if (mem_read_en && !pending) begin
                addr_reg    <= mem_req_addr;
                pending     <= 1'b1;
                latency_cnt <= 0;
            end

            // Handle latency
            if (pending) begin
                if (latency_cnt == MEM_LATENCY - 1) begin
                    // Generate deterministic response
                    logic [BANKING_FACTOR*DATA_WIDTH-1:0] resp;
                    resp = '0;

                    for (int b = 0; b < BANKING_FACTOR; b++) begin
                        int flat_index;
                        flat_index = ((addr_reg - BASE_ADDR_W) >> $clog2(DATA_WIDTH/8))
                                     + b;
                        flat_index %= TOTAL_ELEMS;

                        if (addr_reg >= BASE_ADDR_X)
                            resp[b*DATA_WIDTH +: DATA_WIDTH] = x_matrix[flat_index];
                        else
                            resp[b*DATA_WIDTH +: DATA_WIDTH] = weight_matrix[flat_index];
                    end

                    mem_resp_data <= resp;
                    pending       <= 1'b0;
                end else begin
                    latency_cnt <= latency_cnt + 1;
                end
            end
        end
    end

endmodule
