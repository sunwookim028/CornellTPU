  module dump();
  initial begin
    $dumpfile("waveforms/systolic_4x4.vcd");
    $dumpvars(0, systolic); 
  end
  endmodule