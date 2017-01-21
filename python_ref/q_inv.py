# 符号反転
import numpy as np
import npu
import matplotlib.pyplot as plt


def save_img(fname: object, V: object, q_V: object, deq_V: object, n: object = 1) -> object:
    x = np.arange(0, 1024)
    plt.figure(n)
    plt.plot(x, V, color="green")
    plt.plot(x, q_V, color="b")
    plt.plot(x, deq_V, color="r")
    plt.savefig('img/' + fname)


def save_mtx(fname, x):
    with open(fname, "w") as fp:
        for a in x:
            fp.write("%02X\n" % a)

A = np.arange(0, 1024, 1.0) + 50
a_min = 50.0
a_max = 1024+50.0
q_A = npu.Quantize(A, a_min, a_max)
deq_A = npu.deQuantize(q_A,a_min, a_max)

save_mtx('lin.dat', q_A)


B = 100 * np.sin(np.arange(0, 1024, 1.0) / 100) + 10
b_min = np.min(B)
b_max = np.max(B)
q_B = npu.Quantize(B, b_min, b_max)
deq_B = npu.deQuantize(q_B, b_min, b_max)
save_mtx('sin.dat', q_B)

save_img('lin.png', A, q_A, deq_A)
save_img('sin.png', B, q_B, deq_B, n=2)

# inv
q_Ainv, a_inv_min, a_inv_max = npu.q_inv(q_A, a_min, a_max)
deq_Ainv = npu.deQuantize(q_Ainv, a_inv_min, a_inv_max)
save_img('lin_inv.png', A, q_Ainv, deq_Ainv, n=3)

q_Binv, b_inv_min, b_inv_max = npu.q_inv(q_B, b_min, b_max)
deq_Binv = npu.deQuantize(q_Binv, b_inv_min, b_inv_max)
save_img('sin_inv.png', B, q_Binv, deq_Binv, n=4)

