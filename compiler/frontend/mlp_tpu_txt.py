'''
v2 with vectorizing VPU; makes the functions more concise
also, making less assumptions with size M
'''

'''
forward pass:
batch size = 4, feature size = 4

sys array impl:
weight_matrix (for N=4): [W00, W01, W02, W03, ... , W30, W31, W32, W33] (16 elem)

'''

import numpy as np
from tpu_memory_allocator import allocator as mem

m = 4

instruction_log = []
# assuming that the modules themselves do the vector/matrix stride
ZERO_addr = mem.alloc("zero", 1)
X_addr = mem.alloc("X", m*m)
W_addr = mem.alloc("W", m*m)
Z_addr = mem.alloc("Z", m*m) # Z = W @ X

X_addr_transposed = mem.alloc("X.T", m*m)
W_addr_transposed = mem.alloc("W.T", m*m)
# in row-major form, each row of Z would span, e.g., [2000, 2000+4*M]
b_addr = mem.alloc("b", m)
Y_addr = mem.alloc("Y", m*m) # Y = Z+b
A_addr = mem.alloc("A", m*m)# A = f(Y)
# backward pass addr

Y_prime_addr = mem.alloc("Y_prime", m*m)
dA_addr = mem.alloc("dA", m*m)  # dA from loss function
dZ_addr = mem.alloc("dZ", m*m)  # dZ = dA * relu_derivative(Z)
dW_addr = mem.alloc("dW", m*m) # dW gradients
db_addr = mem.alloc("db", m)  # db gradients  
dX_addr = mem.alloc("dX", m*m)  # dX gradients

diff_addr = mem.alloc("diff", m*m)  # Y - Y_prime
squared_addr = mem.alloc("sqaured", m*m)  # squared differences
sum_addr = mem.alloc("sum", m*m)  # sum for loss
loss_addr = mem.alloc("loss", 1)  # final loss value
relu_deriv_addr = mem.alloc("relu_deriv", m*m)  # ReLU derivatives

# constants
const_addr_0625 = mem.alloc("const_addr_0625", 1)
const_addr_0125 = mem.alloc("const_addr_0125", 1)
const_addr_025 = mem.alloc("const_addr_025", 1)

def log_instruction(op, *operands):
  instruction = f"{op} {', '.join(map(str, operands))}"
  instruction_log.append(instruction)


def weight_mul(W, X, m=4):
  # emulate mxm systolic array matrix multiplication
  # W, X, Y : mxm fp32 matrices
  # returns Y = W @ X, Y : mxm fp32 matrix
  W = np.array(W, dtype=np.float32)
  X = np.array(X, dtype=np.float32)

  assert W.shape == (m, m), "weights must be mxm"
  assert X.shape == (m, m), "input must be mxm"

  Y = np.matmul(W, X).astype(np.float32)

  return Y

def bias_add(z, b):
  # emulate bias addition VPU operation
  # VPU does element-wise/element-by-element operations
  # z, b : mx1 fp32 vectors
  # returns: z + b mx1 fp32 vector
  z = np.array(z, dtype=np.float32)
  b = np.array(b, dtype=np.float32)
  
  if b.ndim == 2 and b.shape[1] == 1:
      b = b.flatten()
  if z.ndim == 2 and z.shape[0] == 1:
      z = z.flatten() 
  
  out = np.add(z, b)
  return out.astype(np.float32)
  

def relu_op(z):
  # emulate ReLU activation function
  # this function is not really necessary in terms of computational complexity
  # z : mx1 fp32 vector
  # returns m' : mx1 fp32 vector
  z = np.array(z, dtype=np.float32)
  
  return np.maximum(0.0, z).astype(np.float32)

