`timescale 1ns/1ps
`default_nettype none

module systolic_wrapper #(
    parameter int N             = 4,
    parameter int DATA_WIDTH    = 32, // FP32 bit patterns
    parameter int BANKING_FACTOR = 1, // How many data elements can be loaded at a time
    parameter int ADDRESS_WIDTH = 13, // Bits in each address
    parameter int MEM_LATENCY   = 2   // Latency in cycles from memory request to valid response
)(
    input  logic clk,
    input  logic rst,

    // To/from control:
    input  logic start_load,
    output logic done_load,
    
    input  logic start_compute,
    output logic done_compute,

    input  logic start_store,
    output logic done_store,


    input  logic [ADDRESS_WIDTH-1:0] base_addr_w,
    input  logic [ADDRESS_WIDTH-1:0] base_addr_x,
    input  logic [ADDRESS_WIDTH-1:0] base_addr_out,

    // To/from memory:
    output logic [ADDRESS_WIDTH-1:0]              mem_req_addr,
    output logic [BANKING_FACTOR*DATA_WIDTH-1:0]  mem_req_data,
    input  logic [BANKING_FACTOR*DATA_WIDTH-1:0]  mem_resp_data,
    output logic                                  mem_read_en,
    output logic                                  mem_write_en
);

    // Helper function for indexing matrices with data stored in row-major order
    function automatic int idx(input int r, input int c);
        return r*N + c;
    endfunction

    // Define useful constants
    localparam int TOTAL_ELEMS    = N*N;
    localparam int BYTES_PER_BEAT = BANKING_FACTOR * (DATA_WIDTH / 8);

    // Local buffer memory for W, X, and output matrices
    logic [DATA_WIDTH-1:0] weight_matrix [N*N-1:0];
    logic [DATA_WIDTH-1:0] x_matrix      [N*N-1:0];
    logic [DATA_WIDTH-1:0] out_matrix    [N*N-1:0];

    // Registers to latch matrix addresses
    logic [ADDRESS_WIDTH-1:0] base_addr_x_reg;
    logic [ADDRESS_WIDTH-1:0] base_addr_w_reg;
    logic [ADDRESS_WIDTH-1:0] base_addr_out_reg;
    
    // Index for load progress (indexes loading beats)
    integer load_idx;

    // Timer for memory fixed latency
    logic [$clog2(MEM_LATENCY+1)-1:0] mem_latency_timer;

    // Data flow to/from systolic array datapath
    logic [DATA_WIDTH-1:0] sys_data_in   [N];
    logic [DATA_WIDTH-1:0] sys_data_out  [N];
    logic [DATA_WIDTH-1:0] sys_weight_in [N];

    // Control signals
    logic                  sys_switch_in;
    logic                  sys_start     [N];
    logic                  sys_valid_out [N];
    logic                  sys_accept_w  [N];

    // Systolic array
    systolic #( .N(N), .DATA_WIDTH(DATA_WIDTH) ) array (
        .clk(clk),
        .rst(rst),

        .sys_data_in(sys_data_in),
        .sys_start(sys_start),
        //.sys_data_out(sys_data_out),
        //.sys_valid_out(sys_valid_out),
        .sys_weight_in(sys_weight_in),
        .sys_accept_w(sys_accept_w),

        .sys_switch_in(sys_switch_in)
    );

    // Manually connect sys_data_out and sys_valid_out arrays
    // Have to do this because Icarus verilog can't handle
    // unpacked arrays in port list
    genvar p;
    generate
        for (p = 0; p < N; p++) begin
            assign sys_data_out[p] = array.sys_data_out[p];
            assign sys_valid_out[p] = array.sys_valid_out[p];
        end
    endgenerate

    // Create enum for FSM states
    typedef enum logic [3:0] {
        S_IDLE, // Idle; wait for start_load signal
        S_LOAD_W_REQ, // Send a request to mem for w element(s)
        S_LOAD_W_WAIT, // Wait for mem response -> write to local buffer
        S_LOAD_X_REQ, // Send a request to mem for x element(s)
        S_LOAD_X_WAIT, // Wait for mem response -> write to local buffer
        S_DONE_LOAD, // Done loading arrays. Wait for start_compute signal
        S_RUN, // Stagger and input factor matrices; start collecting outputs
        S_CAPTURE, // No more elements to input. Collect rest of outputs
        S_DONE_COMPUTE, // Done with computation. Wait for start_store signal.
        S_STORE_REQ,
        S_STORE_WAIT,
        S_DONE // Done with storing results. Pulse done_store status signal.
    } state_t;

    state_t state;

    // Logic for matrix indexing when interacting with datapath
    logic [$clog2(8*N):0] phase_counter;
    integer row_ptr [N];

    // Collect outputs from systolic array when valid out signals asserted
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < N; i++) row_ptr[i] <= 0;
            for (int r = 0; r < N; r++)
                for (int c = 0; c < N; c++)
                    out_matrix[idx(r,c)] <= '0;
        end else begin
            for (int i = 0; i < N; i++) begin
                if (sys_valid_out[i] && row_ptr[i] < N) begin
                    out_matrix[idx(row_ptr[i],i)] <= sys_data_out[i];
                    row_ptr[i] <= row_ptr[i] + 1;
                end
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

            mem_req_addr   <= '0;
            mem_req_data   <= '0;
            mem_read_en    <= 0;
            mem_write_en   <= 0;

            mem_latency_timer <= '0; // Cycles since memory request

            load_idx <= 0;

            done_load <= 0;
            done_compute <= 0;
            done_store <= 0;

            // Reset latched base addresses
            base_addr_x_reg   <= '0;
            base_addr_w_reg   <= '0;
            base_addr_out_reg <= '0;

            // Reset datapath control signals
            for (int i = 0; i < N; i++) begin
                sys_accept_w[i] <= '0;
                sys_start[i] <= '0;
                sys_weight_in[i] <= '0;
                sys_data_in[i] <= '0;
            end
            sys_switch_in <= 0;

            // Reset local matrix buffers
            for (int k = 0; k < N*N; k++) begin
                x_matrix[k] <= '0;
                weight_matrix[k] <= '0;
                out_matrix[k] <= '0;
            end

        end else begin
            // Defaults
            done_load <= 0;
            done_compute <= 0;
            done_store <= 0;

            // Reset datapath control signals
            for (int i = 0; i < N; i++) begin
                sys_accept_w[i] <= '0;
                sys_start[i] <= '0;
                sys_weight_in[i] <= '0;
                sys_data_in[i] <= '0;
            end
            sys_switch_in <= 0;

            mem_req_addr  <= '0;
            mem_req_data  <= '0;
            mem_read_en   <= 0;
            mem_write_en  <= 0;

            case (state)
                S_IDLE: begin
                    if (start_load) begin
                        base_addr_x_reg <= base_addr_x;
                        base_addr_w_reg <= base_addr_w;
                        base_addr_out_reg <= base_addr_out;
                        state <= S_LOAD_W_REQ;
                    end
                end

                S_LOAD_W_REQ: begin
                    mem_req_addr <= base_addr_w_reg + (load_idx * BYTES_PER_BEAT);
                    mem_read_en  <= 1;
                    mem_latency_timer <= '0; // 0 cycles since memory request
                    state <= S_LOAD_W_WAIT;
                end

                S_LOAD_W_WAIT: begin
                    if (mem_latency_timer >= (MEM_LATENCY - 1)) begin
                        // Timer is up - valid response from memory is ready
                        // Write response from memory to W matrix
                        for (int b = 0; b < BANKING_FACTOR; b++) begin
                            int flat_index;
                            flat_index = load_idx * BANKING_FACTOR + b;
                            if (flat_index < TOTAL_ELEMS) begin
                                weight_matrix[flat_index] <= mem_resp_data[b*DATA_WIDTH +: DATA_WIDTH];
                            end
                        end
                        // Done with W?
                        if ((load_idx + 1) * BANKING_FACTOR >= TOTAL_ELEMS) begin
                            load_idx <= '0;
                            state    <= S_LOAD_X_REQ;
                        end else begin
                            load_idx <= load_idx + 1;
                            state    <= S_LOAD_W_REQ;
                        end
                    end else begin
                        mem_latency_timer <= mem_latency_timer + 1;
                    end
                end

                S_LOAD_X_REQ: begin
                    mem_req_addr <= base_addr_x_reg + (load_idx * BYTES_PER_BEAT);
                    mem_read_en  <= 1;
                    mem_latency_timer <= '0;
                    state <= S_LOAD_X_WAIT;
                end

                S_LOAD_X_WAIT: begin
                    if (mem_latency_timer >= (MEM_LATENCY - 1)) begin
                        // Timer is up - valid response from memory is ready
                        for (int b = 0; b < BANKING_FACTOR; b++) begin
                            int flat_index;
                            flat_index = load_idx * BANKING_FACTOR + b;
                            if (flat_index < TOTAL_ELEMS) begin
                                x_matrix[flat_index] <= mem_resp_data[b*DATA_WIDTH +: DATA_WIDTH];
                            end
                        end
                        if ((load_idx + 1) * BANKING_FACTOR >= TOTAL_ELEMS) begin
                            // Next idx > N^2, so we have finished with the X matrix
                            // Move on to next state
                            load_idx <= '0;
                            phase_counter <= '0;
                            state <= S_DONE_LOAD;
                        end else begin
                            load_idx <= load_idx + 1;
                            state    <= S_LOAD_X_REQ;
                        end
                    end else begin
                        mem_latency_timer <= mem_latency_timer + 1;
                    end
                end

                S_DONE_LOAD: begin
                    done_load <= 1'b1;
                    if (start_compute) begin
                        state <= S_RUN;
                    end
                end
                
                S_RUN: begin
                    // Increment phase counter
                    phase_counter <= phase_counter + 1;

                    // Weight pipeline: column-major, reversed along rows
                    for (int i=0; i < N; i++) begin
                        if ((phase_counter >= i) && (phase_counter < (N + i))) begin
                            sys_weight_in[i] <= weight_matrix[idx(i, (N - 1 - (phase_counter - i)))];
                            sys_accept_w[i] <= 1;
                        end else sys_accept_w[i] <= 0;
                    end

                    // Send switch weight signal when last weight of column 1 is loaded
                    if (phase_counter == N-1)
                        sys_switch_in <= 1;
                    else
                        sys_switch_in <= 0;

                    // X input stream: staggered along rows
                    for (int row = 0; row < N; row++) begin
                        int ph;
                        ph = phase_counter - (N + row); // row-dependent delay
                        if (ph >= 0 && ph < N) begin
                            sys_start[row] <= 1;
                            sys_data_in[row] <= x_matrix[idx(ph, row)];
                        end
                    end

                    // Stop when weight and input sequences done
                    if (phase_counter >= 3*N - 2) begin
                        phase_counter <= '0;
                        state         <= S_CAPTURE;
                    end
                end

                S_CAPTURE: begin
                    bit all_done;
                    all_done = 1;
                    for (int i = 0; i < N; i++)
                        all_done &= (row_ptr[i] == N);
                    if (all_done)
                        state <= S_DONE_COMPUTE;
                end

                S_DONE_COMPUTE: begin
                    done_compute <= 1'b1;
                    if (start_store) begin
                        state <= S_STORE_REQ;
                    end
                end

                S_STORE_REQ: begin
                    mem_req_addr <= base_addr_out_reg + (load_idx * BYTES_PER_BEAT);

                    // Put BANKING_FACTOR output elements into mem_req_data
                    for (int b = 0; b < BANKING_FACTOR; b++) begin
                        int flat_index;
                        flat_index = load_idx * BANKING_FACTOR + b;
                        if (flat_index < TOTAL_ELEMS)
                            mem_req_data[b*DATA_WIDTH +: DATA_WIDTH] <= out_matrix[flat_index];
                        else
                            mem_req_data[b*DATA_WIDTH +: DATA_WIDTH] <= '0;
                    end

                    mem_write_en <= 1;

                    mem_latency_timer <= '0;
                    state <= S_STORE_WAIT;
                end

                S_STORE_WAIT: begin
                    if (mem_latency_timer >= (MEM_LATENCY - 1)) begin
                        if ((load_idx + 1) * BANKING_FACTOR >= TOTAL_ELEMS) begin
                            state <= S_DONE;
                        end else begin
                            load_idx <= load_idx + 1;
                            state    <= S_STORE_REQ;
                        end
                    end else begin
                        mem_latency_timer <= mem_latency_timer + 1;
                    end
                end

                S_DONE: begin
                    done_store <= 1;
                    state <= S_IDLE;
                end

            endcase
        end
    end
endmodule
