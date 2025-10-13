  module dump();
  initial begin
    $dumpfile("waveforms/random_systolic.vcd");
    $dumpvars(0, systolic); 
  end
  endmodule