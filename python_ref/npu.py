import numpy as np

# 8bitの最大値
QUANTIZE_BIT = 8
MAX_VALUE = (2 ** QUANTIZE_BIT) - 1


def deQuantize(arr, min, max):
    """量子化を元に戻す"""
    gain = (max - min) / MAX_VALUE
    return arr * gain + min


def Quantize(arr, min, max):
    """量子化を行う"""
    range = max - min
    range_scale = range / MAX_VALUE
    return ((arr - min) / range_scale).astype(np.int)


def q_inv(a_qt, a_min, a_max):
    """符号反転"""
    return MAX_VALUE - a_qt, - a_max, - a_min


def q_add(a_qt, a_min, a_max, b_qt, b_min, b_max):
    """加算"""
    gain = (b_max - b_min) / (a_max - a_min)
    min = a_min + b_min
    max = a_max + b_max
    c_qt = b_qt * gain + a_qt
    x = np.max(c_qt) - np.min(c_qt)
    q_param = x / MAX_VALUE

    c_qt *= q_param


    return c_qt, min, max


def q_mul(a_qt, a_min, a_max, b_qt, b_min, b_max):
    """乗算"""
    gain_a = (a_max - a_min) / MAX_VALUE
    gain_b = (b_max - b_min) / MAX_VALUE
    offset_a = a_min
    offset_b = b_min
    p_gagb = gain_a * gain_b
    p_gaob = gain_a * offset_b
    p_gboa = gain_b * offset_a
    p_oaob = offset_a * offset_b
    min = p_oaob
    max = a_max * b_max
    q_param = (max - min) / MAX_VALUE

    # start vector alu
    AB = p_gagb * a_qt * b_qt
    gaob_A = a_qt * p_gaob
    gboa_B = b_qt * p_gboa

    c_qt = AB + gaob_A + gboa_B
    c_qt /= q_param

    return c_qt, min, max

