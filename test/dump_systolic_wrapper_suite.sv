  module dump();
  initial begin
    $dumpfile("waveforms/systolic_wrapper_suite.vcd");
    $dumpvars(0, top_systolic_test); 
  end
  endmodule