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
from frontend.tpu_memory_allocator import allocator as mem
from backend.tpu_txt import load, store, matmul, add, sub, mul, relu, relu_derivative, get_instruction_log

m = 4


def weight_mul(W, X, m=4):
  # emulate mxm systolic array matrix multiplication
    # returns Y = X @ W^T

    W = np.array(W, dtype=np.float32)
    X = np.array(X, dtype=np.float32)

    assert W.shape == (m, m), "weights must be mxm"
    assert X.shape == (m, m), "input must be mxm"

    Y = np.matmul(X, W.T).astype(np.float32)

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

def forward_pass(W, X, b, X_addr, W_addr, Z_addr, b_addr, Y_addr, ZERO_addr, A_addr, m=4):
  # emulate full forward MLP pass
  # W, X : mxm fp32 matrices
  # b : mx1 fp32 vector
  # returns Y, A : mxm fp32 matrices
  assert W.shape == (m, m), "weights must be mxm"
  assert X.shape == (m, m), "inputs must be mxm"
  assert b.shape == (m, 1), "bias must be mx1"

  Y = weight_mul(W,X)
  matmul(W_addr, X_addr, Z_addr)
  A = np.zeros_like(Y)
  for i in range(len(Y)):
    Y[i] = bias_add(Y[i], b)
    A[i] = relu_op(Y[i])
  for i in range(m):
    for j in range(m):
      add(Z_addr + (i*m + j), b_addr+j, Y_addr + (i*m + j))
      relu(Y_addr + (i*m + j), ZERO_addr,  A_addr + (i*m + j)) #  just for easier parsing, relu dosent need second address

  # the above loop implementation is to account for the functional limits of the VPU
  return Y.astype(np.float32), A.astype(np.float32)


def loss(Y, Y_prime, Y_addr, Y_prime_addr, diff_addr, squared_addr, sum_addr, const_addr_0625, loss_addr, const_addr_0125, dA_addr, m=4):
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
  print(f"diff: {diff}")
  print(f"squared: {squared}")
  for i in range(m * m):
    sub(Y_addr + i, Y_prime_addr + i, diff_addr + i)
    mul(diff_addr+i, diff_addr+i, squared_addr+i)

  l = np.sum(squared) # element-by-element running sum w VPU add op
  for i in range(m*m):
    add(sum_addr, squared_addr+i, sum_addr)
  l = np.float32(0.0625) * l # VPU mul op
  mul(sum_addr, const_addr_0625, loss_addr)

  dA = np.float32(0.125) * diff # element-by-element w VPU mul op
  for i in range(m*m):
    mul(diff_addr + i, const_addr_0125, dA_addr + i)

  # all above operations could be done more concisely with numpy functions
  # but written in expanded form for functional limits of VPU
  return np.float32(l), dA.astype(np.float32)
  

def relu_derivative_software(z, m=4):
  # z : fp32 mx1 vector
  z = np.array(z, dtype=np.float32)
  return (z>0).astype(np.float32)

