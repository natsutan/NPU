import numpy as np

# 8bitの最大値
QUANTIZE_BIT = 8
MAX_VALUE = (2 ** QUANTIZE_BIT )- 1


def deQuantize_scalar(x, min, max):
    """量子化を元に戻す"""
    gain = (max - min) / MAX_VALUE
    return x * gain + min


def deQuantize(arr, a_min, a_max):
    """量子化を元に戻す"""
    gain = (a_max - a_min) / MAX_VALUE
    return arr * gain + a_min

def Quantize(arr, min, max):
    """量子化を行う"""
    range = (max - min)
    range_scale = range / MAX_VALUE
    return ((arr - min) / range_scale).astype(np.int)


def reQuantize(arr, min, max, new_min, new_max):
    gain = (new_max - new_min) / (max - min)
    # start vector
    c_qt = arr * gain

    return c_qt.astype(np.int)


def q_inv(a_qt, a_min, a_max):
    """符号反転"""
    return MAX_VALUE - a_qt, - a_max, - a_min


def q_add(a_qt, a_min, a_max, b_qt, b_min, b_max):
    """加算"""
    gain = (b_max - b_min) / (a_max - a_min)
    min = a_min + b_min
    max = a_max + b_max
    q_param = (a_max - a_min) / (max - min)

    # start vector
    c_qt = b_qt * gain + a_qt
    c_qt *= q_param

    return c_qt.astype(np.int), min, max


def q_mul(a_qt, a_min, a_max, b_qt, b_min, b_max):
    """乗算"""
    Adash_max = a_max - a_min
    Adash_min = 0.0
    Bdash_max = b_max - b_min
    Bdash_min = 0.0

    AdBd_qt, AdBd_min, AdBd_max = q_mul_core(a_qt, Adash_min, Adash_max, b_qt, Bdash_min, Bdash_max)

    # constant mul
    if b_min < 0:
        # 符号反転
        qt_A_bmin, A_bmin_min_inv, A_bmin_max_inv = q_inv(a_qt, a_min, a_max)
        # 定数倍
        A_bmin_min = A_bmin_min_inv * -b_min
        A_bmin_max = A_bmin_max_inv * -b_min
    else:
        A_bmin_max = a_max * b_min
        A_bmin_min = a_min * b_min
        qt_A_bmin = a_qt

    if a_min < 0:
        qt_B_amin, B_amin_min_inv, B_amin_max_inv = q_inv(b_qt, b_min, b_max)
        B_amin_max = B_amin_max_inv * -a_min
        B_amin_min = B_amin_min_inv * -a_min

    else:
        B_amin_max = b_max * a_min
        B_amin_min = b_min * a_min
        qt_B_amin = b_qt

    C_qt_0, C_qt_0_min, C_qt_0_max = q_add(qt_A_bmin, A_bmin_min, A_bmin_max, qt_B_amin, B_amin_min, B_amin_max)
    C_qt, c_min, c_max = q_add(AdBd_qt, AdBd_min, AdBd_max, C_qt_0, C_qt_0_min, C_qt_0_max)

    f1 = a_min * b_min
    c_max_f = c_max - f1
    c_min_f = c_min - f1


    return C_qt.astype(np.int), c_min_f, c_max_f


def q_mul_core(a_qt, a_min, a_max, b_qt, b_min, b_max):
    """乗算"""
    gain_a = (a_max - a_min) / MAX_VALUE
    gain_b = (b_max - b_min) / MAX_VALUE
    min = a_min * b_min
    max = a_max * b_max
    q_param = MAX_VALUE / (max - min)


    p_gagb = gain_a * gain_b * q_param
    p_gaob = gain_a * b_min * q_param
    p_gboa = gain_b * a_min * q_param

    # start vector alu
    AB = (p_gagb * a_qt * b_qt).astype(np.int)
    gaob_A = (a_qt * p_gaob).astype(np.int)
    gboa_B = (b_qt * p_gboa).astype(np.int)
    c_qt = AB + gaob_A + gboa_B

    return c_qt.astype(np.int), min, max

