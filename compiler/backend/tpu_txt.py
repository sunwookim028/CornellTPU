import numpy as np


instruction_log = []

def log_instruction(op, *operands):
  instruction = f"{op} {', '.join(map(str, operands))}"
  instruction_log.append(instruction)

def matmul(X, W, Z, m=4):
    log_instruction("matmul", X, W, Z)

def load(start_addr, np_array):
    """
    Frontend load operation: request data to be written to BRAM.
    """
    # Convert to numpy array
    if not isinstance(np_array, np.ndarray):
        np_array = np.array(np_array, dtype=np.float32)

    # Flatten 2D or 3D arrays → always 1D
    flat = np_array.astype(np.float32).reshape(-1)

    # The TPU BRAM stores 1 element per address
    length = flat.size

    # Convert to one-line Python literal list
    value_literal = flat.tolist()

    # Write single-line instruction
    log_instruction("load", start_addr, length, value_literal)

def store(start_addr, length, name):
    """
    Frontend store operation: request data to be read from BRAM
    and stored in given variable name.
    """
    log_instruction("store", start_addr, length, name)
    
def add(X, Y, Z):
    log_instruction("add", X, Y, Z)

def sub(X, Y, Z):
   log_instruction("sub", X, Y, Z)

def mul(X, Y, Z):
   log_instruction("mul", X, Y, Z)

def relu(X, Zero_addr, Y):
   log_instruction("relu", X, Zero_addr, Y)

def relu_derivative(X, Zero_addr, Y):
   log_instruction("relu_derivative", X, Zero_addr, Y)

def get_instruction_log():
   return instruction_log

