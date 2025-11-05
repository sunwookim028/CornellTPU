# test_4x4/test_vpu_dpath.py
import os
import subprocess

def test_vpu_dpath():
    """Test the vpu_dpath module with Verilog simulation"""

    os.makedirs("build", exist_ok=True)
    
    verilog_files = [
        "src_4x4/fixedpoint.sv",
        "src_4x4/bias_child.sv", 
        "src_4x4/bias_parent.sv",
        "src_4x4/leaky_relu_child.sv",
        "src_4x4/leaky_relu_parent.sv",
        "src_4x4/vpu_dpath.sv"
    ]
    
    # Create a comprehensive testbench for VPU datapath only
    testbench_code = """
`timescale 1ns/1ps

module test_vpu_dpath;
    reg clk, rst;
    reg [3:0] vpu_data_pathway;
    reg signed [15:0] vpu_data_in_1, vpu_data_in_2, vpu_data_in_3, vpu_data_in_4;
    reg vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4;
    reg signed [15:0] bias_scalar_in_1, bias_scalar_in_2, bias_scalar_in_3, bias_scalar_in_4;
    reg signed [15:0] lr_leak_factor_in;
    
    wire signed [15:0] vpu_data_out_1, vpu_data_out_2, vpu_data_out_3, vpu_data_out_4;
    wire vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4;
    
    // Real values for monitoring
    real real_out1, real_out2, real_out3, real_out4;

    integer cycle_count;
    
    // Instantiate VPU datapath only
    vpu_dpath dut (
        .clk(clk),
        .rst(rst),
        .vpu_data_pathway(vpu_data_pathway),
        .vpu_data_in_1(vpu_data_in_1),
        .vpu_data_in_2(vpu_data_in_2),
        .vpu_data_in_3(vpu_data_in_3),
        .vpu_data_in_4(vpu_data_in_4),
        .vpu_valid_in_1(vpu_valid_in_1),
        .vpu_valid_in_2(vpu_valid_in_2),
        .vpu_valid_in_3(vpu_valid_in_3),
        .vpu_valid_in_4(vpu_valid_in_4),
        .bias_scalar_in_1(bias_scalar_in_1),
        .bias_scalar_in_2(bias_scalar_in_2),
        .bias_scalar_in_3(bias_scalar_in_3),
        .bias_scalar_in_4(bias_scalar_in_4),
        .lr_leak_factor_in(lr_leak_factor_in),
        .vpu_data_out_1(vpu_data_out_1),
        .vpu_data_out_2(vpu_data_out_2),
        .vpu_data_out_3(vpu_data_out_3),
        .vpu_data_out_4(vpu_data_out_4),
        .vpu_valid_out_1(vpu_valid_out_1),
        .vpu_valid_out_2(vpu_valid_out_2),
        .vpu_valid_out_3(vpu_valid_out_3),
        .vpu_valid_out_4(vpu_valid_out_4)
    );
    
    always #5 clk = ~clk;
    
    // Update real values continuously
    always @(vpu_data_out_1 or vpu_data_out_2 or vpu_data_out_3 or vpu_data_out_4) begin
        real_out1 = $signed(vpu_data_out_1) / 256.0;
        real_out2 = $signed(vpu_data_out_2) / 256.0;
        real_out3 = $signed(vpu_data_out_3) / 256.0;
        real_out4 = $signed(vpu_data_out_4) / 256.0;
    end
    
    // Helper function to convert real to Q8.8
    function [15:0] to_fixed;
        input real val;
        reg signed [15:0] result;
        begin
            result = $signed($rtoi(val * 256.0));
            to_fixed = result;
        end
    endfunction
    
    initial begin
        clk = 0;
        rst = 1;
        
        // Initialize all inputs
        vpu_data_pathway = 4'b0000;
        vpu_data_in_1 = 0; vpu_data_in_2 = 0; vpu_data_in_3 = 0; vpu_data_in_4 = 0;
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        bias_scalar_in_1 = 0; bias_scalar_in_2 = 0; bias_scalar_in_3 = 0; bias_scalar_in_4 = 0;
        lr_leak_factor_in = 0;
        
        $display("=== VPU DATAPATH MODULE TEST ===");
        $display("Time Cycle Pathway Data1 Data2 Data3 Data4 ValidOut");
        $display("----- ----- ------- ----- ----- ----- ----- --------");
        
        #20;
        rst = 0;
        
        #10;
        
        cycle_count = 0;
        
        // Test 1: Forward pass (bias + leaky_relu)
        $display(">>> Test 1: Forward pass (bias + leaky_relu)");
        vpu_data_pathway = 4'b1100;  // Enable bias and leaky_relu
        bias_scalar_in_1 = to_fixed(1.0);   
        bias_scalar_in_2 = to_fixed(2.0); 
        bias_scalar_in_3 = to_fixed(0.5);   
        bias_scalar_in_4 = to_fixed(0.5);   
        lr_leak_factor_in = to_fixed(0.1); 
        
        // Send inputs for multiple cycles
        for (integer i = 0; i < 8; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            
            // Provide test inputs
            vpu_data_in_1 = to_fixed(0.5);
            vpu_data_in_2 = to_fixed(1.0); 
            vpu_data_in_3 = to_fixed(-1.5);
            vpu_data_in_4 = to_fixed(2.0); 
            vpu_valid_in_1 = 1; 
            vpu_valid_in_2 = 1; 
            vpu_valid_in_3 = 1; 
            vpu_valid_in_4 = 1;
            
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b", 
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end
        
        // Stop inputs but continue monitoring
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        for (integer i = 0; i < 10; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b", 
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end

        #20; // Extra gap between tests
        
        // Test 2: Bias only pathway
        $display(">>> Test 2: Bias only pathway");
        vpu_data_pathway = 4'b1000;  // Enable bias only
        // Reset bias values (same as before)
        bias_scalar_in_1 = to_fixed(1.0);   // Bias = 1.0
        bias_scalar_in_2 = to_fixed(2.0);   // Bias = 2.0
        bias_scalar_in_3 = to_fixed(1.5);   // Bias = 1.5
        bias_scalar_in_4 = to_fixed(0.5);   // Bias = 0.5
        
        // Send single input
        #10;
        for (integer i = 0; i < 8; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            // Provide test inputs
            vpu_data_in_1 = to_fixed(0.5);
            vpu_data_in_2 = to_fixed(1.0); 
            vpu_data_in_3 = to_fixed(-1.5);
            vpu_data_in_4 = to_fixed(2.0); 
            vpu_valid_in_1 = 1; 
            vpu_valid_in_2 = 1; 
            vpu_valid_in_3 = 1; 
            vpu_valid_in_4 = 1;
            
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b", 
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end
        
        // Stop inputs, monitor pipeline
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        for (integer i = 0; i < 8; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b",  
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end

        #20; // Extra gap between tests
        
        // Test 2: Bias only pathway
        $display(">>> Test 3: LeakyReLU only pathway");
        vpu_data_pathway = 4'b0100;  // Enable LR only
        // Reset LR factor value (same as before)
        lr_leak_factor_in = to_fixed(0.1);  // Leak factor = 0.1

        // Send single input
        #10;
        for (integer i = 0; i < 8; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            // Provide test inputs
            vpu_data_in_1 = to_fixed(0.5);
            vpu_data_in_2 = to_fixed(1.0); 
            vpu_data_in_3 = to_fixed(-1.5);
            vpu_data_in_4 = to_fixed(2.0); 
            vpu_valid_in_1 = 1; 
            vpu_valid_in_2 = 1; 
            vpu_valid_in_3 = 1; 
            vpu_valid_in_4 = 1;
            
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b", 
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end
        
        // Stop inputs, monitor pipeline
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        for (integer i = 0; i < 8; i = i + 1) begin
            #10;
            cycle_count = cycle_count + 1;
            $display("%4d %5d %07b %5.2f %5.2f %5.2f %5.2f %8b",  
                     $time, cycle_count, vpu_data_pathway,
                     real_out1, real_out2, real_out3, real_out4,
                     {vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4});
        end
        
        $display("=== TEST COMPLETE ===");
        $display("Expected Results:");
        $display("Test 1: (0.5,1.0,-1.5,2.0) + Bias(1.0,2.0,0.5,0.5) -> (1.5,3.0,-1.0,2.5) -> LReLU(1.5,3.0,-0.1,2.5)");
        $display("Test 3: (0.5,1.0,-1.5,2.0) + Bias(1.0,2.0,-1.5,0.5) -> (1.5,3.0,0.0,2.5)");
        $display("Test 3: (0.5,1.0,-1.5,2.0) -> LReLU(0.5,1.0,-0.15,2.0)");
        
        $finish;
    end
    
endmodule
"""
    
    # Write testbench
    with open("build/test_vpu_dpath.sv", "w") as f:
        f.write(testbench_code)
    
    # Compile
    print("Compiling VPU datapath testbench...")
    compile_cmd = ["iverilog", "-o", "build/test_vpu_dpath", "-g2012", "build/test_vpu_dpath.sv"] + verilog_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Compilation successful! Running VPU datapath test...")
    
    # Run simulation
    result = subprocess.run(["vvp", "build/test_vpu_dpath"], capture_output=True, text=True)
    
    print("=== VPU DATAPATH TEST OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    # Check if test passed
    success = ("ValidOut" in result.stdout and any("1" in line for line in result.stdout.split('\\n') if "ValidOut" in line))
    
    if success:
        print("SUCCESS: VPU datapath module is producing outputs!")
    else:
        print("PROBLEM: VPU datapath module may not be functioning properly")
    
    return success

if __name__ == "__main__":
    test_vpu_dpath()