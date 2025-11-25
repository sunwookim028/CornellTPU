#================DO NOT MODIFY BELOW===================== Compiler and simulator settings
IVERILOG = iverilog
VVP = vvp
COCOTB_PREFIX = $(shell cocotb-config --prefix)

COCOTB_LIBS = $(COCOTB_PREFIX)/cocotb/libs

SIM_BUILD_DIR = sim_build
SIM_VVP = $(SIM_BUILD_DIR)/sim.vvp

# Environment variables
export COCOTB_REDUCED_LOG_FMT=1
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)
# point PYTHONPATH to the new test folder
export PYTHONPATH := tpu/test:$(PYTHONPATH)

#=============== MODIFY BELOW ======================
# ********** IF YOU HAVE A NEW VERILOG FILE, ADD IT TO THE SOURCES VARIABLE
SOURCES = tpu/src/pe.sv \
          tpu/src/systolic.sv \
          tpu/src/systolic_wrapper.sv \
          tpu/src/mock_memory.sv \
          tpu/src/fixedpoint.sv \
          tpu/src/fp32_add.sv \
          tpu/src/fp32_mul.sv \
#           tpu/src/top_systolic_test.sv 

# Test targets
test_fp32_mul: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s fp32_mul -g2012 $(SOURCES) tpu/test/dump_fp32_mul.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_fp32_mul $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv fp32_mul.vcd waveforms/ 2>/dev/null || true

test_fp32_add: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s fp32_add -g2012 $(SOURCES) tpu/test/dump_fp32_add.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_fp32_add $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv fp32_add.vcd waveforms/ 2>/dev/null || true

test_pe: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s pe -s dump -g2012 $(SOURCES) tpu/test/dump_pe.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_pe $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv pe.vcd waveforms/ 2>/dev/null || true

test_systolic: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic -s dump -g2012 $(SOURCES) tpu/test/dump_systolic.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv systolic.vcd waveforms/ 2>/dev/null || true

test_systolic_4x4: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic -s dump -g2012 $(SOURCES) tpu/test/dump_systolic_4x4.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_4x4 $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv systolic_4x4.vcd waveforms/ 2>/dev/null || true

test_systolic_5x5: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic -g2012 $(SOURCES) tpu/test/dump_systolic_5x5.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_5x5 $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv systolic_5x5.vcd waveforms/ 2>/dev/null || true

test_systolic_16x16: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic -g2012 $(SOURCES) tpu/test/dump_systolic_16x16.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_16x16 $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv systolic_16x16.vcd waveforms/ 2>/dev/null || true

test_random_systolic: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic -s dump -g2012 $(SOURCES) tpu/test/dump_random_systolic.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_random_systolic $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv dump_random_systolic.vcd waveforms/ 2>/dev/null || true

test_systolic_wrapper_adhoc: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic_wrapper -s dump -g2012 $(SOURCES) tpu/test/dump_systolic_wrapper_adhoc.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_wrapper_adhoc $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv dump_random_systolic.vcd waveforms/ 2>/dev/null || true

test_systolic_wrapper_random: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s systolic_wrapper -s dump -g2012 $(SOURCES) tpu/test/dump_systolic_wrapper_random.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_wrapper_random $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv dump_random_systolic.vcd waveforms/ 2>/dev/null || true

test_systolic_wrapper_load: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s top_systolic_test -s dump -g2012 $(SOURCES) tpu/test/dump_systolic_wrapper_load.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_wrapper_load $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv dump_random_systolic.vcd waveforms/ 2>/dev/null || true

test_systolic_wrapper_suite: $(SIM_BUILD_DIR)
	$(IVERILOG) -o $(SIM_VVP) -s top_systolic_test -s dump -g2012 $(SOURCES) tpu/test/dump_systolic_wrapper_suite.sv
	PYTHONOPTIMIZE=$(NOASSERT) MODULE=test_systolic_wrapper_suite $(VVP) -M $(COCOTB_LIBS) -m libcocotbvpi_icarus $(SIM_VVP)
	! grep failure results.xml
	mv dump_random_systolic.vcd waveforms/ 2>/dev/null || true


# ============ DO NOT MODIFY BELOW THIS LINE ==============

# Create simulation build directory and waveforms directory
$(SIM_BUILD_DIR):
	mkdir -p $(SIM_BUILD_DIR)
	mkdir -p waveforms

# Waveform viewing
show_%: waveforms/%.vcd waveforms/%.gtkw
	gtkwave $^

# Linting
lint:
	verible-verilog-lint tpu/src/*sv --rules_config verible.rules

# Cleanup
clean:
	rm -rf waveforms/*vcd $(SIM_BUILD_DIR) tpu/test/__pycache__

.PHONY: clean
