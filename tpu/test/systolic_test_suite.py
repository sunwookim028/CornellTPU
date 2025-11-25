# systolic_test_suite.py
# Directed and random testing suite for systolic array
# Define input matrices for use in test_systolic_wrapper_suite.py

import numpy as np

# Seed for reproducibility:
np.random.seed(0xDEADBEEF)

# Global constant: array size
N = 4

# Helper function for random test case matrices
def random_matrix(low=-1.0, high=1.0):
    return np.random.uniform(low, high, size=(N, N))

# Number of iterations to perform per random case
NUM_ITERATIONS = 5

# Define bounds for different random tests
# Be careful to avoid overflow with large magnitude numbers
# These should be set with data type in mind
LARGE_LOWER_BOUND = -5.6 # Theoretical max magnitude to avoid overflow
LARGE_UPPER_BOUND = 5.6
SMALL_LOWER_BOUND = LARGE_LOWER_BOUND / 2
SMALL_UPPER_BOUND = LARGE_UPPER_BOUND / 2

# Directed Tests:

TEST_CASES = [

    # 1. Identity
    {
        "name": "identity_pass_through",
        "W": np.eye(N),
        "X": np.eye(N),
    },

    # 2. All zeros
    {
        "name": "zero_zero",
        "W": np.zeros((N, N)),
        "X": np.zeros((N, N)),
    },

    # 3. Zero * random
    {
        "name": "zero_random",
        "W": np.zeros((N, N)),
        "X": random_matrix(-2, 2),
    },

    # 4. Random * zero
    {
        "name": "random_zero",
        "W": random_matrix(-2, 2),
        "X": np.zeros((N, N)),
    },

    # 5. Small integers (your original)
    {
        "name": "small_integers",
        "W": np.array([[1,2,3,4],
                       [5,6,7,8],
                       [1,3,1,3],
                       [2,4,2,4]], dtype=float),
        "X": np.array([[2,1,0,1],
                       [1,1,3,1],
                       [3,-1,2,0],
                       [0,2,0,1]], dtype=float),
    },

    # 6. Anti-diagonal matrix
    {
        "name": "antidiagonal",
        "W": np.fliplr(np.eye(N)),
        "X": np.arange(1, N*N+1).reshape(N, N),
    },

    # 7. Diagonal-dominant
    {
        "name": "diag_dominant",
        "W": np.eye(N) * 5 + np.ones((N, N)),
        "X": np.eye(N) * 3 + random_matrix(-1,1),
    },

    # 8. Sparse matrix (few non-zero entries)
    {
        "name": "sparse",
        "W": np.array([[5,0,0,0],
                       [0,0,0,1],
                       [0,3,0,0],
                       [0,0,2,0]], dtype=float),
        "X": np.array([[0,1,0,0],
                       [0,0,2,0],
                       [3,0,0,0],
                       [0,0,0,4]], dtype=float),
    },

    # 9. Alternating sign
    {
        "name": "checkerboard",
        "W": np.fromfunction(lambda i,j: ((i+j)%2)*2-1, (N,N)),
        "X": np.fromfunction(lambda i,j: 1-((i+j)%2), (N,N)),
    },

    # 10. Symmetric matrix
    {
        "name": "symmetric",
        "W": np.array([[4,1,2,1],
                       [1,3,1,0],
                       [2,1,5,1],
                       [1,0,1,2]], dtype=float),
        "X": random_matrix(-2,2),
    },

    # 11. Anti-symmetric matrix
    {
        "name": "antisymmetric",
        "W": np.array([[ 0, 2,-1, 3],
                       [-2, 0, 4,-1],
                       [ 1,-4, 0, 2],
                       [-3, 1,-2, 0]], dtype=float),
        "X": random_matrix(-2,2),
    },

    # 12. Saturation stress test (near Q8.8 max of ±7.9)
    {
        "name": "saturation_stress",
        "W": np.full((N,N), 5.6),
        "X": np.full((N,N), -5.6),
    },

    # 13. Permutation matrix
    {
        "name": "permutation_matrix",
        "W": np.eye(N)[[2,0,3,1]],   # permute rows
        "X": random_matrix(-2,2),
    },

    # 14. Orthogonal-ish (Hadamard scaled)
    {
        "name": "hadamard",
        "W": (1/2)*np.array([[ 1, 1, 1, 1],
                            [ 1,-1, 1,-1],
                            [ 1, 1,-1,-1],
                            [ 1,-1,-1, 1]], dtype=float),
        "X": random_matrix(-2,2),
    },
]

# Random Tests:

# Small neg small pos
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_neg_small_pos_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND,0),
        "X": random_matrix(0,SMALL_UPPER_BOUND),
    })

# Small pos small neg
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_pos_small_neg_{i}",
        "W": random_matrix(0,SMALL_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND,0),
    })

# Small pos small pos
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_pos_small_pos_{i}",
        "W": random_matrix(0,SMALL_UPPER_BOUND),
        "X": random_matrix(0,SMALL_UPPER_BOUND),
    })

# Small neg small neg
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_neg_small_neg_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND,0),
        "X": random_matrix(SMALL_LOWER_BOUND,0),
    })

# Small mixed small mixed
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_mixed_small_mixed_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND,SMALL_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND,SMALL_UPPER_BOUND),
    })

# Large mixed small mixed
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"large_mixed_small_mixed_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND,SMALL_UPPER_BOUND),
    })

# Small mixed large mixed
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"large_mixed_small_mixed_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND,SMALL_UPPER_BOUND),
        "X": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
    })
    
