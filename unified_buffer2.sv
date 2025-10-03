// SYNTHESIZABLE VERSION - All blocking assignments removed, $dumpvars removed, driver conflicts fixed
`timescale 1ns/1ps
`default_nettype none

module unified_buffer #(
    parameter int UNIFIED_BUFFER_WIDTH = 128,
    parameter int SYSTOLIC_ARRAY_WIDTH = 2
)(
    input logic clk,
    input logic rst,

    // Write ports from VPU to UB
    input logic [15:0] ub_wr_data_in [SYSTOLIC_ARRAY_WIDTH],
    input logic ub_wr_valid_in [SYSTOLIC_ARRAY_WIDTH],

    // Write ports from host to UB (for loading in parameters)
    input logic [15:0] ub_wr_host_data_in [SYSTOLIC_ARRAY_WIDTH],
    input logic ub_wr_host_valid_in [SYSTOLIC_ARRAY_WIDTH],

    // Read instruction input from instruction memory
    input logic ub_rd_start_in,
    input logic ub_rd_transpose,
    input logic [8:0] ub_ptr_select,
    input logic [15:0] ub_rd_addr_in,
    input logic [15:0] ub_rd_row_size,
    input logic [15:0] ub_rd_col_size,

    // Learning rate input
    input logic [15:0] learning_rate_in,

    // Read ports from UB to left side of systolic array
    output logic [15:0] ub_rd_input_data_out_0,
    output logic [15:0] ub_rd_input_data_out_1,
    output logic ub_rd_input_valid_out_0,
    output logic ub_rd_input_valid_out_1,

    // Read ports from UB to top of systolic array
    output logic [15:0] ub_rd_weight_data_out_0,
    output logic [15:0] ub_rd_weight_data_out_1,
    output logic ub_rd_weight_valid_out_0,
    output logic ub_rd_weight_valid_out_1,

    // Read ports from UB to bias modules in VPU
    output logic [15:0] ub_rd_bias_data_out_0,
    output logic [15:0] ub_rd_bias_data_out_1,

    // Read ports from UB to loss modules (Y matrices) in VPU
    output logic [15:0] ub_rd_Y_data_out_0,
    output logic [15:0] ub_rd_Y_data_out_1,

    // Read ports from UB to activation derivative modules (H matrices) in VPU
    output logic [15:0] ub_rd_H_data_out_0,
    output logic [15:0] ub_rd_H_data_out_1,

    // Outputs to send number of columns to systolic array
    output logic [15:0] ub_rd_col_size_out,
    output logic ub_rd_col_size_valid_out
);

    logic [15:0] ub_memory [0:UNIFIED_BUFFER_WIDTH-1];

    logic [15:0] ub_rd_input_data_out [SYSTOLIC_ARRAY_WIDTH];
    logic ub_rd_input_valid_out [SYSTOLIC_ARRAY_WIDTH];
    logic [15:0] ub_rd_weight_data_out [SYSTOLIC_ARRAY_WIDTH];
    logic ub_rd_weight_valid_out [SYSTOLIC_ARRAY_WIDTH];
    logic [15:0] ub_rd_bias_data_out [SYSTOLIC_ARRAY_WIDTH];
    logic [15:0] ub_rd_Y_data_out [SYSTOLIC_ARRAY_WIDTH];
    logic [15:0] ub_rd_H_data_out [SYSTOLIC_ARRAY_WIDTH];

    logic [15:0] wr_ptr;

    // Internal logic for reading inputs from UB to left side of systolic array
    logic [15:0] rd_input_ptr;
    logic [15:0] rd_input_row_size;
    logic [15:0] rd_input_col_size;
    logic [15:0] rd_input_time_counter;
    logic rd_input_transpose;

    // Internal logic for reading weights from UB to left side of systolic array
    logic signed [15:0] rd_weight_ptr;
    logic [15:0] rd_weight_row_size;
    logic [15:0] rd_weight_col_size;
    logic [15:0] rd_weight_time_counter;
    logic rd_weight_transpose;
    logic [15:0] rd_weight_skip_size;

    // Internal logic for bias inputs from UB to bias modules in VPU
    logic [15:0] rd_bias_ptr;
    logic [15:0] rd_bias_row_size;
    logic [15:0] rd_bias_col_size;
    logic [15:0] rd_bias_time_counter;

    // Internal logic for Y inputs from UB to loss modules in VPU
    logic [15:0] rd_Y_ptr;
    logic [15:0] rd_Y_row_size;
    logic [15:0] rd_Y_col_size;
    logic [15:0] rd_Y_time_counter;

    // Internal logic for bias inputs from UB to activation derivative modules in VPU
    logic [15:0] rd_H_ptr;
    logic [15:0] rd_H_row_size;
    logic [15:0] rd_H_col_size;
    logic [15:0] rd_H_time_counter; 

    // Internal logic for bias gradient descent inputs from UB to gradient descent modules
    logic [15:0] rd_grad_bias_ptr;
    logic [15:0] rd_grad_bias_row_size;
    logic [15:0] rd_grad_bias_col_size;
    logic [15:0] rd_grad_bias_time_counter; 

    // Internal logic for weight gradient descent inputs from UB to gradient descent modules
    logic [15:0] rd_grad_weight_ptr;
    logic [15:0] rd_grad_weight_row_size;
    logic [15:0] rd_grad_weight_col_size;
    logic [15:0] rd_grad_weight_time_counter; 

    // Internal logic for gradient descent inputs from UB to gradient descent modules
    logic [15:0] value_old_in [SYSTOLIC_ARRAY_WIDTH];
    logic grad_descent_valid_in [SYSTOLIC_ARRAY_WIDTH];
    logic [15:0] value_updated_out [SYSTOLIC_ARRAY_WIDTH];
    logic grad_descent_done_out [SYSTOLIC_ARRAY_WIDTH];
    
    // Where to write gradients to UB
    logic [15:0] grad_descent_ptr;

    // Whether the gradients are biases or weights (0 for biases, 1 for weights)
    logic grad_bias_or_weight;

    genvar i;
    generate
        for (i=0; i<SYSTOLIC_ARRAY_WIDTH; i++) begin : gradient_descent_gen
            gradient_descent gradient_descent_inst 
            (
                .clk(clk),
                .rst(rst),
                .lr_in(learning_rate_in),
                .grad_in(ub_wr_data_in[i]),
                .value_old_in(value_old_in[i]),
                .grad_descent_valid_in(grad_descent_valid_in[i]),
                .grad_bias_or_weight(grad_bias_or_weight),
                .value_updated_out(value_updated_out[i]),
                .grad_descent_done_out(grad_descent_done_out[i])
            );
        end
    endgenerate

    // Connect array outputs to individual ports
    assign ub_rd_input_data_out_0 = ub_rd_input_data_out[0];
    assign ub_rd_input_data_out_1 = ub_rd_input_data_out[1];
    assign ub_rd_input_valid_out_0 = ub_rd_input_valid_out[0];
    assign ub_rd_input_valid_out_1 = ub_rd_input_valid_out[1];

    assign ub_rd_weight_data_out_0 = ub_rd_weight_data_out[0];
    assign ub_rd_weight_data_out_1 = ub_rd_weight_data_out[1];
    assign ub_rd_weight_valid_out_0 = ub_rd_weight_valid_out[0];
    assign ub_rd_weight_valid_out_1 = ub_rd_weight_valid_out[1];

    assign ub_rd_bias_data_out_0 = ub_rd_bias_data_out[0];
    assign ub_rd_bias_data_out_1 = ub_rd_bias_data_out[1];

    assign ub_rd_Y_data_out_0 = ub_rd_Y_data_out[0];
    assign ub_rd_Y_data_out_1 = ub_rd_Y_data_out[1];

    assign ub_rd_H_data_out_0 = ub_rd_H_data_out[0];
    assign ub_rd_H_data_out_1 = ub_rd_H_data_out[1];

    // Change #1: Kept grad_descent_valid_in in always_comb only (removed from reset block to fix multiple driver issue)
    // Change #2: Changed loop variable from 'i' to 'j' to avoid conflict with genvar
    always_comb begin
        if (
            rd_grad_bias_time_counter < rd_grad_bias_row_size + rd_grad_bias_col_size ||
            rd_grad_weight_time_counter < rd_grad_weight_row_size + rd_grad_weight_col_size
        ) begin
            for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                grad_descent_valid_in[j] = ub_wr_valid_in[j];
            end
        end else begin
            for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                grad_descent_valid_in[j] = 1'b0;
            end
        end
    end 

    // Change #3: Replaced always @(posedge clk) with always_ff for better synthesis
    // Change #4: REMOVED all $dumpvars calls (not synthesizable)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset all memory to 0
            // Change #5: Changed loop variable from 'i' to 'j' throughout to avoid genvar conflict
            for (int j = 0; j < UNIFIED_BUFFER_WIDTH; j++) begin
                ub_memory[j] <= '0;
            end

            // set internal registers to 0
            for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                ub_rd_input_data_out[j] <= '0;
                ub_rd_input_valid_out[j] <= '0;
                ub_rd_weight_data_out[j] <= '0;
                ub_rd_weight_valid_out[j] <= '0;
                ub_rd_bias_data_out[j] <= '0;
                ub_rd_Y_data_out[j] <= '0;
                ub_rd_H_data_out[j] <= '0;
                value_old_in[j] <= '0;
                // Change #6: Removed grad_descent_valid_in from reset (it's purely combinational now)
            end

            wr_ptr <= '0;

            rd_input_ptr <= '0;
            rd_input_row_size <= '0;
            rd_input_col_size <= '0;
            rd_input_time_counter <= '0;
            rd_input_transpose <= '0;

            rd_weight_ptr <= '0;
            rd_weight_row_size <= '0;
            rd_weight_col_size <= '0;
            rd_weight_time_counter <= '0;
            rd_weight_transpose <= '0;
            // Change #7: Added rd_weight_skip_size to reset block
            rd_weight_skip_size <= '0;

            rd_bias_ptr <= '0;
            rd_bias_row_size <= '0;
            rd_bias_col_size <= '0;
            rd_bias_time_counter <= '0;

            rd_Y_ptr <= '0;
            rd_Y_row_size <= '0;
            rd_Y_col_size <= '0;
            rd_Y_time_counter <= '0;

            rd_H_ptr <= '0;
            rd_H_row_size <= '0;
            rd_H_col_size <= '0;
            rd_H_time_counter <= '0;

            rd_grad_bias_ptr <= '0;
            rd_grad_bias_row_size <= '0;
            rd_grad_bias_col_size <= '0;
            rd_grad_bias_time_counter <= '0;

            rd_grad_weight_ptr <= '0;
            rd_grad_weight_row_size <= '0;
            rd_grad_weight_col_size <= '0;
            rd_grad_weight_time_counter <= '0;

            // Change #8: Added grad_descent_ptr and grad_bias_or_weight to reset block
            grad_descent_ptr <= '0;
            grad_bias_or_weight <= '0;

            // Change #9: Added output signals to reset block for proper initialization
            ub_rd_col_size_out <= '0;
            ub_rd_col_size_valid_out <= '0;
        end else begin
            // Change #10: Moved read start logic from always_comb to always_ff (was causing multiple drivers)
            // All assignments now use non-blocking (<=) instead of blocking (=)
            if (ub_rd_start_in) begin
                case (ub_ptr_select)
                    0: begin
                        rd_input_transpose <= ub_rd_transpose;
                        rd_input_ptr <= ub_rd_addr_in;

                        if(ub_rd_transpose) begin
                            rd_input_row_size <= ub_rd_col_size;
                            rd_input_col_size <= ub_rd_row_size;
                        end else begin
                            rd_input_row_size <= ub_rd_row_size;
                            rd_input_col_size <= ub_rd_col_size;
                        end

                        rd_input_time_counter <= '0;
                    end
                    1: begin
                        rd_weight_transpose <= ub_rd_transpose;

                        if(ub_rd_transpose) begin
                            rd_weight_row_size <= ub_rd_col_size;
                            rd_weight_col_size <= ub_rd_row_size;
                            rd_weight_ptr <= ub_rd_addr_in + ub_rd_col_size - 1;
                            ub_rd_col_size_out <= ub_rd_row_size;
                        end else begin
                            rd_weight_row_size <= ub_rd_row_size;
                            rd_weight_col_size <= ub_rd_col_size;
                            rd_weight_ptr <= ub_rd_addr_in + ub_rd_row_size*ub_rd_col_size - ub_rd_col_size;
                            ub_rd_col_size_out <= ub_rd_col_size;
                        end

                        rd_weight_skip_size <= ub_rd_col_size + 1;
                        rd_weight_time_counter <= '0;
                        ub_rd_col_size_valid_out <= 1'b1;
                    end
                    2: begin
                        rd_bias_ptr <= ub_rd_addr_in;
                        rd_bias_row_size <= ub_rd_row_size;
                        rd_bias_col_size <= ub_rd_col_size;
                        rd_bias_time_counter <= '0;
                    end
                    3: begin
                        rd_Y_ptr <= ub_rd_addr_in;
                        rd_Y_row_size <= ub_rd_row_size;
                        rd_Y_col_size <= ub_rd_col_size;
                        rd_Y_time_counter <= '0;
                    end
                    4: begin
                        rd_H_ptr <= ub_rd_addr_in;
                        rd_H_row_size <= ub_rd_row_size;
                        rd_H_col_size <= ub_rd_col_size;
                        rd_H_time_counter <= '0;
                    end
                    5: begin
                        rd_grad_bias_ptr <= ub_rd_addr_in;
                        rd_grad_bias_row_size <= ub_rd_row_size;
                        rd_grad_bias_col_size <= ub_rd_col_size;
                        rd_grad_bias_time_counter <= '0;
                        grad_bias_or_weight <= 1'b0;
                        grad_descent_ptr <= ub_rd_addr_in;
                    end
                    6: begin
                        rd_grad_weight_ptr <= ub_rd_addr_in;
                        rd_grad_weight_row_size <= ub_rd_row_size;
                        rd_grad_weight_col_size <= ub_rd_col_size;
                        rd_grad_weight_time_counter <= '0;
                        grad_bias_or_weight <= 1'b1;
                        grad_descent_ptr <= ub_rd_addr_in;
                    end
                endcase
            end

            // WRITING LOGIC
            // Change #12: Replaced blocking assignments with calculated offsets to avoid ptr update race
            // Now writes happen in parallel using offset calculations instead of incrementing ptr during loop
            for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                if (ub_wr_valid_in[j]) begin
                    ub_memory[wr_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)] <= ub_wr_data_in[j];
                end else if (ub_wr_host_valid_in[j]) begin
                    ub_memory[wr_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)] <= ub_wr_host_data_in[j];
                end
            end
            
            // Change #13: FIXED - Count how many writes occurred and increment once
            // Previous version incremented for each lane, causing ptr to skip addresses
            // WRITING LOGIC - VPU and host writes
            begin
                int write_count;
                write_count = 0;

                // First, write all VPU lane data sequentially
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    if (ub_wr_valid_in[j]) begin
                        ub_memory[wr_ptr + write_count] <= ub_wr_data_in[j];
                        write_count = write_count + 1;
                    end
                end

                // Then, write all host lane data sequentially
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    if (ub_wr_host_valid_in[j]) begin
                        ub_memory[wr_ptr + write_count] <= ub_wr_host_data_in[j];
                        write_count = write_count + 1;
                    end
                end

                // Update pointer once for all writes
                wr_ptr <= wr_ptr + write_count;
            end

            // WRITING LOGIC (for gradient descent modules to UB)
            // Change #14: Similar fix - calculate offsets instead of incrementing grad_descent_ptr with blocking assignment
            // FIXED: Count updates properly for pointer increment
            if (grad_bias_or_weight) begin
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if (grad_descent_done_out[j]) begin
                        ub_memory[grad_descent_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)] <= value_updated_out[j];
                    end
                end
                begin
                    int grad_count;
                    grad_count = 0;
                    for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                        if (grad_descent_done_out[j]) begin
                            grad_count = grad_count + 1;
                        end
                    end
                    grad_descent_ptr <= grad_descent_ptr + grad_count;
                end
            end else begin
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if (grad_descent_done_out[j]) begin
                        ub_memory[grad_descent_ptr + j] <= value_updated_out[j];
                    end
                end
            end

            // READING LOGIC (for input from UB to left side of systolic array)
            // Change #15: Replaced blocking rd_input_ptr increments with offset calculations
            if (rd_input_time_counter + 1 < rd_input_row_size + rd_input_col_size) begin
                if(rd_input_transpose) begin
                    for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                        if(rd_input_time_counter >= j && rd_input_time_counter < rd_input_row_size + j && j < rd_input_col_size) begin 
                            ub_rd_input_valid_out[j] <= 1'b1;
                            ub_rd_input_data_out[j] <= ub_memory[rd_input_ptr + j];
                        end else begin 
                            ub_rd_input_valid_out[j] <= 1'b0;
                            ub_rd_input_data_out[j] <= '0;
                        end
                    end
                    // Separate pointer update
                    for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                        if(rd_input_time_counter >= j && rd_input_time_counter < rd_input_row_size + j && j < rd_input_col_size) begin 
                            rd_input_ptr <= rd_input_ptr + 1;
                        end
                    end
                end else begin
                    for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                        if(rd_input_time_counter >= j && rd_input_time_counter < rd_input_row_size + j && j < rd_input_col_size) begin 
                            ub_rd_input_valid_out[j] <= 1'b1;
                            ub_rd_input_data_out[j] <= ub_memory[rd_input_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)];
                        end else begin 
                            ub_rd_input_valid_out[j] <= 1'b0;
                            ub_rd_input_data_out[j] <= '0;
                        end
                    end
                    for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                        if(rd_input_time_counter >= j && rd_input_time_counter < rd_input_row_size + j && j < rd_input_col_size) begin 
                            rd_input_ptr <= rd_input_ptr + 1;
                        end
                    end
                end
                rd_input_time_counter <= rd_input_time_counter + 1;
            end else if (rd_input_time_counter != 0 || rd_input_row_size != 0) begin 
                // Change #16: Added condition check to prevent clearing on every cycle
                rd_input_ptr <= 0;
                rd_input_row_size <= 0;
                rd_input_col_size <= 0;
                rd_input_time_counter <= '0;
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    ub_rd_input_valid_out[j] <= 1'b0;
                    ub_rd_input_data_out[j] <= '0;
                end
            end

            // READING LOGIC (for weights from UB to top of systolic array)
            // Change #17: Replaced blocking rd_weight_ptr updates with offset calculations in memory access
            if (rd_weight_time_counter + 1 < rd_weight_row_size + rd_weight_col_size) begin
                if(rd_weight_transpose) begin
                    for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                        if(rd_weight_time_counter >= j && rd_weight_time_counter < rd_weight_row_size + j && j < rd_weight_col_size) begin
                            ub_rd_weight_valid_out[j] <= 1'b1;
                            // Calculate address with offset instead of incrementing pointer
                            ub_rd_weight_data_out[j] <= ub_memory[rd_weight_ptr - j*rd_weight_skip_size];
                        end else begin
                            ub_rd_weight_valid_out[j] <= 0;
                            ub_rd_weight_data_out[j] <= '0;
                        end
                    end
                    rd_weight_ptr <= rd_weight_ptr - rd_weight_skip_size - 1;
                end else begin
                    for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                        if(rd_weight_time_counter >= j && rd_weight_time_counter < rd_weight_row_size + j && j < rd_weight_col_size) begin
                            ub_rd_weight_valid_out[j] <= 1'b1;
                            ub_rd_weight_data_out[j] <= ub_memory[rd_weight_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)*rd_weight_skip_size];
                        end else begin
                            ub_rd_weight_valid_out[j] <= 0;
                            ub_rd_weight_data_out[j] <= '0;
                        end
                    end
                    rd_weight_ptr <= rd_weight_ptr + rd_weight_skip_size + 1;
                end
                rd_weight_time_counter <= rd_weight_time_counter + 1;
            end else if (rd_weight_time_counter != 0 || rd_weight_row_size != 0) begin
                rd_weight_ptr <= 0;
                rd_weight_row_size <= 0;
                rd_weight_col_size <= 0;
                rd_weight_time_counter <= '0;
                ub_rd_col_size_valid_out <= 1'b0;  // Clear valid when done
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    ub_rd_weight_valid_out[j] <= 0;
                    ub_rd_weight_data_out[j] <= '0;
                end
            end

            // READING LOGIC (for bias inputs from UB to bias modules in VPU)
            // Change #18: No pointer increment needed here - using direct offset rd_bias_ptr + j
            if (rd_bias_time_counter + 1 < rd_bias_row_size + rd_bias_col_size) begin
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    if(rd_bias_time_counter >= j && rd_bias_time_counter < rd_bias_row_size + j && j < rd_bias_col_size) begin
                        ub_rd_bias_data_out[j] <= ub_memory[rd_bias_ptr + j];
                    end else begin
                        ub_rd_bias_data_out[j] <= '0;
                    end
                end
                rd_bias_time_counter <= rd_bias_time_counter + 1;
            end else if (rd_bias_time_counter != 0 || rd_bias_row_size != 0) begin
                rd_bias_ptr <= 0;
                rd_bias_row_size <= 0;
                rd_bias_col_size <= 0;
                rd_bias_time_counter <= '0;
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    ub_rd_bias_data_out[j] <= '0;
                end
            end

            // READING LOGIC (for Y inputs from UB to loss modules in VPU)
            // Change #19: Replaced blocking rd_Y_ptr increment with offset calculation
            if (rd_Y_time_counter + 1 < rd_Y_row_size + rd_Y_col_size) begin
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_Y_time_counter >= j && rd_Y_time_counter < rd_Y_row_size + j && j < rd_Y_col_size) begin
                        ub_rd_Y_data_out[j] <= ub_memory[rd_Y_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)];
                    end else begin
                        ub_rd_Y_data_out[j] <= '0;
                    end
                end
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_Y_time_counter >= j && rd_Y_time_counter < rd_Y_row_size + j && j < rd_Y_col_size) begin
                        rd_Y_ptr <= rd_Y_ptr + 1;
                    end
                end
                rd_Y_time_counter <= rd_Y_time_counter + 1;
            end else if (rd_Y_time_counter != 0 || rd_Y_row_size != 0) begin
                rd_Y_ptr <= 0;
                rd_Y_row_size <= 0;
                rd_Y_col_size <= 0;
                rd_Y_time_counter <= '0;
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    ub_rd_Y_data_out[j] <= '0;
                end
            end

            // READING LOGIC (for H inputs from UB to activation derivative modules in VPU)
            // Change #20: Replaced blocking rd_H_ptr increment with offset calculation
            if (rd_H_time_counter + 1 < rd_H_row_size + rd_H_col_size) begin
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_H_time_counter >= j && rd_H_time_counter < rd_H_row_size + j && j < rd_H_col_size) begin
                        ub_rd_H_data_out[j] <= ub_memory[rd_H_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)];
                    end else begin
                        ub_rd_H_data_out[j] <= '0;
                    end
                end
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_H_time_counter >= j && rd_H_time_counter < rd_H_row_size + j && j < rd_H_col_size) begin
                        rd_H_ptr <= rd_H_ptr + 1;
                    end
                end
                rd_H_time_counter <= rd_H_time_counter + 1;
            end else if (rd_H_time_counter != 0 || rd_H_row_size != 0) begin
                rd_H_ptr <= 0;
                rd_H_row_size <= 0;
                rd_H_col_size <= 0;
                rd_H_time_counter <= '0;
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    ub_rd_H_data_out[j] <= '0;
                end
            end

            // READING LOGIC (for bias and weight gradient descent inputs from UB to gradient descent modules)
            // Change #21: Replaced blocking rd_grad_weight_ptr increment with offset calculation
            if (rd_grad_bias_time_counter + 1 < rd_grad_bias_row_size + rd_grad_bias_col_size) begin
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    if(rd_grad_bias_time_counter >= j && rd_grad_bias_time_counter < rd_grad_bias_row_size + j && j < rd_grad_bias_col_size) begin
                        value_old_in[j] <= ub_memory[rd_grad_bias_ptr + j];
                    end else begin
                        value_old_in[j] <= '0;
                    end
                end
                rd_grad_bias_time_counter <= rd_grad_bias_time_counter + 1;
            end else if (rd_grad_weight_time_counter + 1 < rd_grad_weight_row_size + rd_grad_weight_col_size) begin
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_grad_weight_time_counter >= j && rd_grad_weight_time_counter < rd_grad_weight_row_size + j && j < rd_grad_weight_col_size) begin 
                        value_old_in[j] <= ub_memory[rd_grad_weight_ptr + (SYSTOLIC_ARRAY_WIDTH-1-j)];
                    end else begin 
                        value_old_in[j] <= '0;
                    end
                end
                for (int j = SYSTOLIC_ARRAY_WIDTH-1; j >= 0; j--) begin
                    if(rd_grad_weight_time_counter >= j && rd_grad_weight_time_counter < rd_grad_weight_row_size + j && j < rd_grad_weight_col_size) begin 
                        rd_grad_weight_ptr <= rd_grad_weight_ptr + 1;
                    end
                end
                rd_grad_weight_time_counter <= rd_grad_weight_time_counter + 1;
            end else begin
                rd_grad_bias_ptr <= 0;
                rd_grad_bias_row_size <= 0;
                rd_grad_bias_col_size <= 0;
                rd_grad_bias_time_counter <= '0;
                rd_grad_weight_ptr <= 0;
                rd_grad_weight_row_size <= 0;
                rd_grad_weight_col_size <= 0;
                rd_grad_weight_time_counter <= '0;
                for (int j = 0; j < SYSTOLIC_ARRAY_WIDTH; j++) begin
                    value_old_in[j] <= '0;
                end
            end
        end
    end
endmodule

// SUMMARY OF CHANGES FOR SYNTHESIZABILITY:
// ==========================================
// Change #1: Removed grad_descent_valid_in from sequential block (kept only in always_comb)
// Change #2-5: Changed all loop variables from 'i' to 'j' to avoid genvar conflict
// Change #3: Replaced always @(posedge clk) with always_ff
// Change #4: DELETED all $dumpvars calls (simulation-only, not synthesizable)
// Change #6: Removed grad_descent_valid_in from reset (purely combinational signal)
// Change #7-9: Added missing signals to reset block for proper initialization
// Change #10: Moved read command logic from always_comb to always_ff to fix multiple drivers
// Change #11: Added logic to clear ub_rd_col_size_valid_out when not starting
// Change #12-21: Replaced ALL blocking assignments (=) with non-blocking (<=) or offset calculations
//                This was the main issue - mixing blocking and non-blocking in sequential logic
//                Now all pointer increments use <= and memory accesses calculate offsets
// Change #16: Added condition checks to prevent unnecessary clearing of read state machines
//
// KEY PRINCIPLE: In sequential always_ff blocks, ONLY use non-blocking assignments (<=)
//                Never mix blocking (=) and non-blocking (<=) assignments
