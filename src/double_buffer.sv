`timescale 1ns/1ps
`default_nettype none

module double_buffer #(
    //parameters????
) (
    input                           clk,
    input                           rst,

    input                           ext_load_en,
    input                           ext_data_in,
    output reg                      ext_read_done,


    input                           pe_read_en,
    output                          pe_data_out,

    // Control signals
    input                           start_compute,
    output reg                      compute_active,
    output reg                      swap_buffers
);
    // State machine definition
    localparam [1:0] S_IDLE        = 2'b00;
    localparam [1:0] S_LOAD_A      = 2'b01;
    localparam [1:0] S_SWITCH      = 2'b10;

    reg  [1:0]  state_reg, state_next;
    reg         buffer_select; // 0 for Buffer A, 1 for Buffer B

    // Memory block instantiation
    wire [31:0]           buf_a_rdata, buf_b_rdata;
    reg  [31:0]           buf_a_wdata, buf_b_wdata;
    reg                   buf_a_we,    buf_b_we;
    reg [31:0]            buf_a_waddr, buf_b_waddr;
    reg [31:0]            buf_a_raddr, buf_b_raddr;

    // Output data from selected buffer
    assign pe_data_out = buffer_select ? buf_b_rdata : buf_a_rdata;

    // State machine logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= S_IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    always @* begin
        state_next = state_reg;
        ext_read_done = 1'b0;
        start_compute = 1'b0;
        swap_buffers = 1'b0;
        buf_a_we = 1'b0;
        buf_b_we = 1'b0;

        case (state_reg)
            S_IDLE: begin
                if (start_compute) begin
                    state_next = S_LOAD_A;
                    buffer_select = 1'b0; 
                end
            end

            S_LOAD_A: begin
                buf_a_we = ext_load_en;
                if (ext_load_en) begin
                    buf_a_wdata = ext_data_in;
                end
                if () begin
                    state_next = S_SWITCH;
                    buffer_select = 1'b1; 
                end
            end

            S_SWITCH: begin
                start_compute = 1'b1; // Tell PEs to start 

                // Load next matrix into the currently inactive buffer
                if (buffer_select == 1'b0) begin
                    buf_a_we = ext_load_en;
                    buf_a_wdata = ext_data_in;
                    if (ext_load_en) begin
                        swap_buffers = 1'b1;
                    end
                end else begin
                    buf_b_we = ext_load_en;
                    buf_b_wdata = ext_data_in;
                    if (ext_load_en) begin
                        swap_buffers = 1'b1;
                    end
                end

                if (swap_buffers) begin
                    buffer_select = ~buffer_select;
                end
            end
        endcase
    end

endmodule