def backward_pass(W, X, b, Y, dA, Y_addr, ZERO_addr, relu_deriv_addr, dA_addr, dZ_addr, X_addr, dW_addr,const_addr_025, db_addr, W_addr, W_addr_transposed, dX_addr, m=4):
  # given weight, input, bias, output, gradient, perform MLP backward pass
  # W, X, Z, dA : 4x4 fp32 matrices
  # b : 4x1 fp32 vector
  W = np.array(W, dtype=np.float32)
  X = np.array(X, dtype=np.float32)
  b = np.array(b, dtype=np.float32)
  dA = np.array(dA, dtype=np.float32)

  dZ = np.zeros_like(dA)
  for i in range(len(dA)):
    dZ[i] = dA[i] * relu_derivative_software(Y[i])
    relu_derivative(Y_addr + i, ZERO_addr , relu_deriv_addr + i)
    mul( dA_addr + i, relu_deriv_addr + i, dZ_addr + i)

  #traspose the matrix
  dW = np.zeros_like(W)
  dW = (0.25 * dZ @ X.T).astype(np.float32) 

  matmul(X_addr, dZ_addr, dW_addr)
  for i in range(m*m):    # 16 iterations for a 4×4
    mul(dW_addr + i, const_addr_025, dW_addr + i)

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
        add(dz_elem_addr, db_elem_addr, db_elem_addr)

  for i in range(m):
    mul(db_addr + i, const_addr_025, db_addr + i)
  
  dX = np.zeros_like(X)
  dX = (dZ @ W).astype(np.float32)
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

  #traspose the weight matrix
  for i in range(m):
    for j in range(m):
        src = W_addr    + j*m + i   # X[j,i]
        dst = W_addr_transposed  + i*m + j   # X_T[i,j]
        add(src, ZERO_addr, dst)
  matmul(W_addr_transposed, dZ_addr, dX_addr)
  
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
  
    m = 4

    # assuming that the modules themselves do the vector/matrix stride
    ZERO_addr = mem.alloc("zero", 1)
    load(ZERO_addr, [0])
    X_addr = mem.alloc("X", m*m)
    W_addr = mem.alloc("W", m*m)
    Z_addr = mem.alloc("Z", m*m) # Z = W @ X

    # X_addr_transposed = mem.alloc("X.T", m*m)
    W_addr_transposed = mem.alloc("W.T", m*m)

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
    load(sum_addr, [0.0])
    loss_addr = mem.alloc("loss", 1)  # final loss value
    relu_deriv_addr = mem.alloc("relu_deriv", m*m)  # ReLU derivatives

    # constants
    const_addr_0625 = mem.alloc("const_addr_0625", 1)
    const_addr_125 = mem.alloc("const_addr_0125", 1)
    const_addr_025 = mem.alloc("const_addr_025", 1)
    load(const_addr_0625, [0.0625])
    load(const_addr_125, [0.125])
    load(const_addr_025, [0.25])

  
    W = np.random.randn(m, m).astype(np.float32)  
    X = np.random.randn(m, m).astype(np.float32)  
    b = np.random.randn(m, 1).astype(np.float32) 
    load(W_addr, W)
    load(X_addr, X)
    load(b_addr, b)
    Y_prime = np.random.randn(m, m).astype(np.float32)
    load(Y_prime_addr, Y_prime)  

    print(f"\n=== Generating MLP instructions ===")
    
    print("\n--- Initial data ---")
    print(f"W shape: {W.shape}")
    print(f"X shape: {X.shape}") 
    print(f"b shape: {b.shape}")
    print(f"W: {W}")
    print(f"X: {X}")
    print(f"b: {b}")
    print(f"Y_prime shape: {Y_prime.shape}")
    
    # forward pass
    print("\n--- Running Forward Pass ---")
    Y, A = forward_pass(W, X, b, X_addr, W_addr, Z_addr, b_addr, Y_addr, ZERO_addr, A_addr, m)
    print(f"Forward pass completed. Y shape: {Y.shape}, A shape: {A.shape}")
    print(f"Y: {Y}")
    print(f"A: {A}")
    
    # loss computation
    print("\n--- Computing Loss ---")
    loss_value, dA = loss(Y, Y_prime, Y_addr, Y_prime_addr, diff_addr, squared_addr, sum_addr, const_addr_0625, loss_addr, const_addr_125, dA_addr, m=4)
    print(f"Loss: {loss_value:.6f}")
    print(f"dA: {dA}")
    print(f"dA shape: {dA.shape}")
    # backward pass
    print("\n--- Running Backward Pass ---")
    dW, db, dX = backward_pass(W, X, b, Y, dA, Y_addr, ZERO_addr, relu_deriv_addr, dA_addr, dZ_addr, X_addr, dW_addr,const_addr_025, db_addr, W_addr, W_addr_transposed, dX_addr, m=4)
    print(f"Backward pass completed.")
    print(f"dW shape: {dW.shape}")
    print(f"db shape: {db.shape}") 
    print(f"dX shape: {dX.shape}")

    store(X_addr, m*m, "X")
    store(W_addr, m*m, "W")
    store(Z_addr, m*m, "Z")
    store(b_addr,m , "b" )
    store(W_addr_transposed, m*m, "W.T")
    store(Y_addr, m*m, "Y")
    store(A_addr, m*m, "A")
    store(diff_addr, m*m, "diff")
    store(squared_addr, m*m, "sqaured")
    store(dA_addr, m*m, "dA")
    store(dZ_addr, m*m, "dZ")
    store(relu_deriv_addr, m*m, "relu_deriv")
    store(dW_addr, m*m , "dW")
    store(db_addr, m , "db")
    store(dX_addr, m*m , "dX")
    store(loss_addr, 1, "loss")
    
    
    return loss_value, dW, db, dX

if __name__ == "__main__":
    
    ### WRITE CODE BELOW

    # complete tpu mlp
    loss_val, dW, db, dX = run_complete_mlp_example()
    print(f"Loss: {loss_val:.6f}")
    print(f"dW: {dW}")
    print(f"db: {db}")
    print(f"dX: {dX}")

    # testing vpu vadd
    # test_addr = mem.alloc("test", 1)
    # test2_addr = mem.alloc("test2", 1)
    # output_addr = mem.alloc("output", 1)
    # load(test_addr, [20.0])
    # load(test2_addr, [10.0])
    # add(test_addr, test2_addr, output_addr)
    # store(output_addr, 1, "output")

    # testing systolic array
    # X_addr = mem.alloc("X", 16)
    # W_addr = mem.alloc("W", 16)
    # Z_addr = mem.alloc("Z", 16) # Z = W @ X

    # load(W_addr, [[1, 0, 2, 1,
    #                 3, 1, 0, 4,
    #                 5, 2, 3, 0,
    #                 4, 1, 3, 2]])
    
    # load(X_addr, [1, 2, 3, 4,
    #               1, 6, 7, 8,
    #               9, 1, 2, 3,
    #               4, 5, 6, 3])
    
    
    # matmul(W_addr, X_addr, Z_addr)
    # store(Z_addr, 16, 'output')

    # testing relu deriv
    # a = mem.alloc("a", 1)
    # b = mem.alloc("b", 1)
    # c = mem.alloc("c", 1)
    # ZERO = mem.alloc("ZERO", 1)

    # a_relu_deriv = mem.alloc("a", 1)
    # b_relu_deriv = mem.alloc("b", 1)
    # c_relu_deriv = mem.alloc("c", 1)

    # load(a, [-3.0])
    # load(b, [0.0])
    # load(c, [3.0])
    # load(ZERO, [0.0])

    # relu_derivative(a, ZERO, a_relu_deriv)
    # relu_derivative(b, ZERO, b_relu_deriv)
    # relu_derivative(c, ZERO, c_relu_deriv)

    # store(a_relu_deriv, 1, "a_relu_deriv")
    # store(b_relu_deriv, 1, "b_relu_deriv")
    # store(c_relu_deriv, 1, "c_relu_deriv")


    ### WRITE CODE ABOVE
    
    #get instructions
    global instruction_log
    instruction_log = get_instruction_log()
    # log instructions in txt file
    print("\n--- Saving Instructions ---")
    save_instructions("mlp_instruction_trace.txt")
    
    print(f"\n=== Complete! Generated {len(instruction_log)} instructions ===")

    mem.dump()