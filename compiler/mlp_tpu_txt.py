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

instruction_log = []
# assuming that the modules themselves do the vector/matrix stride
X_addr = 0x0000
W_addr = 0x1000
Z_addr = 0x2000 # Z = W @ X
# in row-major form, each row of Z would span, e.g., [2000, 2000+4*M]
b_addr = 0x3000
Y_addr = 0x4000 # Y = Z+b
A_addr = 0x5000 # A = f(Y)
# backward pass addr
Y_prime_addr = 0x4F00
dA_addr = 0x6000  # dA from loss function
dZ_addr = 0x7000  # dZ = dA * relu_derivative(Z)
dW_addr = 0x8000  # dW gradients
db_addr = 0x9000  # db gradients  
dX_addr = 0xA000  # dX gradients

diff_addr = 0xB000  # Y - Y_prime
squared_addr = 0xC000  # squared differences
sum_addr = 0xD000  # sum for loss
loss_addr = 0xE000  # final loss value
relu_deriv_addr = 0xF000  # ReLU derivatives
const_addr_0625 = 0xF100
const_addr_0125 = 0xF200
const_addr_025 = 0xF300

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
  log_instruction("matmul", hex(W_addr), hex(X_addr), hex(Z_addr))
  A = np.zeros_like(Y)
  for i in range(len(Y)):
    Y[i] = bias_add(Y[i], b)
    A[i] = relu_op(Y[i])
  for i in range(m):
    log_instruction("add", hex(Z_addr+i*m), hex(b_addr+i*m), hex(Y_addr+i*m))
    log_instruction("relu", hex(Y_addr+i*m), hex(A_addr+i*m))

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
  log_instruction("sub", hex(A_addr), hex(Y_prime_addr), hex(diff_addr))
  squared = np.square(diff) # VPU mul op
  for i in range(m):
    log_instruction("mul", hex(diff_addr+i*m), hex(diff_addr+i*m), hex(squared_addr+i*m)) 

  l = np.sum(squared) # element-by-element running sum w VPU add op
  for i in range(m*m):
    log_instruction("add", hex(squared_addr+i*m), hex(squared_addr+i*m), hex(sum_addr+i*m)) 
  l = np.float32(0.0625) * l # VPU mul op
  log_instruction("mul", hex(sum_addr+4*m*m), hex(const_addr_0625), hex(loss_addr))

  dA = np.float32(0.125) * diff # element-by-element w VPU mul op
  for i in range(m*m):
    log_instruction("mul", hex(diff_addr+i*m), hex(const_addr_0125), hex(dA_addr+i*m))

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
    log_instruction("relu_derivative", hex(Z_addr + i*m*4), hex(relu_deriv_addr + i*4))
    log_instruction("mul", hex(dA_addr + i*m*4), hex(relu_deriv_addr + i*4), hex(dZ_addr + i*m*4))

  dW = np.zeros_like(W)
  dW = (0.25 * dZ @ X.T).astype(np.float32) 
  log_instruction("matmul", hex(dZ_addr), hex(X_addr), hex(dW_addr))
  log_instruction("mul", hex(dW_addr), hex(const_addr_025), hex(dW_addr))

  db = np.zeros_like(b)
  db = (0.25 * np.sum(dZ, axis=1, keepdims=True)).astype(np.float32)
  for i in range(m):
    log_instruction("add", hex(dZ_addr + i*m*4), hex(db_addr + i*4))
    log_instruction("mul", hex(db_addr + i*4), hex(const_addr_025), hex(db_addr + i*4))
  
  dX = np.zeros_like(X)
  dX = (W.T @ dZ).astype(np.float32)
  for i in range(m):  # rows of dX
        for j in range(m):  # columns of dX  
            temp_sum_addr = 0xF200 + i*m + j
            
            # Sum over k: W[k,i] * dZ[k,j]
            for k in range(m):
                # W[k,i] is at address: W_addr + k*m*4 + i*4
                w_element_addr = W_addr + k*m*4 + i*4
                # dZ[k,j] is at address: dZ_addr + k*m*4 + j*4  
                dz_element_addr = dZ_addr + k*m*4 + j*4
                product_addr = 0xF300 + k
                
                log_instruction("mul", hex(w_element_addr), hex(dz_element_addr), hex(product_addr))
                log_instruction("add", hex(temp_sum_addr), hex(product_addr), hex(temp_sum_addr))
            
            # store result in dX[i,j]
            dX_element_addr = dX_addr + i*m*4 + j*4
            log_instruction("mov", hex(temp_sum_addr), hex(dX_element_addr))
  
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
    """Run a complete forward and backward pass with instruction logging"""
    
    # Reset the instruction log
    global instruction_log
    instruction_log = []
    
    print("=== Starting Complete MLP Example ===")
    m = 4
    
    # Initialize random data (replace with your actual data)
    W = np.random.randn(m, m).astype(np.float32)  # weights
    X = np.random.randn(m, m).astype(np.float32)  # input batch  
    b = np.random.randn(m, 1).astype(np.float32)  # bias
    Y_prime = np.random.randn(m, m).astype(np.float32)  # target output
    
    print("Data initialized:")
    print(f"W shape: {W.shape}")
    print(f"X shape: {X.shape}") 
    print(f"b shape: {b.shape}")
    print(f"Y_prime shape: {Y_prime.shape}")
    
    # 1. FORWARD PASS
    print("\n--- Running Forward Pass ---")
    Z, A = forward_pass(W, X, b, m)
    print(f"Forward pass completed. Z shape: {Z.shape}, A shape: {A.shape}")
    
    # 2. LOSS COMPUTATION
    print("\n--- Computing Loss ---")
    loss_value, dA = loss(A, Y_prime, m)
    print(f"Loss: {loss_value:.6f}")
    print(f"dA shape: {dA.shape}")
    
    # 3. BACKWARD PASS
    print("\n--- Running Backward Pass ---")
    dW, db, dX = backward_pass(W, X, b, Z, dA, m)
    print(f"Backward pass completed.")
    print(f"dW shape: {dW.shape}")
    print(f"db shape: {db.shape}") 
    print(f"dX shape: {dX.shape}")
    
    # 4. SAVE INSTRUCTIONS
    print("\n--- Saving Instructions ---")
    save_instructions("mlp_instruction_trace.txt")
    
    print(f"\n=== Complete! Generated {len(instruction_log)} instructions ===")
    
    return loss_value, dW, db, dX

if __name__ == "__main__":
    loss_val, dW, db, dX = run_complete_mlp_example()