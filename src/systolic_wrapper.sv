`timescale 1ns/1ps
`default_nettype none

module systolic_wrapper #(
    parameter int N = 4,
    parameter int DATA_WIDTH = 16 // This should be changed to 32 - we need systolic array switched to FP32
)(
    input  logic clk,
    input  logic rst,

    input  logic start,
    output logic done,

    // Matrices
    input  logic signed [DATA_WIDTH-1:0] weight_matrix [N*N-1:0],
    input  logic signed [DATA_WIDTH-1:0] x_matrix [N*N-1:0],
    output logic signed [DATA_WIDTH-1:0] out_matrix [N*N-1:0]
);


    // Helper function for indexing matrixes
    function automatic int idx(input int r, input int c);
        return r*N + c;
    endfunction

    // ------------------------------------------------------------------
    // Systolic array inputs/outputs/control
    // ------------------------------------------------------------------
    // X and W matrix elements
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

    // ------------------------------------------------------------------
    // FSM / control
    // ------------------------------------------------------------------
    typedef enum logic [1:0] {
        S_IDLE,
        S_RUN,
        S_CAPTURE,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [$clog2(8*N):0] phase_counter; // covers all pipeline phases
    integer row_ptr [N];

    // Sequential state + counters
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            phase_counter <= 0;
            for (int i=0; i<N; i++) row_ptr[i] <= 0;
            for (int r=0; r<N; r++) for (int c=0; c<N; c++) out_matrix[idx(r, c)] <= '0;
        end else begin
            state <= next_state;
            if (state == S_RUN)
                phase_counter <= phase_counter + 1;
            else if (state != next_state)
                phase_counter <= 0;

            // capture valid outputs
            if (sys_valid_out_41 && row_ptr[0] < N) begin
                out_matrix[idx(row_ptr[0], 0)] <= sys_data_out_41;
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

    // ------------------------------------------------------------------
    // Combinational control generation
    // ------------------------------------------------------------------
    int ph;
    always_comb begin
        // defaults
        next_state = state;
        done = 0;

        sys_accept_w_1 = 0; sys_accept_w_2 = 0; sys_accept_w_3 = 0; sys_accept_w_4 = 0;
        sys_start_1 = 0; sys_start_2 = 0; sys_start_3 = 0; sys_start_4 = 0;
        sys_switch_in = 0;

        sys_weight_in_11 = 16'd0; sys_weight_in_12 = 16'd0; sys_weight_in_13 = 16'd0; sys_weight_in_14 = 16'd0;
        sys_data_in_11 = 16'd0; sys_data_in_21 = 16'd0; sys_data_in_31 = 16'd0; sys_data_in_41 = 16'd0;

        case (state)
            S_IDLE: begin
                if (start)
                    next_state = S_RUN;
            end

            S_RUN: begin
                // ---- Weight pipeline: column-major, reversed along rows ----
                // Feed weights into the 4 columns in a diagonal wavefront
                // column 0
                if (phase_counter < N) begin
                    sys_weight_in_11 = weight_matrix[idx(0, N-1-phase_counter)];
                    sys_accept_w_1 = 1;
                end else sys_accept_w_1 = 0;

                // column 1
                if (phase_counter >= 1 && phase_counter < N+1) begin
                    sys_weight_in_12 = weight_matrix[idx(1, N-1-(phase_counter-1))];
                    sys_accept_w_2 = 1;
                end else sys_accept_w_2 = 0;

                // column 2
                if (phase_counter >= 2 && phase_counter < N+2) begin
                    sys_weight_in_13 = weight_matrix[idx(2, N-1-(phase_counter-2))];
                    sys_accept_w_3 = 1;
                end else sys_accept_w_3 = 0;

                // column 3
                if (phase_counter >= 3 && phase_counter < N+3) begin
                    sys_weight_in_14 = weight_matrix[idx(3, N-1-(phase_counter-3))];
                    sys_accept_w_4 = 1;
                end else sys_accept_w_4 = 0;

                // ---- Switch X input when last weight of column 1 is loaded ----
                if (phase_counter == N-1)
                    sys_switch_in = 1;

                // ---- X input stream: staggered along rows ----
                for (int row=0; row<N; row++) begin
                    ph = phase_counter - (N + row); // row-dependent delay
                    if (ph >= 0 && ph < N) begin
                        case(row)
                            0: begin sys_start_1 = 1; sys_data_in_11 = x_matrix[idx(ph,0)]; end
                            1: begin sys_start_2 = 1; sys_data_in_21 = x_matrix[idx(ph,1)]; end
                            2: begin sys_start_3 = 1; sys_data_in_31 = x_matrix[idx(ph,2)]; end
                            3: begin sys_start_4 = 1; sys_data_in_41 = x_matrix[idx(ph,3)]; end
                        endcase
                    end
                end

                // ---- Stop when weight and input sequences done ----
                if (phase_counter >= 3*N - 2)
                    next_state = S_CAPTURE;
            end


            S_CAPTURE: begin
                bit all_done;
                all_done = 1;
                for (int i=0; i<N; i++)
                    if (row_ptr[i] < N) all_done = 0;
                if (all_done)
                    next_state = S_DONE;
            end

            S_DONE: begin
                done = 1;
                if (!start)
                    next_state = S_IDLE;
            end
        endcase
    end

endmodule