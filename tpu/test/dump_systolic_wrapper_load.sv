  module dump();
  initial begin
    $dumpfile("waveforms/systolic_wrapper_load.vcd");
    $dumpvars(0, top_systolic_test); 
  end
  endmodule