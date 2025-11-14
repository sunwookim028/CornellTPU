#=========================================================================
# test/test_vpu.py — cocotb tests for opcode VPU (ADD/SUB/ReLU)
#   - Drives a tiny memory model via mem_* handshakes
#   - Issues 3 instructions (ADD, SUB, RELU)
#   - Compares results in FP32 bit-level
#=========================================================================

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

import struct

# ------------------------ Helpers: float <-> u32 -------------------------

def f2u32(x: float) -> int:
    """Float32 -> uint32 bit pattern."""
    return struct.unpack(">I", struct.pack(">f", x))[0]

def u322f(u: int) -> float:
    """uint32 -> float32"""
    return struct.unpack(">f", struct.pack(">I", u & 0xFFFFFFFF))[0]

# ------------------------ Instruction encoding ---------------------------
# Layout used in the control (lower bits packed):
# [OP_W-1:0] opcode
# [OP_W+INST_ADDR-1:OP_W]                a_addr
# [OP_W+2*INST_ADDR-1:OP_W+INST_ADDR]    b_addr
# [OP_W+3*INST_ADDR-1:OP_W+2*INST_ADDR]  c_addr
# [OP_W+4*INST_ADDR-1:OP_W+3*INST_ADDR]  const_addr
#
# Defaults assumed: OP_W=4, INST_ADDR=5 (fits in lower 24 bits)

OP_ADD  = 0
OP_SUB  = 1
OP_RELU = 2

def enc_inst(opcode, a, b, c, k, op_w=4, inst_addr_bits=5):
    inst = 0
    # LSB first: opcode
    inst |= (opcode & ((1 << op_w) - 1))                   # [op_w-1:0]
    inst |= (a & ((1 << inst_addr_bits) - 1)) << op_w
    inst |= (b & ((1 << inst_addr_bits) - 1)) << (op_w + inst_addr_bits)
    inst |= (c & ((1 << inst_addr_bits) - 1)) << (op_w + 2*inst_addr_bits)
    inst |= (k & ((1 << inst_addr_bits) - 1)) << (op_w + 3*inst_addr_bits)
    return inst

# ------------------------ Tiny memory model ------------------------------

class TinyMem:
    """Minimal combinational-ish memory responder for this FSM.
       - When addr_a != 0 and mem_read_en is probed, return data_a for that addr
       - Same for addr_b / data_b
       - On write phase, when addr_c != 0 and mem_write_en, consume data_c
    """
    def __init__(self):
        self.ram = {}   # addr -> 32b word
        self.last_write = None

    def preload(self, addr: int, value_u32: int):
        self.ram[addr] = value_u32 & 0xFFFFFFFF

    def read(self, addr: int) -> int:
        return self.ram.get(addr, 0)

    def write(self, addr: int, data_u32: int):
        self.ram[addr] = data_u32 & 0xFFFFFFFF
        self.last_write = (addr, data_u32 & 0xFFFFFFFF)

# ------------------------ Driver coroutines ------------------------------

async def reset(dut):
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

async def mem_driver(dut, mem):
    from cocotb.triggers import RisingEdge

    def stable(v):
        s = v.binstr.lower()
        return ("x" not in s) and ("z" not in s)

    dut.mem_rdy.value = 0
    dut.mem_read_en.value = 0
    dut.mem_write_en.value = 0
    dut.data_a.value = 0
    dut.data_b.value = 0

    while True:
        await RisingEdge(dut.clk)

        dut.mem_rdy.value = 0
        dut.mem_read_en.value = 0
        dut.mem_write_en.value = 0

        A = int(dut.addr_a.value)
        if A != 0:
            dut.data_a.value = mem.read(A)
            dut.mem_read_en.value = 1
            dut.mem_rdy.value = 1
            continue

        B = int(dut.addr_b.value)
        if B != 0:
            dut.data_b.value = mem.read(B)
            dut.mem_read_en.value = 1
            dut.mem_rdy.value = 1
            continue

        C = int(dut.addr_c.value)
        if C != 0:
            dut.mem_write_en.value = 1
            if stable(dut.data_c.value):
                mem.write(C, int(dut.data_c.value))

