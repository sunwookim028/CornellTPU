# Design Configuration for PE (Processing Element) Module
# Target: SkyWater 130nm High Density (sky130hd)
# Clock: 100MHz (10ns period)

export DESIGN_NAME = pe
export PLATFORM    = sky130hd

# Source files - PE module and its FP32 arithmetic dependencies
# Using SystemVerilog with Yosys -sv flag
export VERILOG_FILES = \
    $(DESIGN_HOME)/src/pe/pe.sv \
    $(DESIGN_HOME)/src/pe/fp32_mul.sv \
    $(DESIGN_HOME)/src/pe/fp32_add.sv \
    $(DESIGN_HOME)/src/pe/fixedpoint.sv

export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/pe/constraint.sdc

# Physical design parameters
export CORE_UTILIZATION = 45
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT = 100

# Disable adder optimization (can interfere with FP adders)
export ADDER_MAP_FILE :=
