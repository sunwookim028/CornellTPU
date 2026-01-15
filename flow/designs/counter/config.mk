export DESIGN_NAME = counter
export PLATFORM    = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/src/counter/counter.v
export SDC_FILE      = $(DESIGN_HOME)/src/counter/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY = 0.5
