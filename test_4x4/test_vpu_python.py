# test_4x4/test_vpu_verilog.py
import os
import subprocess

def test_vpu_verilog():
    """Test the vpu module with Verilog simulation"""

    os.makedirs("build", exist_ok=True)
    
    verilog_files = [
        "src_4x4/fixedpoint.sv",
        "src_4x4/bias_child.sv", 
        "src_4x4/bias_parent.sv",
        "src_4x4/leaky_relu_child.sv",
        "src_4x4/leaky_relu_parent.sv",
        "src_4x4/vpu.sv"
    ]
    
    # Create a comprehensive testbench for VPU
    testbench_code = """
`timescale 1ns/1ps

module test_vpu_verilog;
    reg clk, rst;
    reg [3:0] vpu_data_pathway;
    reg signed [15:0] vpu_data_in_1, vpu_data_in_2, vpu_data_in_3, vpu_data_in_4;
    reg vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4;
    reg signed [15:0] bias_scalar_in_1, bias_scalar_in_2, bias_scalar_in_3, bias_scalar_in_4;
    reg signed [15:0] lr_leak_factor_in;
    
    wire signed [15:0] vpu_data_out_1, vpu_data_out_2, vpu_data_out_3, vpu_data_out_4;
    wire vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4;
    
    // Instantiate VPU
    vpu dut (
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
    
    // Function to convert Q8.8 to real
    function real to_real;
        input [15:0] val;
        reg signed [15:0] signed_val;
        begin
            signed_val = $signed(val);
            to_real = signed_val / 256.0;
        end
    endfunction
    
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
        
        $display("=== VPU MODULE TEST ===");
        $display("Time | Stage           | Data1    | Data2    | Data3    | Data4    | Valids   | Pathway");
        $display("-----|-----------------|----------|----------|----------|----------|----------|---------");
        
        #20;
        rst = 0;
        
        #10;
        
        // Test 1: Forward pass (bias + leaky_relu)
        $display("Test 1: Forward pass pathway (bias + leaky_relu)");
        vpu_data_pathway = 4'b1100;  // Enable bias and leaky_relu
        bias_scalar_in_1 = to_fixed(1.0);   // Bias = 1.0
        bias_scalar_in_2 = to_fixed(2.0);   // Bias = 2.0
        bias_scalar_in_3 = to_fixed(1.5);   // Bias = 1.5
        bias_scalar_in_4 = to_fixed(0.5);   // Bias = 0.5
        lr_leak_factor_in = to_fixed(0.1);  // Leak factor = 0.1
        
        // Send positive inputs
        vpu_data_in_1 = to_fixed(0.5);   // 0.5
        vpu_data_in_2 = to_fixed(1.0);   // 1.0
        vpu_data_in_3 = to_fixed(-0.5);  // -0.5
        vpu_data_in_4 = to_fixed(2.0);   // 2.0
        vpu_valid_in_1 = 1; vpu_valid_in_2 = 1; vpu_valid_in_3 = 1; vpu_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %04b", 
                 $time,
                 to_real(vpu_data_in_1), to_real(vpu_data_in_2),
                 to_real(vpu_data_in_3), to_real(vpu_data_in_4),
                 vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4,
                 vpu_data_pathway);
        
        // Monitor outputs for several cycles to catch pipeline
        for (int i = 0; i < 10; i++) begin
            #10;
            $display("%4d | Output Cycle %2d  | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                     $time, i,
                     to_real(vpu_data_out_1), to_real(vpu_data_out_2),
                     to_real(vpu_data_out_3), to_real(vpu_data_out_4),
                     vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4);
        end
        
        // Test 2: Bias only pathway
        $display("Test 2: Bias only pathway");
        vpu_data_pathway = 4'b1000;  // Enable bias only
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        #20;
        vpu_data_in_1 = to_fixed(1.0);   // 1.0
        vpu_data_in_2 = to_fixed(-1.0);  // -1.0
        vpu_data_in_3 = to_fixed(0.0);   // 0.0
        vpu_data_in_4 = to_fixed(2.0);   // 2.0
        vpu_valid_in_1 = 1; vpu_valid_in_2 = 1; vpu_valid_in_3 = 1; vpu_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %04b", 
                 $time,
                 to_real(vpu_data_in_1), to_real(vpu_data_in_2),
                 to_real(vpu_data_in_3), to_real(vpu_data_in_4),
                 vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4,
                 vpu_data_pathway);
        
        for (int i = 0; i < 8; i++) begin
            #10;
            $display("%4d | Output Cycle %2d  | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                     $time, i,
                     to_real(vpu_data_out_1), to_real(vpu_data_out_2),
                     to_real(vpu_data_out_3), to_real(vpu_data_out_4),
                     vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4);
        end
        
        // Test 3: Leaky ReLU only pathway
        $display("Test 3: Leaky ReLU only pathway");
        vpu_data_pathway = 4'b0100;  // Enable leaky_relu only
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        #20;
        vpu_data_in_1 = to_fixed(-2.0);  // -2.0
        vpu_data_in_2 = to_fixed(1.5);   // 1.5
        vpu_data_in_3 = to_fixed(-0.5);  // -0.5
        vpu_data_in_4 = to_fixed(0.0);   // 0.0
        vpu_valid_in_1 = 1; vpu_valid_in_2 = 1; vpu_valid_in_3 = 1; vpu_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %04b", 
                 $time,
                 to_real(vpu_data_in_1), to_real(vpu_data_in_2),
                 to_real(vpu_data_in_3), to_real(vpu_data_in_4),
                 vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4,
                 vpu_data_pathway);
        
        for (int i = 0; i < 8; i++) begin
            #10;
            $display("%4d | Output Cycle %2d  | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                     $time, i,
                     to_real(vpu_data_out_1), to_real(vpu_data_out_2),
                     to_real(vpu_data_out_3), to_real(vpu_data_out_4),
                     vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4);
        end
        
        // Test 4: No operations (pass-through)
        $display("Test 4: No operations (pass-through)");
        vpu_data_pathway = 4'b0000;  // Disable all modules
        vpu_valid_in_1 = 0; vpu_valid_in_2 = 0; vpu_valid_in_3 = 0; vpu_valid_in_4 = 0;
        
        #20;
        vpu_data_in_1 = to_fixed(1.0);   // 1.0
        vpu_data_in_2 = to_fixed(2.0);   // 2.0
        vpu_data_in_3 = to_fixed(3.0);   // 3.0
        vpu_data_in_4 = to_fixed(4.0);   // 4.0
        vpu_valid_in_1 = 1; vpu_valid_in_2 = 1; vpu_valid_in_3 = 1; vpu_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %04b", 
                 $time,
                 to_real(vpu_data_in_1), to_real(vpu_data_in_2),
                 to_real(vpu_data_in_3), to_real(vpu_data_in_4),
                 vpu_valid_in_1, vpu_valid_in_2, vpu_valid_in_3, vpu_valid_in_4,
                 vpu_data_pathway);
        
        for (int i = 0; i < 6; i++) begin
            #10;
            $display("%4d | Output Cycle %2d  | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                     $time, i,
                     to_real(vpu_data_out_1), to_real(vpu_data_out_2),
                     to_real(vpu_data_out_3), to_real(vpu_data_out_4),
                     vpu_valid_out_1, vpu_valid_out_2, vpu_valid_out_3, vpu_valid_out_4);
        end
        
        $display("=== TEST COMPLETE ===");
        
        // Verify expected results
        $display("=== EXPECTED RESULTS ===");
        $display("Test 1: Forward pass (bias + leaky_relu)");
        $display("  Input: (0.5, 1.0, -0.5, 2.0) + Bias: (1.0, 2.0, 1.5, 0.5) = (1.5, 3.0, 1.0, 2.5)");
        $display("  Then Leaky ReLU: (1.5, 3.0, 0.1, 2.5)  [negative * 0.1]");
        $display("Test 2: Bias only");
        $display("  Input: (1.0, -1.0, 0.0, 2.0) + Bias: (1.0, 2.0, 1.5, 0.5) = (2.0, 1.0, 1.5, 2.5)");
        $display("Test 3: Leaky ReLU only");
        $display("  Input: (-2.0, 1.5, -0.5, 0.0) -> (-0.2, 1.5, -0.05, 0.0)");
        $display("Test 4: Pass-through");
        $display("  Input should pass through unchanged: (1.0, 2.0, 3.0, 4.0)");
        
        $finish;
    end
endmodule
"""
    
    # Write testbench
    with open("build/test_vpu_verilog.sv", "w") as f:
        f.write(testbench_code)
    
    # Compile
    print("Compiling VPU testbench...")
    compile_cmd = ["iverilog", "-o", "build/test_vpu_verilog", "-g2012", "build/test_vpu_verilog.sv"] + verilog_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Compilation successful! Running VPU test...")
    
    # Run simulation
    result = subprocess.run(["vvp", "build/test_vpu_verilog"], capture_output=True, text=True)
    
    print("=== VPU TEST OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    # Check if test passed (look for valid outputs)
    success = any(str(i) in result.stdout for i in range(1, 10)) and "Valids: 1" in result.stdout
    
    if success:
        print("SUCCESS: VPU module is producing outputs!")
    else:
        print("PROBLEM: VPU module may not be functioning properly")
    
    return success

if __name__ == "__main__":
    test_vpu_verilog()