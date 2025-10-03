import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


def to_fixed(val, frac_bits=8):
    scaled = int(round(val * (1 << frac_bits)))
    return scaled & 0xFFFF


@cocotb.test()
async def test_reset(dut):
    """Check that reset clears DUT internal registers."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Check internal signals
    assert dut.wr_ptr.value == 0
    for i in range(2):  # SYSTOLIC_ARRAY_WIDTH = 2
        assert dut.ub_rd_input_data_out[i].value == 0
        assert dut.ub_rd_input_valid_out[i].value == 0
        assert dut.ub_rd_weight_data_out[i].value == 0
        assert dut.ub_rd_weight_valid_out[i].value == 0
        assert dut.ub_rd_bias_data_out[i].value == 0
        assert dut.ub_rd_Y_data_out[i].value == 0
        assert dut.ub_rd_H_data_out[i].value == 0


@cocotb.test()
async def test_basic_host_write(dut):
    """Write a single value via host interface and check handshake."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.ub_wr_host_data_in[0].value = to_fixed(42)
    dut.ub_wr_host_valid_in[0].value = 1
    await RisingEdge(dut.clk)

    dut.ub_wr_host_valid_in[0].value = 0
    await RisingEdge(dut.clk)

    # TODO: add a check that UB accepted the value (depends on your DUT signals)


@cocotb.test()
async def test_read_transpose(dut):
    """Write 2x2 block and check transpose read order."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Write a 2x2 block
    dut.ub_wr_host_data_in[0].value = to_fixed(1)
    dut.ub_wr_host_valid_in[0].value = 1
    dut.ub_wr_host_data_in[1].value = to_fixed(2)
    dut.ub_wr_host_valid_in[1].value = 1
    await RisingEdge(dut.clk)

    dut.ub_wr_host_valid_in[0].value = 0
    dut.ub_wr_host_valid_in[1].value = 0
    await RisingEdge(dut.clk)

    # Trigger transpose read
    dut.ub_rd_start_in.value = 1
    dut.ub_ptr_select.value = 0
    dut.ub_rd_addr_in.value = 0
    dut.ub_rd_row_size.value = 2
    dut.ub_rd_col_size.value = 2
    dut.ub_rd_transpose.value = 1
    await RisingEdge(dut.clk)

    # TODO: check dut.ub_rd_data_out values cycle by cycle
    dut.ub_rd_start_in.value = 0
    await ClockCycles(dut.clk, 5)

@cocotb.test()
async def test_host_write_memory(dut):
    """Write via host interface and check internal memory."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Write two values from host
    dut.ub_wr_host_data_in[0].value = to_fixed(10)
    dut.ub_wr_host_valid_in[0].value = 1
    dut.ub_wr_host_data_in[1].value = to_fixed(20)
    dut.ub_wr_host_valid_in[1].value = 1
    await RisingEdge(dut.clk)
    
    dut.ub_wr_host_valid_in[0].value = 0
    dut.ub_wr_host_valid_in[1].value = 0
    await RisingEdge(dut.clk)

    # Check that values appear in internal memory (first two positions)
    assert dut.ub_memory[0].value == to_fixed(10)
    assert dut.ub_memory[1].value == to_fixed(20)

@cocotb.test()
async def test_read_row_major(dut):
    """Write 2x2 block and read in normal row-major order."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Write 2x2 block
    dut.ub_wr_host_data_in[0].value = to_fixed(1)
    dut.ub_wr_host_valid_in[0].value = 1
    dut.ub_wr_host_data_in[1].value = to_fixed(2)
    dut.ub_wr_host_valid_in[1].value = 1
    await RisingEdge(dut.clk)

    dut.ub_wr_host_valid_in[0].value = 0
    dut.ub_wr_host_valid_in[1].value = 0
    await RisingEdge(dut.clk)

    # Trigger read (ptr_select = 0)
    dut.ub_rd_start_in.value = 1
    dut.ub_ptr_select.value = 0
    dut.ub_rd_addr_in.value = 0
    dut.ub_rd_row_size.value = 2
    dut.ub_rd_col_size.value = 2
    dut.ub_rd_transpose.value = 0
    await RisingEdge(dut.clk)
    dut.ub_rd_start_in.value = 0

    # Cycle through output
    for _ in range(4):
        await RisingEdge(dut.clk)
        # TODO: Add assertions based on expected row-major order

@cocotb.test()
async def test_read_transposed(dut):
    """Read a 2x2 block in transpose mode."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Write 2x2 block
    dut.ub_wr_host_data_in[0].value = to_fixed(1)
    dut.ub_wr_host_valid_in[0].value = 1
    dut.ub_wr_host_data_in[1].value = to_fixed(2)
    dut.ub_wr_host_valid_in[1].value = 1
    await RisingEdge(dut.clk)

    dut.ub_wr_host_valid_in[0].value = 0
    dut.ub_wr_host_valid_in[1].value = 0
    await RisingEdge(dut.clk)

    # Trigger transpose read
    dut.ub_rd_start_in.value = 1
    dut.ub_ptr_select.value = 0
    dut.ub_rd_addr_in.value = 0
    dut.ub_rd_row_size.value = 2
    dut.ub_rd_col_size.value = 2
    dut.ub_rd_transpose.value = 1
    await RisingEdge(dut.clk)
    dut.ub_rd_start_in.value = 0

    for _ in range(4):
        await RisingEdge(dut.clk)
        # TODO: Check outputs reflect transposed order

@cocotb.test()
async def test_gradient_descent_write(dut):
    """Check that gradient descent updates UB memory."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Set gradient descent pointer
    dut.ub_rd_start_in.value = 1
    dut.ub_ptr_select.value = 5  # Bias GD
    dut.ub_rd_addr_in.value = 0
    dut.ub_rd_row_size.value = 1
    dut.ub_rd_col_size.value = 2
    await RisingEdge(dut.clk)
    dut.ub_rd_start_in.value = 0

    # Fake gradient descent done signals
    dut.grad_descent_done_out[0].value = 1
    dut.value_updated_out[0].value = to_fixed(123)
    dut.grad_descent_done_out[1].value = 1
    dut.value_updated_out[1].value = to_fixed(456)
    await RisingEdge(dut.clk)

    assert dut.ub_memory[0].value == to_fixed(123)
    assert dut.ub_memory[1].value == to_fixed(456)

@cocotb.test()
async def test_col_size_output(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.ub_rd_start_in.value = 1
    dut.ub_ptr_select.value = 1  # weights
    dut.ub_rd_addr_in.value = 0
    dut.ub_rd_row_size.value = 2
    dut.ub_rd_col_size.value = 2
    dut.ub_rd_transpose.value = 0
    await RisingEdge(dut.clk)

    assert dut.ub_rd_col_size_out.value in [2, 2]  # depends on transpose
    assert dut.ub_rd_col_size_valid_out.value == 1
