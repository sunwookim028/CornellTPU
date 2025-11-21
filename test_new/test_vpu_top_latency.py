import os
import subprocess

def test_vpu_top():
    """Test the VPU top module with memory interface signals"""

    os.makedirs("build", exist_ok=True)

    # Create testbench
    testbench_code = """
`timescale 1ns/1ps

module test_vpu_top;
    parameter DATA_W = 32;
    parameter ADDR_W = 16;
    parameter OP_W = 4;
    parameter INST_ADDR = 5;
    
    // Clock and reset
    reg clk;
    reg rst;
    
    // VPU inputs
    reg [31:0] inst;
    reg mem_rdy;
    reg mem_read_en;
    reg mem_write_en;
    
    // VPU outputs
    wire [ADDR_W-1:0] addr_a;
    wire [ADDR_W-1:0] addr_b;
    wire [ADDR_W-1:0] addr_c;
    wire [DATA_W-1:0] data_c;
    wire done;
    
    // Memory interface inputs
    reg [DATA_W-1:0] data_a;
    reg [DATA_W-1:0] data_b;
    
    // Test memory
    reg [31:0] test_memory [0:31];
    integer test_count;
    integer error_count;
    
    // Instantiate DUT
    vpu_top dut (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .mem_rdy(mem_rdy),
        .mem_read_en(mem_read_en),
        .mem_write_en(mem_write_en),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .addr_c(addr_c),
        .data_a(data_a),
        .data_b(data_b),
        .data_c(data_c),
        .done(done)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Helper function to create instruction
    function [31:0] create_instruction;
        input [INST_ADDR-1:0] a_addr;
        input [INST_ADDR-1:0] b_addr;
        input [INST_ADDR-1:0] c_addr;
        input [INST_ADDR-1:0] const_addr;
        input [OP_W-1:0] opcode;
        begin
            create_instruction = {8'h00, const_addr, c_addr, b_addr, a_addr, opcode};
            //        reserved|const| c   |  b   |  a   |opcode
            // bits:    8     |  5  |  5  |  5   |  5   |  4
        end
    endfunction
    
    // Helper function to print state
    function string get_state_name;
        input [2:0] state;
        case (state)
            3'd0: get_state_name = "IDLE      ";
            3'd1: get_state_name = "DATA_A    ";
            3'd2: get_state_name = "DATA_B    ";
            3'd3: get_state_name = "DATA_CONST";
            3'd4: get_state_name = "PROCESSING";
            3'd5: get_state_name = "DATA_C    ";
            default: get_state_name = "UNKNOWN  ";
        endcase
    endfunction
    
    // Memory response task
    task memory_response;
      begin
          mem_read_en = 1'b0;
          mem_write_en = 1'b0;
          data_a = 32'h0;
          data_b = 32'h0;
          
          case (dut.current_state)
              dut.DATA_A: begin
                  if (addr_a < 32) begin
                      data_a = test_memory[addr_a];
                      mem_read_en = 1'b1;
                      $display("  Memory Read A: addr=%0d, data=0x%08x", addr_a, data_a);
                  end
              end
              dut.DATA_B: begin
                  if (addr_b < 32) begin
                      data_b = test_memory[addr_b];
                      mem_read_en = 1'b1;
                      $display("  Memory Read B: addr=%0d, data=0x%08x", addr_b, data_b);
                  end
              end
              dut.DATA_CONST: begin
                  if (addr_b < 32) begin
                      data_b = test_memory[addr_b];
                      mem_read_en = 1'b1;
                      $display("  Memory Read CONST: addr=%0d, data=0x%08x", addr_b, data_b);
                  end
              end
              dut.DATA_C: begin
                  if (addr_c < 32) begin
                      test_memory[addr_c] = data_c;
                      mem_write_en = 1'b1;
                      $display("  Memory Write C: addr=%0d, data=0x%08x", addr_c, data_c);
                  end
              end
          endcase
      end
  endtask
      
    // Test task
    task test_instruction;
        input [31:0] instruction;
        input [DATA_W-1:0] expected_result;
        input string test_name;
        input [INST_ADDR-1:0] result_addr;
        integer cycles;
        begin
            cycles = 0;
            
            $display("=== Test %0d: %s ===", test_count, test_name);
            $display("Instruction: 0x%08x", instruction);
            $display("Time | State       | Addr_A | Addr_B | Addr_C | Data_C  | Done | MemRdy | MemRE | MemWE");
            $display("-----|-------------|--------|--------|--------|---------|------|--------|-------|------");
            
            // Apply instruction
            @(posedge clk);
            inst = instruction;
            mem_rdy = 1'b1;
            
            // Wait for completion
            while (!done && cycles < 20) begin
                memory_response();
                @(posedge clk);
                
                $display("%4d | %s | %6d | %6d | %6d | %8x | %4b | %6b | %5b | %5b",
                         $time, get_state_name(dut.current_state), 
                         addr_a, addr_b, addr_c, data_c, done,
                         mem_rdy, mem_read_en, mem_write_en);
                
                cycles = cycles + 1;
            end
            
            if (cycles >= 20) begin
                $display("ERROR: Timeout");
                error_count = error_count + 1;
            end else begin
                // Check result
                if (test_memory[result_addr] === expected_result) begin
                    $display("PASS: Result 0x%08x", test_memory[result_addr]);
                end else begin
                    $display("FAIL: Got 0x%08x, expected 0x%08x", 
                             test_memory[result_addr], expected_result);
                    error_count = error_count + 1;
                end
                $display("Completed in %0d cycles", cycles);
            end
            
            test_count = test_count + 1;
            
            // Wait between tests
            mem_rdy = 1'b0;
            @(posedge clk);
            @(posedge clk);
        end
    endtask
    
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        inst = 32'h0;
        mem_rdy = 1'b0;
        mem_read_en = 1'b0;
        mem_write_en = 1'b0;
        data_a = 32'h0;
        data_b = 32'h0;
        test_count = 1;
        error_count = 0;
        
        // Initialize test memory
        for (integer i = 0; i < 32; i = i + 1) begin
            test_memory[i] = 32'h0;
        end
        
        // Load test data
        test_memory[1] = 32'h0000000A;  // 10
        test_memory[2] = 32'h00000014;  // 20  
        test_memory[3] = 32'h00000005;  // 5
        test_memory[4] = 32'hFFFFFFF6;  // -10
        test_memory[5] = 32'h00000003;  // constant 3
        
        $display("Starting VPU Tests with Memory Interface");
        $display("========================================");
        
        // Reset
        #20;
        rst = 0;
        #20;
        
        @(posedge clk);
        
        // Test 1: ADD 10 + 20 = 30
        test_instruction(
            create_instruction(1, 2, 10, 5, 4'd0),  // ADD with constant
            32'h0000001E,  // 30
            "ADD: 10 + 20 = 30",
            10
        );
        
        // Test 2: SUB 20 - 10 = 10  
        test_instruction(
            create_instruction(2, 1, 11, 5, 4'd1),  // SUB with constant
            32'h0000000A,  // 10
            "SUB: 20 - 10 = 10",
            11
        );
        
        // Test 3: ADD 10 + 5 = 15
        test_instruction(
            create_instruction(1, 3, 12, 5, 4'd0),  // ADD with constant
            32'h0000000F,  // 15
            "ADD: 10 + 5 = 15", 
            12
        );
        
        // Test 4: RELU(10) = 10
        test_instruction(
            create_instruction(1, 0, 13, 5, 4'd2),  // RELU with constant
            32'h0000000A,  // 10
            "RELU: RELU(10) = 10",
            13
        );
        
        // Test 5: RELU(-10) = 0
        test_instruction(
            create_instruction(4, 0, 14, 5, 4'd2),  // RELU with constant
            32'h00000000,  // 0
            "RELU: RELU(-10) = 0",
            14
        );
        
        // Summary
        $display("=== TEST SUMMARY ===");
        $display("Total Tests: %0d", test_count - 1);
        $display("Errors: %0d", error_count);
        
        if (error_count == 0) begin
            $display("SUCCESS: All tests passed!");
        end else begin
            $display("FAILURE: %0d tests failed", error_count);
        end
        
        $finish;
    end
    
    // Monitor internal signals
    always @(posedge clk) begin
        if (!rst && dut.vpu_op_start) begin
            $display("  Operation Start: A=0x%08x, B=0x%08x, Op=%0d", 
                     dut.a_val, dut.b_val, dut.opcode);
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
    with open("build/test_vpu_top.sv", "w") as f:
        f.write(testbench_code)
    
    print("Testbench written to build/test_vpu_top.sv")
    
    # Find source files automatically
    source_files = []
    
    # Look for vpu_top.sv
    vpu_top_paths = [
        "src_new/vpu_top.sv",
    ]
    
    vpu_top_found = False
    for path in vpu_top_paths:
        if os.path.exists(path):
            source_files.append(path)
            vpu_top_found = True
            print(f"Found vpu_top.sv at: {path}")
            break
    
    if not vpu_top_found:
        print("ERROR: Could not find vpu_top.sv file")
        print("Please ensure vpu_top.sv is in one of these locations:")
        for path in vpu_top_paths:
            print(f"  - {path}")
        return False
    
    # Look for vpu_op.sv (dependency)
    vpu_op_paths = [
        "src_new/vpu_op.sv",
    ]
    
    vpu_op_found = False
    for path in vpu_op_paths:
        if os.path.exists(path):
            source_files.append(path)
            vpu_op_found = True
            print(f"Found vpu_op.sv at: {path}")
            break
    
    if not vpu_op_found:
        print("ERROR: Could not find vpu_op.sv file")
        print("Please ensure vpu_op.sv is in one of these locations:")
        for path in vpu_op_paths:
            print(f"  - {path}")
        return False
    
    # Look for parameterized_adder.sv (dependency)
    adder_paths = [
        "src_new/fp_adder.sv", 
    ]
    
    adder_found = False
    for path in adder_paths:
        if os.path.exists(path):
            source_files.append(path)
            adder_found = True
            print(f"Found parameterized_adder.sv at: {path}")
            break
    
    # If parameterized_adder not found, create a simple one for simulation
    if not adder_found:
        print("Creating simple parameterized_adder for simulation...")
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
        source_files.append("build/parameterized_adder.sv")
    
    # Compile and run
    print("Compiling...")
    compile_cmd = ["iverilog", "-o", "build/test_vpu_top", "-g2012", "build/test_vpu_top.sv"] + source_files
    result = subprocess.run(compile_cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print("COMPILATION FAILED:")
        print(result.stderr)
        return False
    
    print("Running simulation...")
    result = subprocess.run(["vvp", "build/test_vpu_top"], capture_output=True, text=True)
    
    print("=== SIMULATION OUTPUT ===")
    print(result.stdout)
    
    if result.stderr:
        print("=== ERRORS ===")
        print(result.stderr)
    
    success = "SUCCESS: All tests passed!" in result.stdout
    if success:
        print("VPU top module is working correctly!")
    else:
        print("VPU top module has issues")
    
    return success

if __name__ == "__main__":
    test_vpu_top()