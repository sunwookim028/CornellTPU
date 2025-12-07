  module dump();
  initial begin
    $dumpfile("waveforms/systolic_wrapper_random.vcd");
    $dumpvars(0, systolic_wrapper); 
  end
  endmodule