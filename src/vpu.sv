`timescale 1ns/1ps
`default_nettype none

// three data pathways:
// (forward pass hidden layer computations) input from sys --> bias --> leaky relu --> output
// (transition) input from sys --> bias --> leaky relu --> loss --> leaky relu derivative --> output
// (backward pass) input from sys --> leaky relu derivative --> output
// during the transition pathway we need to store the H matrices that come out of the leaky relu modules AND pass them to the loss modules

/* 
|bias control bit| |lr control bit| |loss control bit| |lr_d control bit|

0000: activate no modules
1100: forward pass pathway (sys --> bias --> leaky relu --> output)
1111: transistion pathway (sys --> bias --> leaky relu --> loss --> leaky relu derivative --> output)
0001: backward pass pathway (sys --> leaky relu derivative --> output)
*/

module vpu (
    input logic clk,
    input logic rst,

    input logic [3:0] vpu_data_pathway, // 4-bits to signify which modules to route the inputs to (1 bit for each module)

    // Inputs from systolic array
    input logic signed [15:0] vpu_data_in_1,
    input logic signed [15:0] vpu_data_in_2,
    input logic vpu_valid_in_1,
    input logic vpu_valid_in_2,

    // Inputs from UB
    input logic signed [15:0] bias_scalar_in_1,             // For bias modules
    input logic signed [15:0] bias_scalar_in_2,             // For bias modules
    input logic signed [15:0] lr_leak_factor_in,            // For leaky relu modules
    input logic signed [15:0] Y_in_1,                       // For loss modules
    input logic signed [15:0] Y_in_2,                       // For loss modules
    input logic signed [15:0] inv_batch_size_times_two_in,  // For loss modules
    input logic signed [15:0] H_in_1,                       // For leaky relu derivative modules
    input logic signed [15:0] H_in_2,                       // For leaky relu derivative modules 

    // Outputs to UB
    output logic signed [15:0] vpu_data_out_1,
    output logic signed [15:0] vpu_data_out_2,
    output logic vpu_valid_out_1,
    output logic vpu_valid_out_2
);

    // bias
    logic [15:0] bias_data_1_in; 
    logic bias_valid_1_in;
    logic [15:0] bias_data_2_in;
    logic bias_valid_2_in;
    logic [15:0] bias_z_data_out_1;
    logic bias_valid_1_out;
    logic [15:0] bias_z_data_out_2;
    logic bias_valid_2_out;

    // bias to lr intermediate values
    logic [15:0] b_to_lr_data_in_1;
    logic b_to_lr_valid_in_1;
    logic [15:0] b_to_lr_data_in_2;
    logic b_to_lr_valid_in_2;

    // lr
    logic [15:0] lr_data_1_in; 
    logic lr_valid_1_in;
    logic [15:0] lr_data_2_in;
    logic lr_valid_2_in;
    logic [15:0] lr_data_1_out;
    logic lr_valid_1_out;
    logic [15:0] lr_data_2_out;
    logic lr_valid_2_out;

    // lr to loss intermediate values
    logic [15:0] lr_to_loss_data_in_1;
    logic lr_to_loss_valid_in_1;
    logic [15:0] lr_to_loss_data_in_2;
    logic lr_to_loss_valid_in_2;

    // loss
    logic [15:0] loss_data_1_in; 
    logic loss_valid_1_in;
    logic [15:0] loss_data_2_in;
    logic loss_valid_2_in;
    logic [15:0] loss_data_1_out;
    logic loss_valid_1_out;
    logic [15:0] loss_data_2_out;
    logic loss_valid_2_out;

    // loss to lrd intermediate values
    logic [15:0] loss_to_lrd_data_in_1;
    logic loss_to_lrd_valid_in_1;
    logic [15:0] loss_to_lrd_data_in_2;
    logic loss_to_lrd_valid_in_2;

    // lr_d
    logic [15:0] lr_d_data_1_in; 
    logic lr_d_valid_1_in;
    logic [15:0] lr_d_data_2_in;
    logic lr_d_valid_2_in;
    logic [15:0] lr_d_data_1_out;
    logic lr_d_valid_1_out;
    logic [15:0] lr_d_data_2_out;
    logic lr_d_valid_2_out;
    logic [15:0] lr_d_H_in_1;
    logic [15:0] lr_d_H_in_2;
    

    // temp 'last H matrix' cache
    logic [15:0] last_H_data_1_in;
    logic [15:0] last_H_data_2_in;
    logic [15:0] last_H_data_1_out;
    logic [15:0] last_H_data_2_out;

    // rows (batch elements) per column/neuron, output neurons
    parameter int B      = 4; 
    parameter int D_OUT  = 2;

    // per-lane counters (you have two lanes: *_1 and *_2)
    logic [$clog2(B    )-1:0] row_ctr_1, row_ctr_2;
    logic [$clog2(D_OUT)-1:0] col_ctr_1, col_ctr_2;

    // valid that represents entering the bias stage from sys array
    logic sa_to_bias_valid_1, sa_to_bias_valid_2;

    // Column (neuron) boundary pulses
    logic column_start_1, column_start_2;

    // Bias load enables (one-cycle pulses)
    logic bias_load_en_1, bias_load_en_2; // two bias child instances

    assign sa_to_bias_valid_1 = vpu_data_pathway[3] ? vpu_valid_in_1 : 1'b0;
    assign sa_to_bias_valid_2 = vpu_data_pathway[3] ? vpu_valid_in_2 : 1'b0;

    // row/column counters to detect the start of each neuron column
    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        row_ctr_1 <= '0;  col_ctr_1 <= '0;
        row_ctr_2 <= '0;  col_ctr_2 <= '0;
    end else begin
        if (sa_to_bias_valid_1) begin
        if (row_ctr_1 == B-1) begin
            row_ctr_1 <= '0;
            col_ctr_1 <= (col_ctr_1 == D_OUT-1) ? '0 : col_ctr_1 + 1'b1;
        end else begin
            row_ctr_1 <= row_ctr_1 + 1'b1;
        end
        end

        // Lane 2
        if (sa_to_bias_valid_2) begin
        if (row_ctr_2 == B-1) begin
            row_ctr_2 <= '0;
            col_ctr_2 <= (col_ctr_2 == D_OUT-1) ? '0 : col_ctr_2 + 1'b1;
        end else begin
            row_ctr_2 <= row_ctr_2 + 1'b1;
        end
        end
    end
    end

    assign column_start_1 = sa_to_bias_valid_1 && (row_ctr_1 == '0);
    assign column_start_2 = sa_to_bias_valid_2 && (row_ctr_2 == '0);

    assign bias_load_en_1 = column_start_1;
    assign bias_load_en_2 = column_start_2;


    bias_parent bias_parent_inst (  
        .clk               ( clk ),
        .rst               ( rst ),

        // stream from SA
        .bias_sys_data_in_1( bias_data_1_in ),
        .bias_sys_data_in_2( bias_data_2_in ),
        .bias_sys_valid_in_1( bias_valid_1_in ),
        .bias_sys_valid_in_2( bias_valid_2_in ),

        // UB bias + load enables (NEW/renamed)
        .bias_scalar_ub_in_1( bias_scalar_in_1 ),
        .bias_scalar_ub_in_2( bias_scalar_in_2 ),
        .bias_load_en_1     ( bias_load_en_1 ),
        .bias_load_en_2     ( bias_load_en_2 ),

        // outputs
        .bias_Z_valid_out_1 ( bias_valid_1_out ),
        .bias_Z_valid_out_2 ( bias_valid_2_out ),
        .bias_z_data_out_1  ( bias_z_data_out_1 ),
        .bias_z_data_out_2  ( bias_z_data_out_2 )
    );


    leaky_relu_parent leaky_relu_parent_inst (
        .clk(clk),
        .rst(rst),

        .lr_data_1_in(lr_data_1_in),                // input
        .lr_data_2_in(lr_data_2_in),                // input
        .lr_valid_1_in(lr_valid_1_in),              // input
        .lr_valid_2_in(lr_valid_2_in),              // input

        .lr_leak_factor_in(lr_leak_factor_in),      // input from UB
        
        .lr_data_1_out(lr_data_1_out),              // output 
        .lr_data_2_out(lr_data_2_out),              // output
        .lr_valid_1_out(lr_valid_1_out),            // output
        .lr_valid_2_out(lr_valid_2_out)             // output
    );

    loss_parent loss_parent_inst ( // TODO: THIS SHOULD BE RENAMED TO LOSS DERIVATIVE MODULE. WE DONT HAVE A MODULE TO COMPUTE THE LOSS
        .clk(clk),
        .rst(rst),
        .H_1_in(loss_data_1_in),        // input
        .H_2_in(loss_data_2_in),        // input
        .valid_1_in(loss_valid_1_in),   // input
        .valid_2_in(loss_valid_2_in),   // input

        .Y_1_in(Y_in_1),                // input from UB
        .Y_2_in(Y_in_2),                // input from UB
        .inv_batch_size_times_two_in(inv_batch_size_times_two_in),

        .gradient_1_out(loss_data_1_out), // output
        .gradient_2_out(loss_data_2_out), // output
        .valid_1_out(loss_valid_1_out),
        .valid_2_out(loss_valid_2_out)
    );

    leaky_relu_derivative_parent leaky_relu_derivative_parent_inst (
        .clk(clk),
        .rst(rst),
        .lr_d_data_1_in(lr_d_data_1_in),    // input
        .lr_d_data_2_in(lr_d_data_2_in),    // input
        .lr_d_valid_1_in(lr_d_valid_1_in),  // input
        .lr_d_valid_2_in(lr_d_valid_2_in),  // input
         
         // TODO - change this variable from leaky relu parent for consistency
        .lr_d_H_1_in(lr_d_H_in_1),              // input from UB or temp 'last H matrix' cache
        .lr_d_H_2_in(lr_d_H_in_2),              // input from UB or temp 'last H matrix' cache
        .lr_leak_factor_in(lr_leak_factor_in),
        
        .lr_d_data_1_out(lr_d_data_1_out),      // output
        .lr_d_data_2_out(lr_d_data_2_out),      // output
        .lr_d_valid_1_out(lr_d_valid_1_out),    // output
        .lr_d_valid_2_out(lr_d_valid_2_out)     // output
    );

    always @(*) begin
        if (rst) begin
            vpu_data_out_1 = 16'b0;
            vpu_data_out_2 = 16'b0;
            vpu_valid_out_1 = 1'b0;
            vpu_valid_out_2 = 1'b0;
            
            // default internal wire assignments during reset
            bias_data_1_in = 16'b0;
            bias_data_2_in = 16'b0;
            bias_valid_1_in = 1'b0;
            bias_valid_2_in = 1'b0;
            lr_data_1_in = 16'b0;
            lr_data_2_in = 16'b0;
            lr_valid_1_in = 1'b0;
            lr_valid_2_in = 1'b0;
            loss_data_1_in = 16'b0;
            loss_data_2_in = 16'b0;
            loss_valid_1_in = 1'b0;
            loss_valid_2_in = 1'b0;
            lr_d_data_1_in = 16'b0;
            lr_d_data_2_in = 16'b0;
            lr_d_valid_1_in = 1'b0;
            lr_d_valid_2_in = 1'b0;
        end else begin
            // bias module
            if(vpu_data_pathway[3]) begin
                // connect vpu inputs to bias module
                bias_data_1_in = vpu_data_in_1;
                bias_data_2_in = vpu_data_in_2;
                bias_valid_1_in = vpu_valid_in_1;
                bias_valid_2_in = vpu_valid_in_2;

                // connect bias output to intermediate values
                b_to_lr_data_in_1 = bias_z_data_out_1;
                b_to_lr_data_in_2 = bias_z_data_out_2;
                b_to_lr_valid_in_1 = bias_valid_1_out;
                b_to_lr_valid_in_2 = bias_valid_2_out;
            end else begin
                // disable inputs
                bias_data_1_in = 16'b0;
                bias_data_2_in = 16'b0;
                bias_valid_1_in = 1'b0;
                bias_valid_2_in = 1'b0;

                // connect vpu input to intermediate values
                b_to_lr_data_in_1 = vpu_data_in_1;
                b_to_lr_data_in_2 = vpu_data_in_2;
                b_to_lr_valid_in_1 = vpu_valid_in_1;
                b_to_lr_valid_in_2 = vpu_valid_in_2;
            end

            // leaky relu module
            if(vpu_data_pathway[2]) begin
                // connect lr inputs to intermediate values
                lr_data_1_in = b_to_lr_data_in_1;
                lr_data_2_in = b_to_lr_data_in_2;
                lr_valid_1_in = b_to_lr_valid_in_1;
                lr_valid_2_in = b_to_lr_valid_in_2;

                // connect lr outputs to intermediate values
                lr_to_loss_data_in_1 = lr_data_1_out;
                lr_to_loss_data_in_2 = lr_data_2_out;
                lr_to_loss_valid_in_1 = lr_valid_1_out;
                lr_to_loss_valid_in_2 = lr_valid_2_out;

            end else begin
                // disable inputs
                lr_data_1_in = 16'b0;
                lr_data_2_in = 16'b0;
                lr_valid_1_in = 1'b0;
                lr_valid_2_in = 1'b0;

                // connect intermediate values to each other
                lr_to_loss_data_in_1 = b_to_lr_data_in_1;
                lr_to_loss_data_in_2 = b_to_lr_data_in_2;
                lr_to_loss_valid_in_1 = b_to_lr_valid_in_1;
                lr_to_loss_valid_in_2 = b_to_lr_valid_in_2;
            end

            // loss module
            if(vpu_data_pathway[1]) begin
                // connect loss inputs to intermediate values
                loss_data_1_in = lr_to_loss_data_in_1;
                loss_data_2_in = lr_to_loss_data_in_2;
                loss_valid_1_in = lr_to_loss_valid_in_1;
                loss_valid_2_in = lr_to_loss_valid_in_2;

                // connect loss outputs to intermediate values
                loss_to_lrd_data_in_1 = loss_data_1_out;
                loss_to_lrd_data_in_2 = loss_data_2_out;
                loss_to_lrd_valid_in_1 = loss_valid_1_out;
                loss_to_lrd_valid_in_2 = loss_valid_2_out;

                // Cache and use 'last H matrix'
                last_H_data_1_in = lr_data_1_out;
                last_H_data_2_in = lr_data_2_out;
                lr_d_H_in_1 = last_H_data_1_out;
                lr_d_H_in_2 = last_H_data_2_out;
            end else begin
                // disable inputs
                loss_data_1_in = 16'b0;
                loss_data_2_in = 16'b0;
                loss_valid_1_in = 1'b0;
                loss_valid_2_in = 1'b0;

                // connect intermediate values to each other
                loss_to_lrd_data_in_1 = lr_to_loss_data_in_1;
                loss_to_lrd_data_in_2 = lr_to_loss_data_in_2;
                loss_to_lrd_valid_in_1 = lr_to_loss_valid_in_1;
                loss_to_lrd_valid_in_2 = lr_to_loss_valid_in_2;

                // Don't cache and use 'last H matrix'
                lr_d_H_in_1 = H_in_1;
                lr_d_H_in_2 = H_in_2;
            end

            // leaky relu derivative module
            if(vpu_data_pathway[0]) begin
                lr_d_data_1_in = loss_to_lrd_data_in_1;
                lr_d_data_2_in = loss_to_lrd_data_in_2;
                lr_d_valid_1_in = loss_to_lrd_valid_in_1;
                lr_d_valid_2_in = loss_to_lrd_valid_in_2;

                // connect lr_d outputs to vpu output
                vpu_data_out_1 = lr_d_data_1_out;
                vpu_data_out_2 = lr_d_data_2_out;
                vpu_valid_out_1 = lr_d_valid_1_out;
                vpu_valid_out_2 = lr_d_valid_2_out;
            end else begin
                // disable inputs
                lr_d_data_1_in = loss_to_lrd_data_in_1;
                lr_d_data_2_in = loss_to_lrd_data_in_2;
                lr_d_valid_1_in = loss_to_lrd_valid_in_1;
                lr_d_valid_2_in = loss_to_lrd_valid_in_2;

                // connect intermediate values to vpu output
                vpu_data_out_1 = loss_to_lrd_data_in_1;
                vpu_data_out_2 = loss_to_lrd_data_in_2;
                vpu_valid_out_1 = loss_to_lrd_valid_in_1;
                vpu_valid_out_2 = loss_to_lrd_valid_in_2;
            end
        end
    end

    // sequential logic to cache last H???
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_H_data_1_in <= 0;
            last_H_data_2_in <= 0;
            last_H_data_1_out <= 0;
            last_H_data_2_out <= 0;
        end else begin
            if (vpu_data_pathway[1]) begin
                last_H_data_1_out <= last_H_data_1_in;
                last_H_data_2_out <= last_H_data_2_in;
            end else begin
                last_H_data_1_out <= 0;
                last_H_data_2_out <= 0;
            end 
        end
    end

endmodule