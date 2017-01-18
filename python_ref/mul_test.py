import numpy as np
import npu
import matplotlib.pyplot as plt


def save_img(fname, V, q_V, deq_V, n = 1):
    x = np.arange(0, 1023)
    plt.figure(n)
    plt.plot(x, V, color="green")
    plt.plot(x, q_V, color="b")
    plt.plot(x, deq_V, color="r")
    plt.savefig('img_test/'+fname)


def do_test(p):
    a_offset, b_offset, name, n = p
    A = np.arange(0, 1023, 1.0) + a_offset
    a_min = np.min(A)
    a_max = np.max(A)
    q_A = npu.Quantize(A, a_min, a_max)
#    deq_A = npu.deQuantize(q_A, a_min, a_max)

    B = np.arange(0, 1023, 1) / 2 + b_offset
    b_min = np.min(B)
    b_max = np.max(B)
    q_B = npu.Quantize(B, b_min, b_max)
 #   deq_B = npu.deQuantize(q_B, b_min, b_max)

    print("A %f - %f" % (a_min, a_max))
    print("B %f - %f" % (b_min, b_max))

    # mul test
    C = A * B
    q_C, c_min, c_max = npu.q_mul(q_A, a_min, a_max, q_B, b_min, b_max)
    deq_C = npu.deQuantize(q_C, c_min, c_max)

    print("C %f - %f" % (np.min(C), np.max(C)))
    print("q_C %f(%f) - %f(%f)" % (c_min, np.min(C) - c_min, c_max, np.max(C) - c_max))


    save_img(name + '.png', C, q_C, deq_C, n=n)


# test set
test_set = [[50, 100, 'pp_pp', 1],]


do_test(test_set[0])
