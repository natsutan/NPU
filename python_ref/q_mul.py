import numpy as np
import npu
import matplotlib.pyplot as plt


def save_img(fname, V, q_V, deq_V, n = 1):
    x = np.arange(0, 1023)
    plt.figure(n)
    plt.plot(x, V, color="green")
    plt.plot(x, q_V, color="b")
    plt.plot(x, deq_V, color="r")
    plt.savefig('img/'+fname)


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


# 定数の乗算
b_min2 = b_min * 3
b_max2 = b_max * 3
deq_B = npu.deQuantize(q_B, b_min2, b_max2)
save_img('const_mul.png', B, q_B, deq_B)

q_B_inv, b_min3, b_max3 = npu.q_inv(q_B, b_min2, b_max2)
deq_B_inv = npu.deQuantize(q_B_inv, b_min3, b_max3)
save_img('const_mul_inv.png', -3 * B, q_B_inv, deq_B_inv, n = 10)



# mul
C = A * B
q_C, c_min, c_max = npu.q_mul(q_A, a_min, a_max, q_B, b_min, b_max)
deq_C = npu.deQuantize(q_C, c_min, c_max)
save_img('mul.png', C, q_C, deq_C, n=2)

q_C, c_min, c_max = npu.q_mul(q_B, b_min, b_max, q_A, a_min, a_max)
deq_C = npu.deQuantize(q_C, c_min, c_max)
save_img('mul2.png', C, q_C, deq_C, n=3)

# deQuantize
q_c_min = np.min(q_C)
q_c_max = np.max(q_C)
c_min2 = npu.deQuantize_scalar(q_c_min, c_min, c_max)
c_max2 = npu.deQuantize_scalar(q_c_max, c_min, c_max)
#req_C2 = npu.reQuantize(q_C, c_min, c_max, c_min2, c_max2)
req_C2 = npu.reQuantize(q_C, q_c_min, q_c_max, c_min2, c_max2)
deq_C2 = npu.deQuantize(req_C2, c_min2, c_max2)
save_img('mul2_deq.png', C, q_C, deq_C2, n=4)
