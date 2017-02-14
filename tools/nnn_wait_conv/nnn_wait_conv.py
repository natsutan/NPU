# https://github.com/fchollet/keras/blob/master/keras/engine/topology.py
# https://github.com/fchollet/keras/blob/master/LICENSE
# Kerasの学習データ抜き出しスクリプト
import h5py

input_hd5 = 'cnn.h5'


def load_weights(filepath, by_name=False):
    f = h5py.File(filepath, mode='r')
    if 'layer_names' not in f.attrs and 'model_weights' in f:
        f = f['model_weights']

    load_weights_from_hdf5_group(f)

    if hasattr(f, 'close'):
        f.close()


def load_weights_from_hdf5_group(f):

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


#        layer = flattened_layers[k]




load_weights(input_hd5)

