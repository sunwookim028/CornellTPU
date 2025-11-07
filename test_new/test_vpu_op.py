# test_vpu/test_vpu_op.py
import os
import subprocess

def test_vpu_op():
    """Test the VPU operation module with various ALU operations"""
    
    os.makedirs("build", exist_ok=True)
    
    # Create testbench
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
            default: get_op_name = "UNKN";
        endcase
    endfunction
    
    // Test task for basic operations
    task test_operation;
        input [DATA_W-1:0] op0;
        input [DATA_W-1:0] op1;
        input [OP_W-1:0] op;
        input [DATA_W-1:0] expected;
        input string test_name;
        begin
            $display("=== Test %0d: %s ===", test_count, test_name);
            $display("Operation: %s", get_op_name(op));
            $display("Operand0: 0x%08x (%0d)", op0, $signed(op0));
            $display("Operand1: 0x%08x (%0d)", op1, $signed(op1));
            
            // Apply inputs
            start = 1'b1;
            operand0 = op0;
            operand1 = op1;
            opcode = op;
            
            #10; // Wait for propagation
            
            $display("Result:   0x%08x (%0d)", result_out, $signed(result_out));
            $display("Expected: 0x%08x (%0d)", expected, $signed(expected));
            
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
    
    // Test task for ReLU operations
    task test_relu;
        input [DATA_W-1:0] input_val;
        input [DATA_W-1:0] expected;
        input string test_name;
        begin
            $display("=== Test %0d: %s ===", test_count, test_name);
            $display("Operation: RELU");
            $display("Input:  0x%08x (%0d)", input_val, $signed(input_val));
            
            // Apply inputs (operand1 is don't care for RELU)
            start = 1'b1;
            operand0 = input_val;
            operand1 = 32'h0;
            opcode = 4'd2; // RELU opcode
            
            #10; // Wait for propagation
            
            $display("Result:   0x%08x (%0d)", result_out, $signed(result_out));
            $display("Expected: 0x%08x (%0d)", expected, $signed(expected));
            
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
            operand0 = 32'h0000000A;
            operand1 = 32'h00000014;
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
            #10;
            $display("Start=1: Result=0x%08x", result_out);
            
            if (result_out === 32'h0000001E) begin
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
            operand0 = 32'h0000000A;
            operand1 = 32'h00000014;
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
        
        $display("Starting VPU Operation Tests");
        $display("============================");
        $display("");
        
        // Test ADD operations
        test_operation(32'h0000000A, 32'h00000014, 4'd0, 32'h0000001E, "ADD: 10 + 20 = 30");
        test_operation(32'h00000005, 32'h00000003, 4'd0, 32'h00000008, "ADD: 5 + 3 = 8");
        test_operation(32'hFFFFFFF6, 32'h0000000A, 4'd0, 32'h00000000, "ADD: -10 + 10 = 0");
        test_operation(32'hFFFFFFF6, 32'hFFFFFFF6, 4'd0, 32'hFFFFFFEC, "ADD: -10 + -10 = -20");
        
        // Test SUB operations  
        test_operation(32'h00000014, 32'h0000000A, 4'd1, 32'h0000000A, "SUB: 20 - 10 = 10");
        test_operation(32'h0000000A, 32'h00000014, 4'd1, 32'hFFFFFFF6, "SUB: 10 - 20 = -10");
        test_operation(32'h00000000, 32'h0000000A, 4'd1, 32'hFFFFFFF6, "SUB: 0 - 10 = -10");
        test_operation(32'hFFFFFFF6, 32'hFFFFFFF6, 4'd1, 32'h00000000, "SUB: -10 - (-10) = 0");
        
        // Test ReLU operations
        test_relu(32'h0000000A, 32'h0000000A, "RELU: Positive input (10)");
        test_relu(32'h00000000, 32'h00000000, "RELU: Zero input");
        test_relu(32'hFFFFFFF6, 32'h00000000, "RELU: Negative input (-10)");
        test_relu(32'h7FFFFFFF, 32'h7FFFFFFF, "RELU: Large positive input");
        test_relu(32'h80000000, 32'h00000000, "RELU: Large negative input");
        
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
            $display("[%0t] OP: %s, A=0x%08x, B=0x%08x, Result=0x%08x", 
                     $time, get_op_name(opcode), operand0, operand1, result_out);
        end
    end
    
    // Timeout
    initial begin
        #100000;
        $display("ERROR: Simulation timeout");
        $finish;
    end
    
endmodule
"""

    # Write testbench
    with open("build/test_vpu_op.sv", "w") as f:
        f.write(testbench_code)
    
    print("Testbench written to build/test_vpu_op.sv")
    
    # Create a simple parameterized_adder module for simulation (since your vpu_op uses it)
    parameterized_adder_code = """
module parameterized_adder #(
    parameter FORMAT = "FP32"
)(
    input logic [31:0] a,
    input logic [31:0] b, 
    output logic [31:0] result
);

// Simple integer adder for simulation
// In real implementation, this would be FP32 adder
assign result = $signed(a) + $signed(b);

endmodule
"""
    
    with open("build/parameterized_adder.sv", "w") as f:
        f.write(parameterized_adder_code)
    
    # Use the actual vpu_op.sv file from your source directory
    # Assuming your vpu_op.sv is in the current directory or a src directory
    source_files = []
    
    # Look for vpu_op.sv in common locations
    possible_paths = [
        "src_new/vpu_op.sv",
        "src_new/fp_adder.sv"
    ]
    
    vpu_op_found = False
    for path in possible_paths:
        if os.path.exists(path):
            source_files.append(path)
            vpu_op_found = True
            print(f"Found vpu_op.sv at: {path}")
            break
    
    if not vpu_op_found:
        print("ERROR: Could not find vpu_op.sv file")
        print("Please ensure vpu_op.sv is in one of these locations:")
        for path in possible_paths:
            print(f"  - {path}")
        return False
    
    # Add the parameterized_adder to the source files
    source_files.append("build/parameterized_adder.sv")
    
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