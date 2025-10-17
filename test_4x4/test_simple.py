from pymtl3 import *
from pymtl3.passes.backends.verilog import *
from pymtl3.passes.PassGroups import DefaultPassGroup

# First, let's check if basic PyMTL3 works
def test_simple():
    class Simple(Component):
        def construct(s):
            s.in_ = InPort(1)
            s.out = OutPort(1)
            s.out //= s.in_
    
    dut = Simple()
    dut.apply(DefaultPassGroup())
    dut.sim_reset()
    
    dut.in_ @= 1
    dut.sim_tick()
    assert dut.out == 1
    print("Basic PyMTL3 test passed!")

# Run the simple test first
test_simple()