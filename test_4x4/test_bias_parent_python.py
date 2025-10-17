# test_4x4/test_bias_parent_fixed.py
import os
import subprocess

def test_bias_parent_fixed():
    """Test the bias_parent module with correct fixed-point conversion"""
    
    os.makedirs("build", exist_ok=True)
    
    verilog_files = [
        "src_4x4/fixedpoint.sv",
        "src_4x4/bias_child.sv", 
        "src_4x4/bias_parent.sv"
    ]
    
    # Create a testbench with correct fixed-point conversion
    testbench_code = """
`timescale 1ns/1ps

module test_bias_parent_fixed;
    reg clk, rst;
    
    // Bias scalar inputs
    reg signed [15:0] bias_scalar_ub_in_1, bias_scalar_ub_in_2, bias_scalar_ub_in_3, bias_scalar_ub_in_4;
    
    // Load enable signals
    reg bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4;
    
    // Systolic array inputs
    reg signed [15:0] bias_sys_data_in_1, bias_sys_data_in_2, bias_sys_data_in_3, bias_sys_data_in_4;
    reg bias_sys_valid_in_1, bias_sys_valid_in_2, bias_sys_valid_in_3, bias_sys_valid_in_4;
    
    // Outputs
    wire bias_Z_valid_out_1, bias_Z_valid_out_2, bias_Z_valid_out_3, bias_Z_valid_out_4;
    wire signed [15:0] bias_z_data_out_1, bias_z_data_out_2, bias_z_data_out_3, bias_z_data_out_4;
    
    // Instantiate bias_parent
    bias_parent dut (
        .clk(clk),
        .rst(rst),
        .bias_scalar_ub_in_1(bias_scalar_ub_in_1),
        .bias_scalar_ub_in_2(bias_scalar_ub_in_2),
        .bias_scalar_ub_in_3(bias_scalar_ub_in_3),
        .bias_scalar_ub_in_4(bias_scalar_ub_in_4),
        .bias_load_en_1(bias_load_en_1),
        .bias_load_en_2(bias_load_en_2),
        .bias_load_en_3(bias_load_en_3),
        .bias_load_en_4(bias_load_en_4),
        .bias_sys_data_in_1(bias_sys_data_in_1),
        .bias_sys_data_in_2(bias_sys_data_in_2),
        .bias_sys_data_in_3(bias_sys_data_in_3),
        .bias_sys_data_in_4(bias_sys_data_in_4),
        .bias_sys_valid_in_1(bias_sys_valid_in_1),
        .bias_sys_valid_in_2(bias_sys_valid_in_2),
        .bias_sys_valid_in_3(bias_sys_valid_in_3),
        .bias_sys_valid_in_4(bias_sys_valid_in_4),
        .bias_Z_valid_out_1(bias_Z_valid_out_1),
        .bias_Z_valid_out_2(bias_Z_valid_out_2),
        .bias_Z_valid_out_3(bias_Z_valid_out_3),
        .bias_Z_valid_out_4(bias_Z_valid_out_4),
        .bias_z_data_out_1(bias_z_data_out_1),
        .bias_z_data_out_2(bias_z_data_out_2),
        .bias_z_data_out_3(bias_z_data_out_3),
        .bias_z_data_out_4(bias_z_data_out_4)
    );
    
    always #5 clk = ~clk;
    
    // CORRECTED Function to convert Q8.8 to real
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
        bias_scalar_ub_in_1 = 0; bias_scalar_ub_in_2 = 0; bias_scalar_ub_in_3 = 0; bias_scalar_ub_in_4 = 0;
        bias_load_en_1 = 0; bias_load_en_2 = 0; bias_load_en_3 = 0; bias_load_en_4 = 0;
        bias_sys_data_in_1 = 0; bias_sys_data_in_2 = 0; bias_sys_data_in_3 = 0; bias_sys_data_in_4 = 0;
        bias_sys_valid_in_1 = 0; bias_sys_valid_in_2 = 0; bias_sys_valid_in_3 = 0; bias_sys_valid_in_4 = 0;
        
        $display("=== BIAS_PARENT TEST (FIXED POINT CORRECTED) ===");
        $display("Time | Stage           | Data1    | Data2    | Data3    | Data4    | Valids   | LoadEn");
        $display("-----|-----------------|----------|----------|----------|----------|----------|-------");
        
        #20;
        rst = 0;
        
        #10;
        
        // Test 1: Load bias values for each column
        $display("Test 1: Loading bias values...");
        bias_scalar_ub_in_1 = to_fixed(1.0);   // 16'h0100 = 1.0
        bias_scalar_ub_in_2 = to_fixed(2.0);   // 16'h0200 = 2.0
        bias_scalar_ub_in_3 = to_fixed(3.0);   // 16'h0300 = 3.0
        bias_scalar_ub_in_4 = to_fixed(4.0);   // 16'h0400 = 4.0
        bias_load_en_1 = 1; bias_load_en_2 = 1; bias_load_en_3 = 1; bias_load_en_4 = 1;
        
        #10;
        bias_load_en_1 = 0; bias_load_en_2 = 0; bias_load_en_3 = 0; bias_load_en_4 = 0;
        
        $display("%4d | Bias Loaded     | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %b%b%b%b", 
                 $time,
                 to_real(bias_scalar_ub_in_1), to_real(bias_scalar_ub_in_2),
                 to_real(bias_scalar_ub_in_3), to_real(bias_scalar_ub_in_4),
                 bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4,
                 bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4);
        
        #10;
        
        // Test 2: Send data through all columns with bias applied
        $display("Test 2: Processing data with bias...");
        bias_sys_data_in_1 = to_fixed(0.5);   // 16'h0080 = 0.5
        bias_sys_data_in_2 = to_fixed(1.0);   // 16'h0100 = 1.0
        bias_sys_data_in_3 = to_fixed(1.5);   // 16'h0180 = 1.5
        bias_sys_data_in_4 = to_fixed(2.0);   // 16'h0200 = 2.0
        bias_sys_valid_in_1 = 1; bias_sys_valid_in_2 = 1; bias_sys_valid_in_3 = 1; bias_sys_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_sys_data_in_1), to_real(bias_sys_data_in_2),
                 to_real(bias_sys_data_in_3), to_real(bias_sys_data_in_4),
                 bias_sys_valid_in_1, bias_sys_valid_in_2, bias_sys_valid_in_3, bias_sys_valid_in_4);
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_z_data_out_1), to_real(bias_z_data_out_2),
                 to_real(bias_z_data_out_3), to_real(bias_z_data_out_4),
                 bias_Z_valid_out_1, bias_Z_valid_out_2, bias_Z_valid_out_3, bias_Z_valid_out_4);
        
        // Test 3: Send more data (bias should still be applied from previous load)
        $display("Test 3: More data with same bias...");
        bias_sys_data_in_1 = to_fixed(0.0);   // 0.0
        bias_sys_data_in_2 = to_fixed(0.0);   // 0.0
        bias_sys_data_in_3 = to_fixed(0.0);   // 0.0
        bias_sys_data_in_4 = to_fixed(0.0);   // 0.0
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_sys_data_in_1), to_real(bias_sys_data_in_2),
                 to_real(bias_sys_data_in_3), to_real(bias_sys_data_in_4),
                 bias_sys_valid_in_1, bias_sys_valid_in_2, bias_sys_valid_in_3, bias_sys_valid_in_4);
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_z_data_out_1), to_real(bias_z_data_out_2),
                 to_real(bias_z_data_out_3), to_real(bias_z_data_out_4),
                 bias_Z_valid_out_1, bias_Z_valid_out_2, bias_Z_valid_out_3, bias_Z_valid_out_4);
        
        // Test 4: Load new bias values and test
        $display("Test 4: Loading new bias values...");
        bias_sys_valid_in_1 = 0; bias_sys_valid_in_2 = 0; bias_sys_valid_in_3 = 0; bias_sys_valid_in_4 = 0;
        
        #10;
        bias_scalar_ub_in_1 = to_fixed(-1.0);  // 16'hFF00 = -1.0
        bias_scalar_ub_in_2 = to_fixed(-2.0);  // 16'hFE00 = -2.0
        bias_scalar_ub_in_3 = to_fixed(-3.0);  // 16'hFD00 = -3.0
        bias_scalar_ub_in_4 = to_fixed(-4.0);  // 16'hFC00 = -4.0
        bias_load_en_1 = 1; bias_load_en_2 = 1; bias_load_en_3 = 1; bias_load_en_4 = 1;
        
        #10;
        bias_load_en_1 = 0; bias_load_en_2 = 0; bias_load_en_3 = 0; bias_load_en_4 = 0;
        
        $display("%4d | New Bias Loaded | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %b%b%b%b", 
                 $time,
                 to_real(bias_scalar_ub_in_1), to_real(bias_scalar_ub_in_2),
                 to_real(bias_scalar_ub_in_3), to_real(bias_scalar_ub_in_4),
                 bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4,
                 bias_load_en_1, bias_load_en_2, bias_load_en_3, bias_load_en_4);
        
        // Test 5: Test with new bias values
        $display("Test 5: Processing with new bias...");
        bias_sys_data_in_1 = to_fixed(1.0);   // 1.0
        bias_sys_data_in_2 = to_fixed(2.0);   // 2.0
        bias_sys_data_in_3 = to_fixed(3.0);   // 3.0
        bias_sys_data_in_4 = to_fixed(4.0);   // 4.0
        bias_sys_valid_in_1 = 1; bias_sys_valid_in_2 = 1; bias_sys_valid_in_3 = 1; bias_sys_valid_in_4 = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_sys_data_in_1), to_real(bias_sys_data_in_2),
                 to_real(bias_sys_data_in_3), to_real(bias_sys_data_in_4),
                 bias_sys_valid_in_1, bias_sys_valid_in_2, bias_sys_valid_in_3, bias_sys_valid_in_4);
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(bias_z_data_out_1), to_real(bias_z_data_out_2),
                 to_real(bias_z_data_out_3), to_real(bias_z_data_out_4),
                 bias_Z_valid_out_1, bias_Z_valid_out_2, bias_Z_valid_out_3, bias_Z_valid_out_4);
        
        $display("=== TEST COMPLETE ===");
        
        // Verify expected results
        $display("=== EXPECTED RESULTS ===");
        $display("Test 2: 0.5 + 1.0 = 1.5, 1.0 + 2.0 = 3.0, 1.5 + 3.0 = 4.5, 2.0 + 4.0 = 6.0");
        $display("Test 3: 0.0 + 1.0 = 1.0, 0.0 + 2.0 = 2.0, 0.0 + 3.0 = 3.0, 0.0 + 4.0 = 4.0");
        $display("Test 5: 1.0 + (-1.0) = 0.0, 2.0 + (-2.0) = 0.0, 3.0 + (-3.0) = 0.0, 4.0 + (-4.0) = 0.0");
        
        $finish;
    end
endmodule
"""
    
    # Write testbench to build directory
    with open("build/test_bias_parent_fixed.sv", "w") as f:
        f.write(testbench_code)
    
    print("Testbench written to build/test_bias_parent_fixed.sv")
    
    # Compile
    print("Compiling bias_parent testbench with corrected fixed-point...")
    compile_cmd = ["iverilog", "-o", "build/test_bias_parent_fixed", "-g2012", "build/test_bias_parent_fixed.sv"] + verilog_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Compilation successful! Running bias_parent test...")
    
    # Run simulation
    result = subprocess.run(["vvp", "build/test_bias_parent_fixed"], capture_output=True, text=True)
    
    print("=== BIAS_PARENT TEST OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    # Check if test passed
    success = "1.5000" in result.stdout and "3.0000" in result.stdout and "0.0000" in result.stdout
    if success:
        print("SUCCESS: bias_parent module is working correctly!")
    else:
        print("PROBLEM: bias_parent module may not be functioning properly")
    
    return success

if __name__ == "__main__":
    test_bias_parent_fixed()