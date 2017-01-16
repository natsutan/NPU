import numpy as np
import npu
import matplotlib.pyplot as plt


def save_img(fname, V, q_V, deq_V, n = 1):
    x = np.arange(0, 1023)
    plt.figure(n)
    plt.plot(x, V, color="green")
    plt.plot(x, q_V, color="b")
    plt.plot(x, deq_V, color="r")
    plt.savefig(fname)


A = np.arange(0, 1023, 1.0) + 50
a_min = 50.0
a_max = 1024+50.0
q_A = npu.Quantize(A, a_min, a_max)
deq_A = npu.deQuantize(q_A,a_min, a_max)

B = 100 * np.sin(np.arange(0, 1023, 1.0) / 100) + 10
b_min = np.min(B)
b_max = np.max(B)
q_B = npu.Quantize(B, b_min, b_max)
deq_B = npu.deQuantize(q_B, b_min, b_max)

# 定数の加算
b_min2 = b_min + 50
b_max2 = b_max + 50
deq_B = npu.deQuantize(q_B, b_min2, b_max2)
save_img('const_add.png', B, q_B, deq_B)

# Add
C = A + B
q_C, c_min, c_max = npu.q_add(q_A, a_min, a_max, q_B, b_min, b_max)
deq_C = npu.deQuantize(q_C, c_min, c_max)
save_img('add.png', C, q_C, deq_C, n=2)