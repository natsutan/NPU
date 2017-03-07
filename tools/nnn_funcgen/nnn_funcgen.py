# 関数名ルール
#
# FOO_i1_i2_w1_w2_o1_o1 ..
#
# 順番は
# ・入力データ (prefix i)
# ・重みデータ (prefix w)
# ・出力データ (prefix o)
#
# 重みデータが引数に含まれる場合は、重みデータは存在しない
#
# u usigned
# i integer
# f flaot
# q quantize
#
# 数字がビット幅
#
# 例
# Convolution2D_3x3_iui8_of()
#     3x3のConvolution2D
#     入力 8bit unsigned integer
#     重み 引数に含まれる
#     出力 float
import os

output_dir = '/home/natu/proj/myproj/NPU/C_ref/nnnet/'


def make_dir(func):
    import functools
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        odir = args[0]
        if not os.path.exists(odir):
            os.mkdir(path)

        ret = func(*args, **kwargs)
        return ret
    return wrapper


@make_dir
def make_conv_2d(odir):
    print(odir)





func_table = [['convolution2d', make_conv_2d],]

for f in func_table:
    odir = os.path.join(output_dir, f[0])
    f[1](odir)


