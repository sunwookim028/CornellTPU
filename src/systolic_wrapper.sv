`timescale 1ns/1ps
`default_nettype none

module systolic_wrapper #(
    parameter int N = 4,
    parameter int DATA_WIDTH = 16, // AKA Word size. This should be changed to 32 - we need systolic array switched to FP32
    parameter int BANKING_FACTOR = 1, // How many data elements can be loaded at a time
    parameter int ADDRESS_WIDTH = 13, // Bits in each address
    parameter int MEM_LATENCY = 2 // Latency in cycles from memory request to valid response
)(
    input  logic clk,
    input  logic rst,

    // To/from control:
    input  logic start,
    output logic done,

    input logic [ADDRESS_WIDTH-1:0] base_addr_w,
    input logic [ADDRESS_WIDTH-1:0] base_addr_x,
    input logic [ADDRESS_WIDTH-1:0] base_addr_out,

    // To/from memory:
    output logic [ADDRESS_WIDTH-1:0] mem_req_addr,
    output logic [BANKING_FACTOR*DATA_WIDTH-1 : 0] mem_req_data,
    input  logic [BANKING_FACTOR*DATA_WIDTH-1 : 0] mem_resp_data,
    output logic mem_read_en,
    output logic mem_write_en,

    // Temporary (to be removed and replaced with storing back to memory):
    output logic signed [DATA_WIDTH-1:0] out_matrix [N*N-1:0] // leave this as an output for now
);

    // Helper function for indexing matrices with data stored in row-major order
    function automatic int idx(input int r, input int c);
        return r*N + c;
    endfunction

    // Local buffer memory for W and X matrices
    logic signed [DATA_WIDTH-1:0] weight_matrix [N*N-1:0];
    logic signed [DATA_WIDTH-1:0] x_matrix [N*N-1:0];

    localparam int TOTAL_ELEMS = N*N;
    localparam int BYTES_PER_BEAT = BANKING_FACTOR * (DATA_WIDTH / 8);

    // Registers to latch matrix addresses
    logic [ADDRESS_WIDTH-1:0] base_addr_x_reg, base_addr_w_reg, base_addr_out_reg;

    // Index for load progress (indexes loading beats)
    integer load_idx;

    // Timer for memory fixed latency
    logic [$clog2(MEM_LATENCY+1)-1:0] mem_latency_timer;

    // X and W matrix elements for input into array
    logic signed [DATA_WIDTH-1:0]
        sys_weight_in_11, sys_weight_in_12, sys_weight_in_13, sys_weight_in_14,
        sys_data_in_11,   sys_data_in_21,   sys_data_in_31,   sys_data_in_41;
    // Control signals
    logic
        sys_accept_w_1, sys_accept_w_2, sys_accept_w_3, sys_accept_w_4,
        sys_start_1, sys_start_2, sys_start_3, sys_start_4,
        sys_switch_in;
    // Output matrix elements
    logic signed [DATA_WIDTH-1:0]
        sys_data_out_41, sys_data_out_42, sys_data_out_43, sys_data_out_44;
    // Status signals
    logic
        sys_valid_out_41, sys_valid_out_42, sys_valid_out_43, sys_valid_out_44;

    logic [15:0] ub_rd_col_size_in = 16'd0; // Not yet used in systolic
    logic ub_rd_col_size_valid_in  = 1'b0; // Not yet used in systolic

    systolic #( N ) array (
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
        .sys_data_out_41(sys_data_out_41),
        .sys_data_out_42(sys_data_out_42),
        .sys_data_out_43(sys_data_out_43),
        .sys_data_out_44(sys_data_out_44),
        .sys_valid_out_41(sys_valid_out_41),
        .sys_valid_out_42(sys_valid_out_42),
        .sys_valid_out_43(sys_valid_out_43),
        .sys_valid_out_44(sys_valid_out_44),
        .sys_weight_in_11(sys_weight_in_11),
        .sys_weight_in_12(sys_weight_in_12),
        .sys_weight_in_13(sys_weight_in_13),
        .sys_weight_in_14(sys_weight_in_14),
        .sys_accept_w_1(sys_accept_w_1),
        .sys_accept_w_2(sys_accept_w_2),
        .sys_accept_w_3(sys_accept_w_3),
        .sys_accept_w_4(sys_accept_w_4),
        .sys_switch_in(sys_switch_in),
        .ub_rd_col_size_in(ub_rd_col_size_in),
        .ub_rd_col_size_valid_in(ub_rd_col_size_valid_in)
    );

    typedef enum logic [3:0] {
        S_IDLE,
        S_LOAD_W_REQ,
        S_LOAD_W_WAIT,
        S_LOAD_X_REQ,
        S_LOAD_X_WAIT,
        S_RUN,
        S_CAPTURE,
        S_DONE
    } state_t;

    state_t state;
    logic [$clog2(8*N):0] phase_counter;
    integer row_ptr [N];

    // Collect outputs from systolic array when valid out signals asserted
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i=0; i<N; i++) row_ptr[i] <= 0;
            for (int r=0; r<N; r++)
                for (int c=0; c<N; c++)
                    out_matrix[idx(r,c)] <= '0;
        end else begin
            if (sys_valid_out_41 && row_ptr[0] < N) begin
                out_matrix[idx(row_ptr[0],0)] <= sys_data_out_41;
                row_ptr[0] <= row_ptr[0] + 1;
            end
            if (sys_valid_out_42 && row_ptr[1] < N) begin
                out_matrix[idx(row_ptr[1],1)] <= sys_data_out_42;
                row_ptr[1] <= row_ptr[1] + 1;
            end
            if (sys_valid_out_43 && row_ptr[2] < N) begin
                out_matrix[idx(row_ptr[2],2)] <= sys_data_out_43;
                row_ptr[2] <= row_ptr[2] + 1;
            end
            if (sys_valid_out_44 && row_ptr[3] < N) begin
                out_matrix[idx(row_ptr[3],3)] <= sys_data_out_44;
                row_ptr[3] <= row_ptr[3] + 1;
            end
        end
    end

    // FSM Logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Return to idle state
            state <= S_IDLE;

            // Reset run state counter
            phase_counter <= '0;

            mem_req_addr <= '0;
            mem_req_data <= '0;
            mem_read_en <= 0;
            mem_write_en <= 0;

            mem_latency_timer <= '0; // Cycles since memory request

            load_idx <= 0;

            done <= 0;

            // Reset latched base addresses
            base_addr_x_reg <= '0;
            base_addr_w_reg <= '0;
            base_addr_out_reg <= '0;

            // Datapath control signals
            sys_accept_w_1 <= 0;
            sys_accept_w_2 <= 0;
            sys_accept_w_3 <= 0;
            sys_accept_w_4 <= 0;
            sys_start_1 <= 0;
            sys_start_2 <= 0;
            sys_start_3 <= 0;
            sys_start_4 <= 0;
            sys_switch_in <= 0;
            sys_weight_in_11 <= 16'd0;
            sys_weight_in_12 <= 16'd0;
            sys_weight_in_13 <= 16'd0;
            sys_weight_in_14 <= 16'd0;
            sys_data_in_11 <= 16'd0;
            sys_data_in_21 <= 16'd0;
            sys_data_in_31 <= 16'd0;
            sys_data_in_41 <= 16'd0;
        end else begin
            // Defaults
            done <= 0;
            // Datapath control signals
            sys_accept_w_1 <= 0;
            sys_accept_w_2 <= 0;
            sys_accept_w_3 <= 0;
            sys_accept_w_4 <= 0;
            sys_start_1 <= 0;
            sys_start_2 <= 0;
            sys_start_3 <= 0;
            sys_start_4 <= 0;
            sys_switch_in <= 0;
            sys_weight_in_11 <= 16'd0;
            sys_weight_in_12 <= 16'd0;
            sys_weight_in_13 <= 16'd0;
            sys_weight_in_14 <= 16'd0;
            sys_data_in_11 <= 16'd0;
            sys_data_in_21 <= 16'd0;
            sys_data_in_31 <= 16'd0;
            sys_data_in_41 <= 16'd0;

            mem_req_addr <= '0;
            mem_req_data <= '0;
            mem_read_en <= 0;
            mem_write_en <= 0;

            case(state)
                S_IDLE: begin
                    if (start) begin
                        base_addr_x_reg <= base_addr_x;
                        base_addr_w_reg <= base_addr_w;
                        base_addr_out_reg <= base_addr_out;
                        state <= S_LOAD_W_REQ;
                    end
                end

                S_LOAD_W_REQ: begin
                    mem_req_addr <= base_addr_w_reg + (load_idx * BYTES_PER_BEAT);
                    mem_read_en <= 1;
                    // Reset memory latency timer - 0 cycles since memory request
                    mem_latency_timer <= '0;
                    state <= S_LOAD_W_WAIT;
                end

                S_LOAD_W_WAIT: begin
                    if (mem_latency_timer >= (MEM_LATENCY - 1)) begin
                        // Timer is up - valid response from memory is ready
                        // Write response from memory to W matrix
                        // Use for-loop to unpack response if BANKING_FACTOR > 1
                        for (int b = 0; b < BANKING_FACTOR; b++) begin
                            int flat_index;
                            flat_index = load_idx * BANKING_FACTOR + b;
                            if (flat_index < TOTAL_ELEMS) begin
                                weight_matrix[flat_index] <= mem_resp_data[b*DATA_WIDTH +: DATA_WIDTH];
                            end
                        end
                        // Increment load_idx by banking factor to reflect matrix index of next element to request (i.e.
                        // first element in next block to request if BANKING_FACTOR > 1). If done with W matrix, zero out
                        // load_idx and move on to X matrix.
                        if ((load_idx + 1) * BANKING_FACTOR >= TOTAL_ELEMS) begin
                            // Next idx > N^2, so we have finished with the W matrix
                            // Move on to request X
                            load_idx <= '0;
                            state <= S_LOAD_X_REQ;
                        end else begin
                            // Move back to request W to request next weight block
                            load_idx <= load_idx + 1;
                            state <= S_LOAD_W_REQ;
                        end
                    end else begin
                        // Timer not up - increment timer
                        mem_latency_timer <= mem_latency_timer + 1;
                    end
                end

                S_LOAD_X_REQ: begin
                    mem_req_addr <= base_addr_x_reg + (load_idx * BYTES_PER_BEAT);
                    mem_read_en <= 1;
                    // Reset memory latency timer - 0 cycles since memory request
                    mem_latency_timer <= '0;
                    state <= S_LOAD_X_WAIT;
                end

                S_LOAD_X_WAIT: begin
                    if (mem_latency_timer >= (MEM_LATENCY - 1)) begin
                        // Timer is up - valid response from memory is ready
                        // Write response from memory to X matrix
                        // Use for-loop to unpack response if BANKING_FACTOR > 1
                        for (int b = 0; b < BANKING_FACTOR; b++) begin
                            int flat_index;
                            flat_index = load_idx * BANKING_FACTOR + b;
                            if (flat_index < TOTAL_ELEMS) begin
                                x_matrix[flat_index] <= mem_resp_data[b*DATA_WIDTH +: DATA_WIDTH];
                            end
                        end
                        // Increment load_idx by banking factor to reflect matrix index of next element to request (i.e.
                        // first element in next block to request if BANKING_FACTOR > 1). If done with X matrix,
                        // move on to run (compute) state.
                        if ((load_idx + 1) * BANKING_FACTOR >= TOTAL_ELEMS) begin
                            // Next idx > N^2, so we have finished with the X matrix
                            // Move on to run state
                            load_idx <= '0;
                            phase_counter <= '0;
                            state <= S_RUN;
                        end else begin
                            // Move back to request X to request next weight block
                            load_idx <= load_idx + 1;
                            state <= S_LOAD_X_REQ;
                        end
                    end else begin
                        // Timer not up - increment timer
                        mem_latency_timer <= mem_latency_timer + 1;
                    end
                end
                
                S_RUN: begin
                    // Increment phase counter
                    phase_counter <= phase_counter + 1;

                    // ---- Weight pipeline: column-major, reversed along rows ----
                    // Column 0
                    if (phase_counter < N) begin
                        sys_weight_in_11 <= weight_matrix[idx(0, N-1-phase_counter)];
                        sys_accept_w_1   <= 1;
                    end else sys_accept_w_1 <= 0;

                    // Column 1
                    if (phase_counter >= 1 && phase_counter < N+1) begin
                        sys_weight_in_12 <= weight_matrix[idx(1, N-1-(phase_counter-1))];
                        sys_accept_w_2   <= 1;
                    end else sys_accept_w_2 <= 0;

                    // Column 2
                    if (phase_counter >= 2 && phase_counter < N+2) begin
                        sys_weight_in_13 <= weight_matrix[idx(2, N-1-(phase_counter-2))];
                        sys_accept_w_3   <= 1;
                    end else sys_accept_w_3 <= 0;

                    // Column 3
                    if (phase_counter >= 3 && phase_counter < N+3) begin
                        sys_weight_in_14 <= weight_matrix[idx(3, N-1-(phase_counter-3))];
                        sys_accept_w_4   <= 1;
                    end else sys_accept_w_4 <= 0;

                    // ---- Switch X input when last weight of column 1 is loaded ----
                    if (phase_counter == N-1)
                        sys_switch_in <= 1;
                    else
                        sys_switch_in <= 0;

                    // ---- X input stream: staggered along rows ----
                    for (int row = 0; row < N; row++) begin
                        int ph;
                        ph = phase_counter - (N + row); // row-dependent delay
                        if (ph >= 0 && ph < N) begin
                            case (row)
                                0: begin sys_start_1 <= 1; sys_data_in_11 <= x_matrix[idx(ph, 0)]; end
                                1: begin sys_start_2 <= 1; sys_data_in_21 <= x_matrix[idx(ph, 1)]; end
                                2: begin sys_start_3 <= 1; sys_data_in_31 <= x_matrix[idx(ph, 2)]; end
                                3: begin sys_start_4 <= 1; sys_data_in_41 <= x_matrix[idx(ph, 3)]; end
                            endcase
                        end
                    end

                    // ---- Stop when weight and input sequences done ----
                    if (phase_counter >= 3*N - 2) begin
                        phase_counter <= '0;
                        state <= S_CAPTURE;
                    end
                end

                S_CAPTURE: begin
                    bit all_done;
                    all_done = 1;
                    for (int i = 0; i < N; i++)
                        all_done &= (row_ptr[i] == N);
                    if (all_done)
                        state <= S_DONE;
                end

                S_DONE: begin
                    done <= 1;
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule