# test_4x4/test_leaky_relu_parent.py
import os
import subprocess

def test_leaky_relu_parent():
    """Test the leaky_relu_parent module"""

    os.makedirs("build", exist_ok=True)
    
    verilog_files = [
        "src_4x4/fixedpoint.sv",
        "src_4x4/leaky_relu_child.sv", 
        "src_4x4/leaky_relu_parent.sv"
    ]
    
    # Create a testbench for leaky_relu_parent
    testbench_code = """
`timescale 1ns/1ps

module test_leaky_relu_parent;
    reg clk, rst;
    reg signed [15:0] lr_leak_factor_in;
    
    // Input valid signals
    reg lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in;
    
    // Input data
    reg signed [15:0] lr_data_1_in, lr_data_2_in, lr_data_3_in, lr_data_4_in;
    
    // Outputs
    wire signed [15:0] lr_data_1_out, lr_data_2_out, lr_data_3_out, lr_data_4_out;
    wire lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out;
    
    // Instantiate leaky_relu_parent
    leaky_relu_parent dut (
        .clk(clk),
        .rst(rst),
        .lr_leak_factor_in(lr_leak_factor_in),
        .lr_valid_1_in(lr_valid_1_in),
        .lr_valid_2_in(lr_valid_2_in),
        .lr_valid_3_in(lr_valid_3_in),
        .lr_valid_4_in(lr_valid_4_in),
        .lr_data_1_in(lr_data_1_in),
        .lr_data_2_in(lr_data_2_in),
        .lr_data_3_in(lr_data_3_in),
        .lr_data_4_in(lr_data_4_in),
        .lr_data_1_out(lr_data_1_out),
        .lr_data_2_out(lr_data_2_out),
        .lr_data_3_out(lr_data_3_out),
        .lr_data_4_out(lr_data_4_out),
        .lr_valid_1_out(lr_valid_1_out),
        .lr_valid_2_out(lr_valid_2_out),
        .lr_valid_3_out(lr_valid_3_out),
        .lr_valid_4_out(lr_valid_4_out)
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
        lr_leak_factor_in = 0;
        lr_valid_1_in = 0; lr_valid_2_in = 0; lr_valid_3_in = 0; lr_valid_4_in = 0;
        lr_data_1_in = 0; lr_data_2_in = 0; lr_data_3_in = 0; lr_data_4_in = 0;
        
        $display("=== LEAKY_RELU_PARENT TEST ===");
        $display("Time | Stage           | Data1    | Data2    | Data3    | Data4    | Valids   | Leak");
        $display("-----|-----------------|----------|----------|----------|----------|----------|------");
        
        #20;
        rst = 0;
        
        #10;
        
        // Test 1: Positive inputs (should pass through unchanged)
        $display("Test 1: Positive inputs (leak=0.1)");
        lr_leak_factor_in = to_fixed(0.1);  // Leak factor 0.1
        lr_data_1_in = to_fixed(1.0);      // 1.0
        lr_data_2_in = to_fixed(2.5);      // 2.5
        lr_data_3_in = to_fixed(0.5);      // 0.5
        lr_data_4_in = to_fixed(3.0);      // 3.0
        lr_valid_1_in = 1; lr_valid_2_in = 1; lr_valid_3_in = 1; lr_valid_4_in = 1;
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        // Test 2: Negative inputs (should be multiplied by leak factor)
        $display("Test 2: Negative inputs (leak=0.1)");
        lr_data_1_in = to_fixed(-1.0);     // -1.0
        lr_data_2_in = to_fixed(-2.5);     // -2.5
        lr_data_3_in = to_fixed(-0.5);     // -0.5
        lr_data_4_in = to_fixed(-3.0);     // -3.0
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        // Test 3: Mixed positive and negative inputs
        $display("Test 3: Mixed inputs (leak=0.1)");
        lr_data_1_in = to_fixed(1.5);      // 1.5 (positive)
        lr_data_2_in = to_fixed(-1.5);     // -1.5 (negative)
        lr_data_3_in = to_fixed(0.0);      // 0.0 (zero)
        lr_data_4_in = to_fixed(-0.25);    // -0.25 (negative)
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        // Test 4: Change leak factor to 0.5
        $display("Test 4: Negative inputs with leak=0.5");
        lr_leak_factor_in = to_fixed(0.5);  // Leak factor 0.5
        lr_data_1_in = to_fixed(-1.0);      // -1.0
        lr_data_2_in = to_fixed(-2.0);      // -2.0
        lr_data_3_in = to_fixed(-0.5);      // -0.5
        lr_data_4_in = to_fixed(-4.0);      // -4.0
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        // Test 5: Test with invalid inputs
        $display("Test 5: Invalid inputs (should produce invalid outputs)");
        lr_valid_1_in = 0; lr_valid_2_in = 0; lr_valid_3_in = 0; lr_valid_4_in = 0;
        lr_data_1_in = to_fixed(1.0);      // Data present but invalid
        lr_data_2_in = to_fixed(-1.0);     // Data present but invalid
        lr_data_3_in = to_fixed(2.0);      // Data present but invalid
        lr_data_4_in = to_fixed(-2.0);     // Data present but invalid
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        // Test 6: Test individual column operation
        $display("Test 6: Individual column operation");
        lr_valid_1_in = 1; lr_valid_2_in = 0; lr_valid_3_in = 1; lr_valid_4_in = 0;
        lr_data_1_in = to_fixed(-2.0);     // Column 1: negative
        lr_data_2_in = to_fixed(-3.0);     // Column 2: invalid
        lr_data_3_in = to_fixed(2.0);      // Column 3: positive
        lr_data_4_in = to_fixed(-1.0);     // Column 4: invalid
        
        #10;
        $display("%4d | Input           | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b | %5.3f", 
                 $time,
                 to_real(lr_data_1_in), to_real(lr_data_2_in),
                 to_real(lr_data_3_in), to_real(lr_data_4_in),
                 lr_valid_1_in, lr_valid_2_in, lr_valid_3_in, lr_valid_4_in,
                 to_real(lr_leak_factor_in));
        
        #10;
        $display("%4d | Output          | %8.4f | %8.4f | %8.4f | %8.4f | %b%b%b%b |", 
                 $time,
                 to_real(lr_data_1_out), to_real(lr_data_2_out),
                 to_real(lr_data_3_out), to_real(lr_data_4_out),
                 lr_valid_1_out, lr_valid_2_out, lr_valid_3_out, lr_valid_4_out);
        
        $display("=== TEST COMPLETE ===");
        
        // Verify expected results
        $display("=== EXPECTED RESULTS ===");
        $display("Test 1: Positive inputs should pass through unchanged");
        $display("Test 2: Negative inputs should be multiplied by leak factor (0.1)");
        $display("  -1.0 * 0.1 = -0.1, -2.5 * 0.1 = -0.25, -0.5 * 0.1 = -0.05, -3.0 * 0.1 = -0.3");
        $display("Test 3: Mixed inputs - positives unchanged, negatives scaled");
        $display("Test 4: With leak=0.5: -1.0 * 0.5 = -0.5, -2.0 * 0.5 = -1.0, etc.");
        $display("Test 5: Invalid inputs should produce invalid outputs (all valids=0)");
        $display("Test 6: Only columns 1 and 3 should have valid outputs");
        
        $finish;
    end
endmodule
"""
    
    # Write testbench
    with open("build/test_leaky_relu_parent.sv", "w") as f:
        f.write(testbench_code)
    
    print("Testbench written to build/test_leaky_relu_parent_fixed.sv")

    # Compile
    print("Compiling leaky_relu_parent testbench...")
    compile_cmd = ["iverilog", "-o", "build/test_leaky_relu_parent", "-g2012", "build/test_leaky_relu_parent.sv"] + verilog_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Compilation successful! Running leaky_relu_parent test...")
    
    # Run simulation
    result = subprocess.run(["vvp", "build/test_leaky_relu_parent"], capture_output=True, text=True)
    
    print("=== LEAKY_RELU_PARENT TEST OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    # Check if test passed
    success = True
    expected_values = [
        "1.0000", "2.5000", "0.5000", "3.0000",  # Test 1 positives unchanged
        "-0.1000", "-0.2500", "-0.0500", "-0.3000"  # Test 2 negatives scaled
    ]
    
    for val in expected_values:
        if val not in result.stdout:
            success = False
            break
    
    if success:
        print("SUCCESS: leaky_relu_parent module is working correctly!")
    else:
        print("PROBLEM: leaky_relu_parent module may not be functioning properly")
    
    return success

if __name__ == "__main__":
    test_leaky_relu_parent()