def forward_pass(W, X, b, m=4):
  # emulate full forward MLP pass
  # W, X : mxm fp32 matrices
  # b : mx1 fp32 vector
  # returns Y, A : mxm fp32 matrices
  assert W.shape == (m, m), "weights must be mxm"
  assert X.shape == (m, m), "inputs must be mxm"
  assert b.shape == (m, 1), "bias must be mx1"

  Y = weight_mul(W,X)
  log_instruction("matmul", W_addr, X_addr, Z_addr)
  A = np.zeros_like(Y)
  for i in range(len(Y)):
    Y[i] = bias_add(Y[i], b)
    A[i] = relu_op(Y[i])
  for i in range(m * m):
    log_instruction("add", Z_addr+i, b_addr+i, Y_addr+i)
    log_instruction("relu", Y_addr+i, ZERO_addr,  A_addr+i) #  just for easier parsing, relu dosent need second address

  # the above loop implementation is to account for the functional limits of the VPU
  return Y.astype(np.float32), A.astype(np.float32)

'''
backward pass implementation
'''

def loss(Y, Y_prime, m=4):
  # given output Y from forward pass and target Y_prime, compute MSE l and 
  # gradient of loss wrt A (activated output)
  # Y, Y_prime : mxm fp32 matrix
  # returns l, dY
  # l : scalar fp32
  # dA : mxm fp32 matrix
  assert Y.shape == (m, m), "output must be mxm"
  assert Y_prime.shape == (m, m), "target must be mxm"

  Y = np.array(Y, dtype=np.float32)
  Y_prime = np.array(Y_prime, dtype=np.float32)

  diff = Y - Y_prime # VPU sub op
  squared = np.square(diff) # VPU mul op
  for i in range(m * m):
    log_instruction("sub", A_addr + i, Y_prime_addr + i, diff_addr + i)
    log_instruction("mul", diff_addr+i, diff_addr+i, squared_addr+i) 

  l = np.sum(squared) # element-by-element running sum w VPU add op
  for i in range(m*m):
    log_instruction("add", sum_addr, squared_addr+i, sum_addr)
  l = np.float32(0.0625) * l # VPU mul op
  log_instruction("mul", sum_addr, const_addr_0625, loss_addr)

  dA = np.float32(0.125) * diff # element-by-element w VPU mul op
  for i in range(m*m):
    log_instruction("mul", diff_addr + i, const_addr_0125, dA_addr + i)

  # all above operations could be done more concisely with numpy functions
  # but written in expanded form for functional limits of VPU
  return np.float32(l), dA.astype(np.float32)
  

def relu_derivative(z, m=4):
  # z : fp32 mx1 vector
  z = np.array(z, dtype=np.float32)
  return (z>0).astype(np.float32)

