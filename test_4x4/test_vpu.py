# test_4x4/test_vpu.py
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
        "src_4x4/vpu_dpath.sv",
        "src_4x4/vpu_ctrl.sv",
        "src_4x4/vpu.sv"
    ]
    
    # Create testbench with decimal format display
    testbench_code = """
`timescale 1ns/1ps
`default_nettype none

module vpu_tb;
  parameter int DATA_W = 16;
  parameter int ADDR_W = 10;
  parameter int B = 8;
  parameter int D_OUT = 4;
  
  logic clk, rst;
  logic ub_req_rdy, ub_req_val;
  logic [ADDR_W-1:0] addr_Z_prime, addr_b, addr_Z;
  logic [63:0] data_Z_prime [0:7];
  logic [63:0] data_b;
  logic [63:0] data_Z [0:7];
  logic [3:0] vpu_data_pathway;
  logic vpu_busy;
  
  logic signed [DATA_W-1:0] debug_vpu_out_1, debug_vpu_out_2, debug_vpu_out_3, debug_vpu_out_4;
  logic debug_valid_out;
  
  logic test_done;
  int error_count;
  
  // Instantiate DUT
  vpu #(
    .DATA_W(DATA_W), .ADDR_W(ADDR_W), .B(B), .D_OUT(D_OUT)
  ) dut (.*);
  
  // Memory
  logic [63:0] memory_Z_prime [0:1023];
  logic [63:0] memory_b [0:1023];
  logic [63:0] memory_Z [0:1023];
  
  // Memory initialization - using decimal values for clarity
  initial begin
    for (int i = 0; i < 1024; i++) begin
      memory_Z_prime[i] = {16'd256, 16'd512, 16'd768, 16'd1024}; // [1.0, 2.0, 3.0, 4.0]
      memory_b[i] = {16'd128, 16'd128, 16'd128, 16'd128};        // [0.5, 0.5, 0.5, 0.5]
      memory_Z[i] = 64'hDEADBEEFDEADBEEF;
    end
  end
  
  // Memory access
  always_ff @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < 8; i++) data_Z_prime[i] <= '0;
      data_b <= '0;
    end else if (ub_req_val) begin
      for (int i = 0; i < 8; i++) data_Z_prime[i] <= memory_Z_prime[addr_Z_prime + i];
      data_b <= memory_b[addr_b];
    end
  end
  
  // Memory write
  always_ff @(posedge clk) begin
    if (!rst && ub_req_val && (addr_Z < 1024)) begin
      for (int i = 0; i < 8; i++) begin
        memory_Z[addr_Z + i] <= data_Z[i];
      end
    end
  end
  
  assign ub_req_rdy = 1'b1;
  
  // Clock and reset
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    rst = 1;
    #100 rst = 0;
  end
  
  // Test sequence
  initial begin
    test_done = 0;
    error_count = 0;
    vpu_data_pathway = 0;
    
    @(negedge rst);
    #100;
    
    // Test 1: Basic forward pass
    $display("=== TEST 1: Forward Pass ===");
    $display("Input: [1.0, 2.0, 3.0, 4.0] + [0.5, 0.5, 0.5, 0.5]");
    $display("Expected: [1.5, 2.5, 3.5, 4.5]");
    
    vpu_data_pathway = 4'b1100;
    @(posedge vpu_busy);
    while (vpu_busy) @(posedge clk);
    repeat (20) @(posedge clk);
    
    check_results(0, "Test 1");
    
    // Test 2: Different pattern
    $display("=== TEST 2: Different Pattern ===");
    for (int i = 0; i < 8; i++) begin
      memory_Z_prime[i] = {16'd64, 16'd65408, 16'd192, 16'd65280}; // [0.25, -0.5, 0.75, -1.0]
    end
    memory_b[0] = {16'd128, 16'd128, 16'd128, 16'd128}; // [0.5, 0.5, 0.5, 0.5]
    
    vpu_data_pathway = 4'b1100;
    @(posedge vpu_busy);
    while (vpu_busy) @(posedge clk);
    repeat (20) @(posedge clk);
    
    check_results(8, "Test 2");
    
    // Summary
    $display("=== SUMMARY ===");
    if (error_count == 0) begin
      $display("ALL TESTS PASSED");
    end else begin
      $display("%0d ERRORS", error_count);
    end
    
    test_done = 1;
    #100 $finish;
  end
  
  // Function to convert 16-bit fixed point to decimal string
  function string fixed_to_string(input logic [15:0] val);
    real decimal_val;
    decimal_val = $itor($signed(val)) / 256.0;
    return $sformatf("%0.3f", decimal_val);
  endfunction
  
  // Function to display 64-bit vector as decimal values
  function string vector_to_string(input logic [63:0] vec);
    return $sformatf("[%s, %s, %s, %s]", 
                    fixed_to_string(vec[63:48]),
                    fixed_to_string(vec[47:32]), 
                    fixed_to_string(vec[31:16]),
                    fixed_to_string(vec[15:0]));
  endfunction
  
  task check_results(input int base_addr, input string test_name);
    int errors = 0;
    logic [63:0] expected_Z_prime, expected_b, expected;
    
    $display("Checking memory_Z[%0d:%0d]:", base_addr, base_addr+7);
    
    for (int i = 0; i < 8; i++) begin
      logic [63:0] result = memory_Z[base_addr + i];
      
      if (result === 64'hDEADBEEFDEADBEEF) begin
        $display("  [%0d]: NOT WRITTEN", i);
        errors++;
      end else begin
        // Calculate expected value
        expected_Z_prime = memory_Z_prime[i];
        expected_b = memory_b[0];
        expected[63:48] = $signed(expected_Z_prime[63:48]) + $signed(expected_b[63:48]);
        expected[47:32] = $signed(expected_Z_prime[47:32]) + $signed(expected_b[47:32]);
        expected[31:16] = $signed(expected_Z_prime[31:16]) + $signed(expected_b[31:16]);
        expected[15:0]  = $signed(expected_Z_prime[15:0]) + $signed(expected_b[15:0]);
        
        $display("  [%0d]: %s", i, vector_to_string(result));
        
        if (result !== expected) begin
          $display("    EXPECTED: %s", vector_to_string(expected));
          errors++;
        end
      end
    end
    
    if (errors > 0) begin
      error_count += errors;
      $display("  %s: %0d ERRORS", test_name, errors);
    end else begin
      $display("  %s: PASS", test_name);
    end
  endtask
  
  // Monitor VPU internal activity with decimal display
  always @(posedge clk) begin
    if (!rst) begin
      // Display buffering activity
      if (dut.ctrl_inst.current_state == dut.ctrl_inst.WAIT_Z_PRIME && 
          dut.ctrl_inst.mem_delay_ctr == 2'd1) begin
        $display("Time: %0t - Buffering Z_prime inputs", $time);
        for (int i = 0; i < 8; i++) begin
          $display("  Z_prime[%0d]: %s", i, vector_to_string(data_Z_prime[i]));
        end
      end
      
      if (dut.ctrl_inst.current_state == dut.ctrl_inst.WAIT_BIAS && 
          dut.ctrl_inst.mem_delay_ctr == 2'd1) begin
        $display("Time: %0t - Buffering bias: %s", $time, vector_to_string(data_b));
      end
      
      // Display output storage
      if (dut.ctrl_inst.vpu_valid_out_1 && dut.ctrl_inst.current_state == dut.ctrl_inst.PROCESSING) begin
        $display("Time: %0t - Storing output vector %0d: %s", 
                 $time, dut.ctrl_inst.vector_ctr,
                 vector_to_string({dut.ctrl_inst.vpu_data_out_1, dut.ctrl_inst.vpu_data_out_2, 
                                 dut.ctrl_inst.vpu_data_out_3, dut.ctrl_inst.vpu_data_out_4}));
      end
    end
  end
  
  // Timeout
  initial begin
    #100000;
    if (!test_done) begin
      $display("!!! TIMEOUT !!!");
      $finish;
    end
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
    
    # Check results
    success = ("PASS" in result.stdout and "ERRORS" not in result.stdout)
    
    if success:
        print("SUCCESS: VPU module is functioning correctly!")
    else:
        print("ISSUE: VPU module has errors")
    
    return success

if __name__ == "__main__":
    test_vpu_verilog()