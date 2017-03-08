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
import datetime
import string

incdir = '../../C_ref/inc/'
output_dir = '../../C_ref/nnnet/'

ctype_dic = {'NN_FLOAT32': 'float', 'NN_UINT8': 'unsigned char'}
mangle_dic = {'NN_FLOAT32': 'f', 'NN_UINT8': 'ui8'}


def mangling(base, ilist, wlist, olist):
    fname = base
    for intype in ilist:
        fname += '_i' + mangle_dic[intype]

    for weight in wlist:
        fname += '_w' + mangle_dic[weight]

    for outtype in olist:
        fname += '_o' + mangle_dic[outtype]

    return fname

def make_dir(func):
    import functools
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        odir = args[1]
        if not os.path.exists(odir):
            os.mkdir(odir)

        ret = func(*args, **kwargs)
        return ret
    return wrapper


def write_file_header(fp):
    today = datetime.date.today()

    fp.write("//----------------------------------------------------------------------------------------------------\n")
    fp.write("// This file is automatically generated.\n")
    fp.write("// %s\n" % today.strftime('%Y/%m/%d %H:%M:%S'))
    fp.write("//----------------------------------------------------------------------------------------------------\n")

@make_dir
def make_activation(name, odir):
    pass


@make_dir
def make_conv_2d(name, odir):
    header_fname = os.path.join(incdir, name + '.h')
    header_fp = open(header_fname, 'w')
    write_file_header(header_fp)

    c_fname = os.path.join(odir, name + '3x3.c')
    c_fp = open(c_fname, 'w')
    write_file_header(c_fp)

    # header file include
    header_fp.write('#include <assert.h>\n')
    header_fp.write('#include "nnnet.h"\n')
    header_fp.write('#include "nnnet_def.h"\n')


    # C source include
    c_fp.write('#include "convolution2d.h"\n')

    # uint8 -> float
    fname = mangling(name + '3x3', ['NN_UINT8',], [], ['NN_FLOAT32',])
    proto_str = 'int %s(NNNET_LAYER *np, void *inp, void *outp)' % fname
    header_fp.write('%s;\n' % proto_str)

    t = string.Template(open('template/convolution2d_3x3.c').read())
    func_str = t.substitute(func_name=fname,
                            input_type=ctype_dic['NN_UINT8'],
                            weight_type=ctype_dic['NN_FLOAT32'],
                            output_type=ctype_dic['NN_FLOAT32'])
    c_fp.write(func_str)


    # float -> float
    fname = mangling(name + '3x3', ['NN_FLOAT32',], [], ['NN_FLOAT32',])
    proto_str = 'int %s(NNNET_LAYER *np, void *inp, void *outp)' % fname
    header_fp.write('%s;\n' % proto_str)

    t = string.Template(open('template/convolution2d_3x3.c').read())
    func_str = t.substitute(func_name=fname,
                            input_type=ctype_dic['NN_FLOAT32'],
                            weight_type=ctype_dic['NN_FLOAT32'],
                            output_type=ctype_dic['NN_FLOAT32'])
    c_fp.write(func_str)

    c_fp.close()
    header_fp.close()






func_table = [['convolution2d', make_conv_2d],
              ['activation', make_activation]]

print(os.getcwd())
for f in func_table:
    name = f[0]
    odir = os.path.join(output_dir, name)
    f[1](name, odir)


