import numpy as np
from frontend.mlp_tpu import forward_pass, backward_pass, loss

# to run : pytest compiler/mlp_tpu_test.py

np.random.seed(72)

def test_forward_backward_pass():
    W = np.random.randn(4, 4).astype(np.float32)
    X = np.random.randn(4, 4).astype(np.float32)
    b = np.random.randn(4, 1).astype(np.float32)
    Y_target = np.random.randn(4, 4).astype(np.float32)

    Z, A = forward_pass(W, X, b)

    assert Z.shape == (4, 4)
    assert A.shape == (4, 4)
    assert Z.dtype == np.float32
    assert A.dtype == np.float32

    l, dA = loss(A, Y_target)

    assert np.isscalar(l)
    assert dA.shape == (4, 4)
    assert dA.dtype == np.float32

    dW, db, dX = backward_pass(W, X, b, Z, dA)

    assert dW.shape == (4, 4)
    assert db.shape == (4, 1)
    assert dX.shape == (4, 4)

    assert dW.dtype == np.float32
    assert db.dtype == np.float32
    assert dX.dtype == np.float32

    assert not np.any(np.isnan(dW))
    assert not np.any(np.isnan(db))
    assert not np.any(np.isnan(dX))
    assert not np.any(np.isinf(dW))
    assert not np.any(np.isinf(db))
    assert not np.any(np.isinf(dX))

    Y_ref = np.maximum(0, (W @ X) + b)
    loss_ref = np.mean((Y_ref - Y_target)**2)

    assert np.isclose(l, loss_ref, atol=0.5), \
        f"loss mismatch: expected {loss_ref}, got {l}"

    dA_ref = (0.125) * (Y_ref - Y_target)
    dZ_ref = dA_ref * (Y_ref > 0).astype(np.float32)
    dW_ref = 0.25 * (dZ_ref @ X.T)
    db_ref = 0.25 * np.sum(dZ_ref, axis=1, keepdims=True)
    dX_ref = W.T @ dZ_ref

    assert np.allclose(dW, dW_ref, atol=0.5), "dW mismatch"
    assert np.allclose(db, db_ref, atol=0.5), "db mismatch"
    assert np.allclose(dX, dX_ref, atol=0.5), "dX mismatch"

    print("test passed :D")

