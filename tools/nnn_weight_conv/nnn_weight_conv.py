# https://github.com/fchollet/keras/blob/master/keras/engine/topology.py
# https://github.com/fchollet/keras/blob/master/LICENSE
# Kerasの学習データ抜き出しスクリプト
import h5py
import numpy as np
import sys
import itertools
import os

input_hd5 = '../../example/keres_cnn/keras/output/cnn.h5'
output_dir = '../..//example/keres_cnn/keras/output/'


def save_weights(filepath, by_name=False):
    f = h5py.File(filepath, mode='r')
    if 'layer_names' not in f.attrs and 'model_weights' in f:
        f = f['model_weights']

    save_weights_from_hdf5_group(f)

    if hasattr(f, 'close'):
        f.close()


def save_weights_from_hdf5_group(f):

    layer_names = [n.decode('utf8') for n in f.attrs['layer_names']]
    print(layer_names)

    filtered_layer_names = []
    for name in layer_names:
        g = f[name]
        weight_names = [n.decode('utf8') for n in g.attrs['weight_names']]
        if len(weight_names):
            filtered_layer_names.append(name)

    layer_names = filtered_layer_names

    print(layer_names)

    for k, name in enumerate(layer_names):
        g = f[name]
        weight_names = [n.decode('utf8') for n in g.attrs['weight_names']]
        weight_values = [g[weight_name] for weight_name in weight_names]
        print('')
        print(name)
        print(weight_names)
        for weight_name in weight_names:
            data = g[weight_name].value
            print(data.shape)
            data2 = tf_reshape(data)
            print(data2.shape)
            print('')

            filename = weight_name.replace(':0', '_z') + '.npy'
            filepath = os.path.join(output_dir, filename)
            np.save(filepath, data2, allow_pickle=False)
            print("save %s to %s" % (weight_name, filepath))


def tf_reshape(data):
    """
    matrixの並びを変える.
    [3][3][1][32]->[32][1][3][3]
    """
    ori_shape = data.shape

    if len(ori_shape) == 1:
        return data

    new_shape = list(ori_shape)
    new_shape.reverse()
    new_data = np.zeros(new_shape, dtype=data.dtype)

    i_r = range(new_shape[0])
    j_r = range(new_shape[1])

    if len(ori_shape) == 2:
        for i,j in itertools.product(i_r, j_r):
            new_data[i][j] = data[j][i]
    elif len(ori_shape) == 3:
        for i, j, k in itertools.product(i_r, j_r, range(new_shape[2])):
            new_data[i][j][k] = data[k][j][i]
    elif len(ori_shape) == 4:
        # [32][1][3][3]:
        for i,j,k,l in itertools.product(i_r, j_r, range(new_shape[2]), range(new_shape[3])):
            new_data[i][j][k][l] = data[l][k][j][i]
    else:
        print("error")
        sys.exit(1)

#    f0 = data[:,:,:,0]
#    f1 = data[:,:,:,1]

    return new_data


save_weights(input_hd5)

