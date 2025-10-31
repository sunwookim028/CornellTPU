  module dump();
  initial begin
    $dumpfile("waveforms/systolic_wrapper.vcd");
    $dumpvars(0, systolic_wrapper); 
  end
  endmodule