# Large mixed large mixed
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"large_mixed_large_mixed_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
        "X": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
    })

# Zero large mixed
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"zero_large_mixed_{i}",
        "W": random_matrix(0,0),
        "X": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
    })

# Large mixed zero
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"large_mixed_zero_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND,LARGE_UPPER_BOUND),
        "X": random_matrix(0,0),
    })

# The following test cases are AI generated:

# =========================
# HIGH-MAGNITUDE STRESS TESTS
# =========================

# Max magnitude
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"max_mag_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND, LARGE_UPPER_BOUND),
        "X": random_matrix(LARGE_LOWER_BOUND, LARGE_UPPER_BOUND),
    })

# Half magnitude
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"half_mag_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
    })

# Large W, small X
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"largeW_smallX_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND, LARGE_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
    })

# Small W, large X
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"smallW_largeX_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
        "X": random_matrix(LARGE_LOWER_BOUND, LARGE_UPPER_BOUND),
    })


# =========================
# LOW-MAGNITUDE / PRECISION TESTS
# =========================

# Small only
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"small_small_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
    })

# Tiny values
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"tiny_vals_{i}",
        "W": random_matrix(-0.01, 0.01),
        "X": random_matrix(-0.01, 0.01),
    })

# Opposing small values (cancellation)
for i in range(NUM_ITERATIONS):
    W = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    X = -W + np.random.uniform(-0.05, 0.05, size=W.shape)  # small noise
    TEST_CASES.append({
        "name": f"cancel_small_{i}",
        "W": W,
        "X": X,
    })


# =========================
# SIGN PATTERN TESTS
# =========================

# All positive
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"all_pos_{i}",
        "W": random_matrix(0, LARGE_UPPER_BOUND),
        "X": random_matrix(0, LARGE_UPPER_BOUND),
    })

# All negative
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"all_neg_{i}",
        "W": random_matrix(LARGE_LOWER_BOUND, 0),
        "X": random_matrix(LARGE_LOWER_BOUND, 0),
    })

# Mixed sign random
for i in range(NUM_ITERATIONS):
    TEST_CASES.append({
        "name": f"mixed_sign_{i}",
        "W": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
        "X": random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND),
    })

# Checkerboard sign pattern
for i in range(NUM_ITERATIONS):
    W = np.fromfunction(lambda r,c: ((r+c)%2)*2-1, (N,N)) * np.random.uniform(0.1, SMALL_UPPER_BOUND, (N,N))
    X = np.fromfunction(lambda r,c: ((r+c+1)%2)*2-1, (N,N)) * np.random.uniform(0.1, SMALL_UPPER_BOUND, (N,N))
    TEST_CASES.append({
        "name": f"checkerboard_sign_{i}",
        "W": W,
        "X": X,
    })


# =========================
# PATTERN-STRUCTURED TESTS
# =========================

# Constant matrix
for i in range(NUM_ITERATIONS):
    valW = np.random.uniform(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    valX = np.random.uniform(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    W = np.full((N, N), valW)
    X = np.full((N, N), valX)
    TEST_CASES.append({
        "name": f"constant_{i}",
        "W": W,
        "X": X,
    })

# Identity-like pattern
for i in range(NUM_ITERATIONS):
    scale = np.random.uniform(0.1, SMALL_UPPER_BOUND)
    W = np.eye(N) * scale
    X = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    TEST_CASES.append({
        "name": f"identity_scaled_{i}",
        "W": W,
        "X": X,
    })


# =========================
# CORRELATED / RANK STRUCTURED TESTS
# =========================

# Correlated inputs (X ≈ W)
for i in range(NUM_ITERATIONS):
    W = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    X = W + np.random.uniform(-0.05, 0.05, (N,N))
    TEST_CASES.append({
        "name": f"correlated_{i}",
        "W": W,
        "X": X,
    })

# Rank-1 matrices
for i in range(NUM_ITERATIONS):
    a = np.random.uniform(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND, (N,1))
    b = np.random.uniform(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND, (1,N))
    W = a @ b
    X = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    TEST_CASES.append({
        "name": f"rank1_{i}",
        "W": W,
        "X": X,
    })

# Near singular (rows almost identical)
for i in range(NUM_ITERATIONS):
    base = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    noise = np.random.uniform(-0.01, 0.01, (N,N))
    W = base + noise
    X = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    TEST_CASES.append({
        "name": f"near_singular_{i}",
        "W": W,
        "X": X,
    })


# =========================
# SATURATION-SPECIFIC TESTS
# =========================

# Saturation push (near max magnitude aggregates)
for i in range(NUM_ITERATIONS):
    W = random_matrix(4.0, 5.6)
    X = random_matrix(4.0, 5.6)
    TEST_CASES.append({
        "name": f"sat_push_{i}",
        "W": W,
        "X": X,
    })

# Alternating high/low magnitude
for i in range(NUM_ITERATIONS):
    W = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    X = random_matrix(LARGE_LOWER_BOUND, LARGE_UPPER_BOUND)
    TEST_CASES.append({
        "name": f"alt_mag_{i}",
        "W": W,
        "X": X,
    })

# Random outliers
for i in range(NUM_ITERATIONS):
    W = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    X = random_matrix(SMALL_LOWER_BOUND, SMALL_UPPER_BOUND)
    # Insert a few large outliers
    for _ in range(3):
        r, c = np.random.randint(0,N), np.random.randint(0,N)
        W[r,c] = np.random.uniform(4.0,5.6)
    TEST_CASES.append({
        "name": f"outliers_{i}",
        "W": W,
        "X": X,
    })