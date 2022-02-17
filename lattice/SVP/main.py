from random import randint
import numpy as np
MAX_INT_GEN = 10
DIM = 5

def eea(x,y):
    if y == 0: return x//abs(x),0
    q, r = x//y, x%y
    a, b = eea(y,x%y)
    return np.array([b,a-b*q], dtype=int)

def gcd(x,y):
    if abs(x) < abs(y): return gcd(y,x)
    if y == 0: return abs(x)
    return gcd(y, x%y)

def vec_gcd(xs):
    if len(xs) == 1: return xs[0]
    if len(xs) == 2: return gcd(xs[0],xs[1])
    half = len(xs)//2
    gcd1 = vec_gcd(xs[:half])
    gcd2 = vec_gcd(xs[half:])
    return gcd(gcd1, gcd2)

def vec_eea(xs):
    if len(xs) == 1: return np.array([xs[0]//abs(xs[0])], dtype=int)
    if len(xs) == 2: return eea(xs[0],xs[1])
    half = len(xs)//2
    eea1 = vec_eea(xs[:half])
    eea2 = vec_eea(xs[half:])
    val1 = eea1 @ np.array(xs[:half], dtype=int).T
    val2 = eea2 @ np.array(xs[half:], dtype=int).T
    a, b = eea(val1, val2)
    return np.concatenate([a*eea1, b*eea2])



basis_vectors = np.random.randint(0, MAX_INT_GEN, size=(DIM,DIM))
print(basis_vectors)

for i in range(0,DIM-1):
    coeffs = vec_eea(basis_vectors[i:,i])
    coeffs = np.concatenate([np.zeros((i),dtype=int), coeffs])
    pivot = (basis_vectors.T)@coeffs
    basis_vectors[i] = pivot
    for j in range(0,DIM):
        if i == j: continue
        basis_vectors[j] -= (basis_vectors[j,i]//basis_vectors[i,i])*basis_vectors[i]
    print(basis_vectors)
