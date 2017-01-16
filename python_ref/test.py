import numpy as np
import npy

# test
A = np.array([0, 1, 2, 3])
a_max = 3
a_min = 0
A_q = npy.Quantize(A, a_min, a_max)
print(A_q)

B = np.array([4, 6, 8, 10])
b_max = 10
b_min = 4
B_q = npy.Quantize(B, b_min, b_max)
print(B_q)

#add
print("ADD")
C_q, c_min, c_max = npy.q_add(A_q, a_min, a_max, B_q, b_min, b_max)
print(C_q)
print(npy.deQuantize(C_q, c_min, c_max))

#mul
print("MUL")
C_q, c_min, c_max = npy.q_mul(A_q, a_min, a_max, B_q, b_min, b_max)
print(C_q)
print(npy.deQuantize(C_q, c_min, c_max))

# 1/3
D_q = B_q
d_min = b_min / 3.0
d_max = b_max / 3.0
print(npy.deQuantize(D_q, d_min, d_max))