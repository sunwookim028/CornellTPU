import numpy as np


instruction_log = []

def log_instruction(op, *operands):
  instruction = f"{op} {', '.join(map(str, operands))}"
  instruction_log.append(instruction)

def matmul(W, X, Z, m=4):
    """
    Given two mxm input matrices stored contiguously in memory starting
    at address W and address X, performs X ⋅ W^T and stores data contigously
    in memory starting at address Z.

    *Z = *X ⋅ (*W)^T

    """
    log_instruction("matmul", W, X, Z)

def load(start_addr, np_array):
    """
    Loads data in np_array contiguously in memory starting at "start_addr"
    """
    # Convert to numpy array
    if not isinstance(np_array, np.ndarray):
        np_array = np.array(np_array, dtype=np.float32)

    # Flatten 2D or 3D arrays → always 1D
    flat = np_array.astype(np.float32).reshape(-1)

    length = flat.size

    value_literal = flat.tolist()

    log_instruction("load", start_addr, length, value_literal)

def store(start_addr, length, name):
    """
    Request "length" number of words to be read contigously from memory starting at
    "start_addr" and prints data under label "name"
    """
    log_instruction("store", start_addr, length, name)
    
def add(X, Y, Z):
    """
    Adds data stored at address X and address Y and stores result in address Z
    *Z = *X + *Y
    """
    log_instruction("add", X, Y, Z)

def sub(X, Y, Z):
    """
    Subtracts data stored at address Y from data stored at address X and stores result in address Z
    *Z = *X - *Y
    """
    log_instruction("sub", X, Y, Z)

def mul(X, Y, Z):
    """
    Multiplies data stored at address X and address Y and stores result in address Z
    *Z = (*X) * (*Y)
    """
    log_instruction("mul", X, Y, Z)

def relu(X, Zero_addr, Y):
    """
    Applies relu function on data stored at address X and stores result in address Y
    *Y = relu(*X)
    """
    log_instruction("relu", X, Zero_addr, Y)

def relu_derivative(X, Zero_addr, Y):
    """
    Applies relu derivative function on data stored at address X and stores result in address Y
    *Y = relu'(*X)
    """
    log_instruction("relu_derivative", X, Zero_addr, Y)

def get_instruction_log():
   return instruction_log

