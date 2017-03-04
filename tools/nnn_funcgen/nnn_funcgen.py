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
