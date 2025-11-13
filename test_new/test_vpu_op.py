# test_vpu/test_vpu_op.py
import os
import subprocess
import struct

def float_to_int32(f):
    """Convert float to 32-bit integer representation"""
    return struct.unpack('I', struct.pack('f', f))[0]

def test_vpu_op():
    """Test the VPU operation module with various ALU operations"""
    
    os.makedirs("build", exist_ok=True)
    
    # Create testbench with FP32 test cases
    testbench_code = """

`timescale 1ns/1ps

module test_vpu_op;
    parameter DATA_W = 32;
    parameter OP_W = 4;
    
    // Test signals
    reg start;
    reg [DATA_W-1:0] operand0;
    reg [DATA_W-1:0] operand1;
    reg [OP_W-1:0] opcode;
    wire [DATA_W-1:0] result_out;
    
    // Test variables
    integer test_count;
    integer error_count;
    real real_operand0, real_operand1, real_result, real_expected;
    
    // Instantiate DUT
    vpu_op #(
        .DATA_W(DATA_W),
        .OP_W(OP_W)
    ) dut (
        .start(start),
        .operand0(operand0),
        .operand1(operand1),
        .opcode(opcode),
        .result_out(result_out)
    );
    
    // Helper function to print operation
    function string get_op_name;
        input [OP_W-1:0] op;
        case (op)
            4'd0: get_op_name = "ADD ";
            4'd1: get_op_name = "SUB ";
            4'd2: get_op_name = "RELU";
            4'd3: get_op_name = "MUL ";
            default: get_op_name = "UNKN";
        endcase
    endfunction
    
    // Function to convert FP32 to real
    function real fp32_to_real;
        input [31:0] fp32;
        real result;
        integer sign;
        integer exponent;
        integer mantissa;
        real mantissa_val;
        integer i;
        begin
            sign = fp32[31];
            exponent = fp32[30:23];
            mantissa = {1'b1, fp32[22:0]}; // Add implicit leading 1
            
            // Handle special cases
            if (exponent == 8'hFF) begin
                // Infinity or NaN
                if (mantissa[22:0] == 0) begin
                    result = sign ? -1.0e30 : 1.0e30; // Approximate infinity
                end else begin
                    result = 0.0; // NaN - treat as zero for testing
                end
            end else if (exponent == 8'h00) begin
                // Denormalized numbers or zero
                if (mantissa[22:0] == 0) begin
                    result = 0.0;
                end else begin
                    // Denormalized number - no implicit leading 1
                    mantissa_val = 0.0;
                    for (i = 0; i < 23; i = i + 1) begin
                        if (fp32[22-i]) begin
                            mantissa_val = mantissa_val + (2.0 ** (-i-1));
                        end
                    end
                    result = mantissa_val * (2.0 ** -126);
                    if (sign) result = -result;
                end
            end else begin
                // Normalized number
                mantissa_val = 1.0; // Start with implicit leading 1
                for (i = 0; i < 23; i = i + 1) begin
                    if (fp32[22-i]) begin
                        mantissa_val = mantissa_val + (2.0 ** (-i-1));
                    end
                end
                result = mantissa_val * (2.0 ** (exponent - 127));
                if (sign) result = -result;
            end
            
            fp32_to_real = result;
        end
    endfunction
    
    // Test task for basic operations with tolerance for FP32
    task test_operation;
        input [DATA_W-1:0] op0;
        input [DATA_W-1:0] op1;
        input [OP_W-1:0] op;
        input [DATA_W-1:0] expected;
        input string test_name;
        real tolerance;
        real result_real, expected_real;
        begin
            $display("=== Test %0d: %s ===", test_count, test_name);
            $display("Operation: %s", get_op_name(op));
            
            real_operand0 = fp32_to_real(op0);
            real_operand1 = fp32_to_real(op1);
            real_expected = fp32_to_real(expected);
            
            $display("Operand0: 0x%08x (%0.6f)", op0, real_operand0);
            $display("Operand1: 0x%08x (%0.6f)", op1, real_operand1);
            
            // Apply inputs
            start = 1'b1;
            operand0 = op0;
            operand1 = op1;
            opcode = op;
            
            #100; // Wait longer for FP32 operations
            
            result_real = fp32_to_real(result_out);
            $display("Result:   0x%08x (%0.6f)", result_out, result_real);
            $display("Expected: 0x%08x (%0.6f)", expected, real_expected);
            
            // Use tolerance for FP32 comparisons
            tolerance = 0.0001;
            if ((result_real >= real_expected - tolerance) && 
                (result_real <= real_expected + tolerance)) begin
                $display("PASS");
            end else begin
                $display("FAIL");
                error_count = error_count + 1;
            end
            
            test_count = test_count + 1;
            $display("");
            
            // Reset for next test
            start = 1'b0;
            #10;
        end
    endtask
    
    // Test task for ReLU operations
    task test_relu;
        input [DATA_W-1:0] input_val;
        input [DATA_W-1:0] expected;
        input string test_name;
        real input_real, expected_real;
        begin
            $display("=== Test %0d: %s ===", test_count, test_name);
            $display("Operation: RELU");
            
            input_real = fp32_to_real(input_val);
            expected_real = fp32_to_real(expected);
            
            $display("Input:  0x%08x (%0.6f)", input_val, input_real);
            
            // Apply inputs (operand1 is don't care for RELU)
            start = 1'b1;
            operand0 = input_val;
            operand1 = 32'h0;
            opcode = 4'd2; // RELU opcode
            
            #100; // Wait for propagation
            
            $display("Result:   0x%08x (%0.6f)", result_out, fp32_to_real(result_out));
            $display("Expected: 0x%08x (%0.6f)", expected, expected_real);
            
            if (result_out === expected) begin
                $display("PASS");
            end else begin
                $display("FAIL");
                error_count = error_count + 1;
            end
            
            test_count = test_count + 1;
            $display("");
            
            // Reset for next test
            start = 1'b0;
            #10;
        end
    endtask
    
    // Test start control
    task test_start_control;
        begin
            $display("=== Test %0d: Start Control ===", test_count);
            
            // Test with start = 0
            start = 1'b0;
            operand0 = 32'h41200000; // 10.0 in FP32
            operand1 = 32'h41a00000; // 20.0 in FP32
            opcode = 4'd0; // ADD
            
            #10;
            $display("Start=0: Result=0x%08x", result_out);
            
            if (result_out === 32'h0) begin
                $display("PASS: Output is zero when start=0");
            end else begin
                $display("FAIL: Expected zero output when start=0");
                error_count = error_count + 1;
            end
            
            // Test with start = 1
            start = 1'b1;
            #100;
            $display("Start=1: Result=0x%08x (%0.6f)", result_out, fp32_to_real(result_out));
            
            if (fp32_to_real(result_out) >= 29.999 && fp32_to_real(result_out) <= 30.001) begin
                $display("PASS: Correct operation when start=1");
            end else begin
                $display("FAIL: Incorrect operation when start=1");
                error_count = error_count + 1;
            end
            
            test_count = test_count + 1;
            $display("");
            
            // Reset
            start = 1'b0;
            #10;
        end
    endtask
    
    // Test invalid opcode
    task test_invalid_opcode;
        begin
            $display("=== Test %0d: Invalid Opcode ===", test_count);
            
            start = 1'b1;
            operand0 = 32'h41200000; // 10.0
            operand1 = 32'h41a00000; // 20.0
            opcode = 4'd15; // Invalid opcode
            
            #10;
            $display("Invalid opcode: Result=0x%08x", result_out);
            
            if (result_out === 32'h0) begin
                $display("PASS: Output is zero for invalid opcode");
            end else begin
                $display("FAIL: Expected zero output for invalid opcode");
                error_count = error_count + 1;
            end
            
            test_count = test_count + 1;
            $display("");
            
            // Reset
            start = 1'b0;
            #10;
        end
    endtask
    
    initial begin
        // Initialize
        start = 0;
        operand0 = 32'h0;
        operand1 = 32'h0;
        opcode = 4'h0;
        test_count = 1;
        error_count = 0;
        
        $display("Starting VPU Operation Tests (FP32)");
        $display("===================================");
        $display("");
        
        // FP32 test values
        // 10.0 = 0x41200000, 20.0 = 0x41a00000, 30.0 = 0x41f00000
        // 5.0 = 0x40a00000, 3.0 = 0x40400000, 8.0 = 0x41000000
        // -10.0 = 0xc1200000, 0.0 = 0x00000000
        // 4.0 = 0x40800000, 100.0 = 0x42c80000
        // 1.0 = 0x3f800000
        
        // Test ADD operations
        test_operation(32'h41200000, 32'h41a00000, 4'd0, 32'h41f00000, "ADD: 10.0 + 20.0 = 30.0");
        test_operation(32'h40a00000, 32'h40400000, 4'd0, 32'h41000000, "ADD: 5.0 + 3.0 = 8.0");
        test_operation(32'hc1200000, 32'h41200000, 4'd0, 32'h00000000, "ADD: -10.0 + 10.0 = 0.0");
        test_operation(32'hc1200000, 32'hc1200000, 4'd0, 32'hc1a00000, "ADD: -10.0 + -10.0 = -20.0");
        
        // Test SUB operations  
        test_operation(32'h41a00000, 32'h41200000, 4'd1, 32'h41200000, "SUB: 20.0 - 10.0 = 10.0");
        test_operation(32'h41200000, 32'h41a00000, 4'd1, 32'hc1200000, "SUB: 10.0 - 20.0 = -10.0");
        test_operation(32'h00000000, 32'h41200000, 4'd1, 32'hc1200000, "SUB: 0.0 - 10.0 = -10.0");
        test_operation(32'hc1200000, 32'hc1200000, 4'd1, 32'h00000000, "SUB: -10.0 - (-10.0) = 0.0");
        
        // Test MUL operations
        test_operation(32'h40a00000, 32'h40800000, 4'd3, 32'h41a00000, "MUL: 5.0 * 4.0 = 20.0");
        test_operation(32'h41200000, 32'h41200000, 4'd3, 32'h42c80000, "MUL: 10.0 * 10.0 = 100.0");
        test_operation(32'hc1200000, 32'h41200000, 4'd3, 32'hc2c80000, "MUL: -10.0 * 10.0 = -100.0");
        test_operation(32'hc1200000, 32'hc1200000, 4'd3, 32'h42c80000, "MUL: -10.0 * -10.0 = 100.0");
        test_operation(32'h00000000, 32'h41200000, 4'd3, 32'h00000000, "MUL: 0.0 * 10.0 = 0.0");
        test_operation(32'h3f800000, 32'h3f800000, 4'd3, 32'h3f800000, "MUL: 1.0 * 1.0 = 1.0");
        
        // Test ReLU operations
        test_relu(32'h41200000, 32'h41200000, "RELU: Positive input (10.0)");
        test_relu(32'h00000000, 32'h00000000, "RELU: Zero input");
        test_relu(32'hc1200000, 32'h00000000, "RELU: Negative input (-10.0)");
        test_relu(32'h7f7fffff, 32'h7f7fffff, "RELU: Large positive input (MAX_FLOAT)");
        test_relu(32'hff7fffff, 32'h00000000, "RELU: Large negative input (MIN_FLOAT)");
        
        // Test control signals
        test_start_control();
        
        // Test invalid opcode
        test_invalid_opcode();
        
        // Summary
        $display("=== TEST SUMMARY ===");
        $display("Total Tests: %0d", test_count - 1);
        $display("Errors: %0d", error_count);
        
        if (error_count == 0) begin
            $display("SUCCESS: All VPU operation tests passed!");
        end else begin
            $display("FAILURE: %0d tests failed", error_count);
        end
        
        $finish;
    end
    
    // Monitor for debugging
    always @(*) begin
        if (start) begin
            $display("[%0t] OP: %s, A=0x%08x(%0.3f), B=0x%08x(%0.3f), Result=0x%08x(%0.3f)", 
                     $time, get_op_name(opcode), operand0, fp32_to_real(operand0), 
                     operand1, fp32_to_real(operand1), result_out, fp32_to_real(result_out));
        end
    end
    
    // Timeout
    initial begin
        #1000000;
        $display("ERROR: Simulation timeout");
        $finish;
    end
    
endmodule
"""

    # Write testbench
    with open("build/test_vpu_op.sv", "w") as f:
        f.write(testbench_code)
    
    print("Testbench written to build/test_vpu_op.sv")
    
    # Use the actual source files
    source_files = []
    
    # Look for source files in common locations
    possible_paths = [
        "src_new/vpu_op.sv",
        "src_new/fp_adder.sv", 
        "src_new/fp_mul.sv",
    ]
    
    found_files = []
    for path in possible_paths:
        if os.path.exists(path):
            source_files.append(path)
            found_files.append(path)
            print(f"Found source file: {path}")
    
    if not found_files:
        print("ERROR: Could not find any source files")
        print("Please ensure the following files exist:")
        for path in possible_paths:
            print(f"  - {path}")
        return False
    
    # Compile and run
    print("Compiling...")
    compile_cmd = ["iverilog", "-o", "build/test_vpu_op", "-g2012", "build/test_vpu_op.sv"] + source_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Running simulation...")
    result = subprocess.run(["vvp", "build/test_vpu_op"], capture_output=True, text=True)
    
    print("=== SIMULATION OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    success = "SUCCESS: All VPU operation tests passed!" in result.stdout
    if success:
        print("VPU operation module is working correctly!")
    else:
        print("VPU operation module has issues")
    
    return success

if __name__ == "__main__":
    test_vpu_op()