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
  A = np.zeros_like(Y)
  for i in range(len(Y)):
    Y[i] = bias_add(Y[i], b)
    A[i] = relu_op(Y[i])
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

  l = np.sum(squared) # element-by-element running sum w VPU add op
  l = np.float32(0.0625) * l # VPU mul op

  dA = np.float32(0.125) * diff # element-by-element w VPU mul op

  # all above operations could be done more concisely with numpy functions
  # but written in expanded form for functional limits of VPU
  return np.float32(l), dA.astype(np.float32)
  

def relu_derivative(z, m=4):
  # z : fp32 mx1 vector
  assert z.shape == (m, 1), "z must be mx1 vector"
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

  dW = np.zeros_like(W)
  dW = (0.25 * dZ @ X.T).astype(np.float32) 

  db = np.zeros_like(b)
  db = (0.25 * np.sum(dZ, axis=1, keepdims=True)).astype(np.float32)
  
  dX = np.zeros_like(X)
  dX = (W.T @ dZ).astype(np.float32)
  
  return dW.astype(np.float32), db.astype(np.float32), dX.astype(np.float32)