# ------------------------ Tests ------------------------------------------

@cocotb.test()
async def probe_once(dut):
    from cocotb.triggers import RisingEdge, ClockCycles
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    dut.rst.value = 1; await RisingEdge(dut.clk)
    dut.rst.value = 0; await RisingEdge(dut.clk)

    # Don’t drive anything else; just watch addresses and done
    for _ in range(100):
        await RisingEdge(dut.clk)
        A = int(dut.addr_a.value)
        B = int(dut.addr_b.value)
        C = int(dut.addr_c.value)
        D = int(dut.done.value)
        if A or B or C or D:
            dut._log.info(f"A={A} B={B} C={C} done={D}")

@cocotb.test()
async def test_add_sub_relu(dut):
    """Issue three instructions (ADD, SUB, RELU) and check results."""

    # Clock 100MHz
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Bring-up
    await reset(dut)

    # If your top uses different default param widths, set them here for encoding
    OP_W = 4
    INST_BITS = 5

    # Build a tiny memory map
    mem = TinyMem()

    # Addresses we will use (<= 2^INST_BITS-1)
    A = 1
    B = 2
    C = 3
    K = 4   # const (not used yet, reserved)

    # Preload operands in FP32
    a_f = 1.5
    b_f = 2.25
    n_f = -3.0

    mem.preload(A, f2u32(a_f))
    mem.preload(B, f2u32(b_f))
    mem.preload(K, f2u32(0.0))  # unused here

    # Start memory responder
    cocotb.start_soon(mem_driver(dut, mem))

    # ------------------ 1) ADD:  C = A + B  ------------------
    inst_add = enc_inst(OP_ADD, A, B, C, K, OP_W, INST_BITS)
    dut.inst.value = inst_add

    # Wait for completion
    done = 0
    for _ in range(200):
      await RisingEdge(dut.clk)
      if int(dut.done.value):
        done = 1
        break
    assert done, "ADD: done was never asserted"

    # Check memory write at C
    waddr, wdata = mem.last_write
    assert waddr == C, f"ADD: write address mismatch, got {waddr}, exp {C}"
    got_f = u322f(wdata)
    exp_f = a_f + b_f
    assert abs(got_f - exp_f) < 1e-6, f"ADD: {got_f} != {exp_f}"

    # ------------------ 2) SUB:  C = A - B  ------------------
    inst_sub = enc_inst(OP_SUB, A, B, C, K, OP_W, INST_BITS)
    dut.inst.value = inst_sub

    done = 0
    for _ in range(200):
      await RisingEdge(dut.clk)
      if int(dut.done.value):
        done = 1
        break
    assert done, "SUB: done was never asserted"

    waddr, wdata = mem.last_write
    assert waddr == C, f"SUB: write address mismatch, got {waddr}, exp {C}"
    got_f = u322f(wdata)
    exp_f = a_f - b_f
    assert abs(got_f - exp_f) < 1e-6, f"SUB: {got_f} != {exp_f}"

    # ------------------ 3) RELU: C = relu(A)  ----------------
    # For RELU, reload A with a negative number to test clamping to 0
    mem.preload(A, f2u32(n_f))

    inst_relu = enc_inst(OP_RELU, A, B, C, K, OP_W, INST_BITS)
    dut.inst.value = inst_relu

    done = 0
    for _ in range(200):
      await RisingEdge(dut.clk)
      if int(dut.done.value):
        done = 1
        break
    assert done, "RELU: done was never asserted"

    waddr, wdata = mem.last_write
    assert waddr == C, f"RELU: write address mismatch, got {waddr}, exp {C}"
    got_f = u322f(wdata)
    exp_f = max(0.0, n_f)
    assert abs(got_f - exp_f) < 1e-6, f"RELU: {got_f} != {exp_f}"
