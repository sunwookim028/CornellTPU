# Create a clock on the 'clk' port (100 MHz)
create_clock -name clk -period 10.000 [get_ports clk]

# Tell Vivado this clock is the main timing reference
 set_clock_groups -asynchronous -group [get_clocks clk]