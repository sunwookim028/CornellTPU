'''
forward pass:
batch size = 4, feature size = 4

sys array impl:
weight_matrix (for N=4): [W00, W01, W02, W03, ... , W30, W31, W32, W33] (16 elem)

'''

import numpy as np

def weight_mul(W, X):
  # emulate 4x4 systolic array matrix multiplication
  # W, X, Y : 4x4 fp32 matrices
  # returns Y = W @ X, Y : 4x4 fp32 matrix
  W = np.array(W, dtype=np.float32)
  X = np.array(X, dtype=np.float32)

  assert W.shape == (4, 4), "weights must be 4x4"
  assert X.shape == (4, 4), "input must be 4x4"

  Y = np.matmul(W, X).astype(np.float32)

  return Y

def bias_add(z, b):
  # emulate bias addition VPU operation
  # VPU does element-wise/element-by-element operations
  # z, b : fp32 scalars
  # returns: z + b fp32 scalar
  z = np.float32(z) if not isinstance(z, np.float32) else z
  b = np.float32(b) if not isinstance(b, np.float32) else b
  
  return np.float32(z+b)

def relu_op(z):
  # emulate ReLU activation function
  # this function is not really necessary in terms of computational complexity
  # z : fp32 scalar
  # returns z' : fp32 scalar
  z = np.float32(z) if not isinstance(z, np.float32) else z
  
  return np.float32(z if z >= 0.0 else 0.0)

def forward_pass(W, X, b):
  # emulate full forward MLP pass
  # W, X : 4x4 fp32 matrices
  # b : 4x1 fp32 vector
  # returns Y, A : 4x4 fp32 matrices
  Y = weight_mul(W,X)
  A = np.zeros_like(Y)
  for i in range(len(Y)):
    for j in range(len(Y[0])):
      Y[i][j] = bias_add(Y[i][j], b[j])
      A[i][j] = relu_op(Y[i][j]) # output with (A)ctivation
  # the above loop implementation is to account for the functional limits of the VPU
  return Y.astype(np.float32), A.astype(np.float32)

'''
backward pass implementation
'''

def loss(Y, Y_prime):
  # given output Y from forward pass and target Y_prime, compute MSE l and 
  # gradient of loss wrt A (activated output)
  # Y, Y_prime : 4x4 fp32 matrix
  # returns l, dY
  # l : scalar fp32
  # dA : 4x4 fp32 matrix
  Y = np.array(Y, dtype=np.float32)
  Y_prime = np.array(Y_prime, dtype=np.float32)

  diff = Y - Y_prime # element-by-element with VPU sub op
  squared = np.square(diff) # element-by-element w VPU mul op

  l = np.sum(squared) # element-by-element running sum w VPU add op
  l = np.float32(0.0625) * l # VPU mul op

  dA = np.float32(0.125) * diff # element-by-element w VPU mul op

  # all above operations could be done more concisely with numpy functions
  # but written in expanded form for functional limits of VPU
  return np.float32(l), dA.astype(np.float32)
  

def relu_derivative(z):
  # z : fp32 value
  return np.float32(1.0 if z >= 0.0 else 0.0)

def backward_pass(W, X, b, Z, dA):
  # given weight, input, bias, output, gradient, perform MLP backward pass
  # W, X, Z, dA : 4x4 fp32 matrices
  # b : 4x1 fp32 vector
  W = np.array(W, dtype=np.float32)
  X = np.array(X, dtype=np.float32)
  b = np.array(b, dtype=np.float32)
  dA = np.array(dA, dtype=np.float32)

  dZ = np.zeros_like(dA)
  for i in range(len(dA)):
    for j in range(len(dA[0])):
      dZ[i][j] = dA[i][j] * relu_derivative(Z[i][j])

  dW = np.zeros_like(W)
  for i in range(len(W)):
    for j in range(len(W)):
      s = np.float32(0.0)
      for k in range(4):
        s += dZ[i][k] * X[j][k]
      dW[i][j] = np.float32(0.25) * s

  db = np.zeros_like(b)
  for i in range(4):
      sum_val = np.float32(0.0)
      for j in range(4):
          sum_val += dZ[i][j]  
      db[i] = np.float32(0.25) * sum_val 
  
  dX = np.zeros_like(X)
  for i in range(len(X)):
    for j in range(len(X)):
      s = np.float32(0.0)
      for k in range(len(dZ)):
        s += W[k][i] * dZ[k][j]
      dX[i][j] = s
  
  return dW.astype(np.float32), db.astype(np.float32), dX.astype(np.float32)