def backward_pass(W, X, b, Z, dA, m=4):
  # given weight, input, bias, output, gradient, perform MLP backward pass
  # W, X, Z, dA : 4x4 fp32 matrices
  # b : 4x1 fp32 vector
  W = np.array(W, dtype=np.float32)
  X = np.array(X, dtype=np.float32)
  b = np.array(b, dtype=np.float32)
  dA = np.array(dA, dtype=np.float32)

  dZ = np.zeros_like(dA)
  for i in range(len(dA)):
    dZ[i] = dA[i] * relu_derivative(Z[i])
    log_instruction("relu_derivative", Z_addr + i, ZERO_addr , relu_deriv_addr + i)
    log_instruction("mul", dA_addr + i, relu_deriv_addr + i, dZ_addr + i)

  #traspose the matrix
  dW = np.zeros_like(W)
  dW = (0.25 * dZ @ X.T).astype(np.float32) 
  for i in range(m):
    for j in range(m):
        src = X_addr    + j*m + i   # X[j,i]
        dst = X_addr_transposed  + i*m + j   # X_T[i,j]
        log_instruction("add", src, ZERO_addr, dst)

  log_instruction("matmul", dZ_addr, X_addr_transposed, dW_addr)
  for i in range(m*m):    # 16 iterations for a 4×4
    log_instruction("mul", dW_addr + i, const_addr_025, dW_addr + i)

  db = np.zeros_like(b)
  db = (0.25 * np.sum(dZ, axis=1, keepdims=True)).astype(np.float32)
  # for i in range(m):
  #   # log_instruction("add", dZ_addr + i*m*4, db_addr + i*4)
  #   # db[i] = db[i] + dZ[k,i]
  #   log_instruction("add", dZ_addr + i*m*4, db_addr + i*4, db_addr + i*4)
  #   log_instruction("mul", db_addr + i*4, const_addr_025, db_addr + i*4)

  for i in range(m):
    for k in range(m):
        dz_elem_addr = dZ_addr + i*m + k
        db_elem_addr = db_addr + i
        log_instruction("add", dz_elem_addr, db_elem_addr, db_elem_addr)

  for i in range(m):
    log_instruction("mul", db_addr + i, const_addr_025, db_addr + i)
  
  dX = np.zeros_like(X)
  dX = (W.T @ dZ).astype(np.float32)
  # for i in range(m):  # rows of dX
  #   for j in range(m):  # columns of dX  
  #     # temp_sum_addr = 0xF200 + i*m + j
  #     dX_element_addr = dX_addr + i*m + j

  #     for k in range(m):
  #         # W[k,i] is at address: W_addr + k*m*4 + i*4
  #         w_element_addr = W_addr + k*m + i
  #         # dZ[k,j] is at address: dZ_addr + k*m*4 + j*4  
  #         dz_element_addr = dZ_addr + k*m + j
  #         product_addr = 0xF300 + k
          
  #         log_instruction("mul", w_element_addr, dz_element_addr, product_addr)
  #         log_instruction("add", dX_element_addr, product_addr, dX_element_addr)
      
  #     # store result in dX[i,j]
  #     # dX_element_addr = dX_addr + i*m*4 + j*4
  #     # log_instruction("mov", temp_sum_addr, dX_element_addr)

  #traspose the matrix
  for i in range(m):
    for j in range(m):
        src = W_addr    + j*m + i   # X[j,i]
        dst = W_addr_transposed  + i*m + j   # X_T[i,j]
        log_instruction("add", src, ZERO_addr, dst)
  log_instruction("matmul", dZ_addr, W_addr_transposed, dX_addr)
  
  return dW.astype(np.float32), db.astype(np.float32), dX.astype(np.float32)

def save_instructions(filename="mlp_instructions.txt"):
  with open(filename, 'w') as f:
      for instruction in instruction_log:
          f.write(instruction + '\n')
  print(f"Saved {len(instruction_log)} instructions to {filename}")

def reset_instruction_log():
  global instruction_log
  instruction_log = []

def run_complete_mlp_example():
  global instruction_log
  instruction_log = []
  
  m = 4
  
  W = np.random.randn(m, m).astype(np.float32)  
  X = np.random.randn(m, m).astype(np.float32)  
  b = np.random.randn(m, 1).astype(np.float32) 
  Y_prime = np.random.randn(m, m).astype(np.float32)  

  print(f"\n=== Generating MLP instructions ===")
  
  print("\n--- Initial data ---")
  print(f"W shape: {W.shape}")
  print(f"X shape: {X.shape}") 
  print(f"b shape: {b.shape}")
  print(f"Y_prime shape: {Y_prime.shape}")
  
  # forward pass
  print("\n--- Running Forward Pass ---")
  Z, A = forward_pass(W, X, b, m)
  print(f"Forward pass completed. Z shape: {Z.shape}, A shape: {A.shape}")
  
  # loss computation
  print("\n--- Computing Loss ---")
  loss_value, dA = loss(A, Y_prime, m)
  print(f"Loss: {loss_value:.6f}")
  print(f"dA shape: {dA.shape}")
  # backward pass
  print("\n--- Running Backward Pass ---")
  dW, db, dX = backward_pass(W, X, b, Z, dA, m)
  print(f"Backward pass completed.")
  print(f"dW shape: {dW.shape}")
  print(f"db shape: {db.shape}") 
  print(f"dX shape: {dX.shape}")
  
  # log instructions in txt file
  print("\n--- Saving Instructions ---")
  save_instructions("mlp_instruction_trace.txt")
  
  print(f"\n=== Complete! Generated {len(instruction_log)} instructions ===")
  
  return loss_value, dW, db, dX

if __name__ == "__main__":
  loss_val, dW, db, dX = run_complete_mlp_example()
  print(f"Loss: {loss_val:.6f}")
  print(f"dW: {dW}")
  print(f"db: {db}")
  print(f"dX: {dX}")
  mem.dump()