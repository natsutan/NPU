#!/usr/bin/python3
import os
import datetime
import keras
import sys
# いろいろいったん決め打ちで

input_model = '../../example/keres_cnn/keras/output/cnn.json'
output_dir = '../..//example/keres_cnn/c_ref/nnn_gen'

output_cfile = 'nnn_gen.c'
output_hfile = 'nnn_gen.h'

# nnnet.hに合わせる
NNN_MAX_LAYER_NAME = 256

activation_dic = {'linear': 'LINEAR', 'relu': 'RELU', 'softmax': 'SOFTMAX'}
border_mode_dic = {'valid': 'BD_VALID'}
input_dtype_dic = {'float32': 'NN_FLOAT32'}
regularizer_dic = {None: 'RG_NONE'}

type_dic = {'float32': 'float', "<dtype: 'float32'>": 'float'}


def generate_header_file(file):
    with open(file, 'w') as fp:
        write_file_header(fp)
        fp.write('#include <string.h>\n')
        fp.write('#include <assert.h>\n')
        fp.write('#include "nnnet.h"\n')
        fp.write('NNNET* nnn_init(void);\n')
        fp.write('int nnn_load_weight_from_files(NNNET* np, const char *path);\n')
        fp.write('int nnn_run(NNNET* np, void *dp);\n')


def get_prev_layer_output_dimension(i):
    """一つ前の層の出力数を取得する"""
    if i == 0:
        # 入力層
        return 1
    l = model.layers[i]
    shape = l.output_shape
    return shape[-1]


def get_prev_layer_output_name(i):
    if i == 0:
        # 入力層
        return 'dp'
    l = model.get_config()[i-1]
    config = l['config']
    name = config['name']
    return make_output_variable_name(name)


def write_global_vaiable(fp):
    # 将来的にはstaticにしてファイル内にシンボルを隠蔽
    fp.write('// network\n')
    fp.write('NNNET g_nnn;\n')
    fp.write('\n')
    fp.write('// layers\n')
    for l in model.get_config():
        class_name = l['class_name']
        config = l['config']
        name = config['name']
        if class_name == 'Convolution2D':
            fp.write('LY_Convolution2D %s;\n' % name)
        elif class_name == 'Activation':
            fp.write('LY_Activation %s;\n' % name)
        elif class_name == 'MaxPooling2D':
            fp.write('LY_MaxPooling2D %s;\n' % name)
        elif class_name == 'Dropout':
            fp.write('LY_Dropout %s;\n' % name)
        elif class_name == 'Flatten':
            fp.write('LY_Flatten %s;\n' % name)
        elif class_name == 'Dense':
            fp.write('LY_Dense %s;\n' % name)
        else:
            print("ERROR:layer %s is not supported." % class_name)
            sys.exit(1)

    fp.write('\n')
    fp.write('// weights\n')
    for i, l in enumerate(model.get_config()):
        class_name = l['class_name']
        config = l['config']
        name = config['name']
        if class_name == 'Convolution2D':
            dtype = config.get('input_dtype', 'float32')
            type_str = type_dic[dtype]
            [variable_name_w, variable_name_w_header, variable_name_b, variable_name_b_nph] = make_weight_variable_names(name)

            # row と colの値が違う場合は、仕様を決めること
            fp.write('NUMPY_HEADER %s;\n' % variable_name_w_header)
            fp.write('NUMPY_HEADER %s;\n' % variable_name_b_nph)

            prev_dim = get_prev_layer_output_dimension(i)

            assert(config['nb_row'] == config['nb_col'])
            if prev_dim == 1:
                fp.write("%s %s[%d][%d][%d];\n" %
                    (type_str, variable_name_w,  config['nb_filter'], config['nb_col'], config['nb_row']))
            else:
                fp.write("%s %s[%d][%d][%d][%d];\n" %
                    (type_str, variable_name_w, prev_dim, config['nb_filter'], config['nb_col'], config['nb_row']))

            fp.write("%s %s[%d];\n" %
                 (type_str, variable_name_b, config['nb_filter']))

        elif class_name == 'Dense':
            dtype = config.get('input_dtype', 'float32')
            type_str = type_dic[dtype]
            prev_dim = get_prev_layer_output_dimension(i)
            [variable_name_w, variable_name_w_header, variable_name_b, variable_name_b_nph] = make_weight_variable_names(name)
            fp.write('NUMPY_HEADER %s;\n' % variable_name_w_header)
            fp.write('NUMPY_HEADER %s;\n' % variable_name_b_nph)
            fp.write("%s %s[%d][%d];\n" %
                     (type_str, variable_name_w, prev_dim, config['input_dim']))
            fp.write("%s %s[%d];\n" %
                     (type_str, variable_name_b, config['input_dim']))

    # output
    fp.write('\n')
    fp.write('// output\n')
    for l in model.layers:
        name = l.name
        shape = l.output_shape
        variable_name = make_output_variable_name(name)
        dtype = str(l.output.dtype)
        type_str = type_dic[dtype]
        if len(shape) == 4:
            fp.write("%s %s[%d][%d][%d];\n" %
                    (type_str, variable_name, shape[3], shape[2], shape[1]))
        elif len(shape) == 3:
            fp.write("%s %s[%d][%d];\n" %
                    (type_str, variable_name, shape[2], shape[1]))
        elif len(shape) == 2:
            fp.write("%s %s[%d];\n" %
                    (type_str, variable_name, shape[1]))
        else:
            print("ERROR:layer %s, shape = %s is not supported." % (class_name, str(shape)))
            sys.exit(1)

    fp.write('\n')

def make_func_name(name):
    return 'nnn_' + name


def make_output_variable_name(name):
    return name+'_output'


def make_weight_variable_names(name):
    w = 'w_' + name + '_W'
    b = 'w_' + name + '_b'
    w_head = 'nph_' + name + '_W'
    b_head = 'nph_' + name + '_b'
    return w, w_head, b, b_head


def write_initialize_array_type(fp, config, member):
    name = config['name']
    arr = config.get(member, [0,])
    a = [0 if x is None else x for x in arr]
    for i in range(len(arr)):
        fp.write('\t%s.%s[%d] = %d;\n' % (name, member, i, a[i]))


def write_initialize_enum_type(fp, config, member, dic, default):
    name = config['name']

    if member not in config:
        enum = default
    else:
        val = config[member]
        if val in dic:
            enum = dic[val]
        else:
            print('ERROR %s %s %s is not supported' % (name, member, val))
            sys.exit(1)

    fp.write('\t%s.%s = %s;\n' % (name, member, enum))


def write_initialize_bool_type(fp, config, member):
    name = config['name']
    val = config[member]
    if val:
        s = 'true'
    else:
        s = 'false'
    fp.write('\t%s.%s = %s;\n' % (name, member, s))


def write_initialize_number_type(fp, config, member):
    name = config['name']
    val = config[member]
    fp.write("\t%s.%s = %s;\n" % (name, member, str(val)))


def write_initialize_wight(fp, config):
    name = config['name']
    [variable_name_w, variable_name_w_header, variable_name_b, variable_name_b_nph] = make_weight_variable_names(name)
    fp.write("\t%s.nnn_wp=%s;\n" % (name, variable_name_w))
    fp.write("\t%s.nnn_bp=%s;\n" % (name, variable_name_b))
    fp.write("\t%s.nnn_whp=&%s;\n" % (name, variable_name_w_header))
    fp.write("\t%s.nnn_bhp=&%s;\n" % (name, variable_name_b_nph))


def print_info(func):
    import functools
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        name = args[1]['name']
        print("genrating initialsze %s" % name)
        ret = func(*args, **kwargs)
        return ret

    return wrapper

@print_info
def write_Convolution2D(fp, config):
    write_initialize_number_type(fp, config, 'nb_filter')
    write_initialize_number_type(fp, config, 'nb_row')
    write_initialize_number_type(fp, config, 'nb_col')
    write_initialize_enum_type(fp, config, 'activation', activation_dic, 'NO_ACTIVATION')
    write_initialize_array_type(fp, config, 'batch_input_shape')
    write_initialize_enum_type(fp, config, 'border_mode', border_mode_dic, 'BD_NONE')
    write_initialize_enum_type(fp, config, 'b_regularizer', regularizer_dic, 'RG_NONE')
    write_initialize_enum_type(fp, config, 'W_regularizer', regularizer_dic, 'RG_NONE')
    write_initialize_enum_type(fp, config, 'activity_regularizer', regularizer_dic, 'RG_NONE')

    write_initialize_bool_type(fp, config, 'bias')
    write_initialize_enum_type(fp, config, 'input_dtype', input_dtype_dic, 'NN_DTYPE_NONE')
    write_initialize_array_type(fp, config, 'subsample')

    write_initialize_wight(fp, config)


@print_info
def write_Activation(fp, config):
    write_initialize_enum_type(fp, config, 'activation', activation_dic, 'NO_ACTIVATION')


@print_info
def write__MaxPooling2D(fp, config):
    write_initialize_array_type(fp, config, 'strides')
    write_initialize_array_type(fp, config, 'pool_size')
    write_initialize_enum_type(fp, config, 'border_mode', border_mode_dic, 'BD_NONE')


@print_info
def write_Dropout(fp, config):
    write_initialize_number_type(fp, config, 'p')


@print_info
def write_Flatten(fp, config):
    # do nothing
    pass


@print_info
def write_Dense(fp, config):
    write_initialize_number_type(fp, config, 'input_dim')
    write_initialize_number_type(fp, config, 'output_dim')
    write_initialize_enum_type(fp, config, 'activation', activation_dic, 'NO_ACTIVATION')
    write_initialize_enum_type(fp, config, 'b_regularizer', regularizer_dic, 'RG_NONE')
    write_initialize_enum_type(fp, config, 'W_regularizer', regularizer_dic, 'RG_NONE')
    write_initialize_enum_type(fp, config, 'activity_regularizer', regularizer_dic, 'RG_NONE')
    write_initialize_bool_type(fp, config, 'bias')


def write_nnn_init(fp):
    fp.write('NNNET* nnn_init(void)\n')
    fp.write('{\n')
    laynum = len(model.get_config())
    fp.write('\tg_nnn.layernum = %d;\n' % laynum)
    fp.write('\n')

    for (cnt, l) in enumerate(model.get_config()):
        class_name = l['class_name']
        config = l['config']

        name = config['name']

        fp.write('\tstrcpy(g_nnn.layer[%d].name, "%s");\n' % (cnt, name) )
        prev_dim = get_prev_layer_output_dimension(cnt)
        fp.write('\tg_nnn.layer[%d].prev_dim = %d;\n' % (cnt, prev_dim))

        if len(name) > NNN_MAX_LAYER_NAME:
            print("ERROR %s is too long" % name)
            sys.exit(1)

        if class_name == 'Convolution2D':
            fp.write('\tg_nnn.layer[%d].type = TP_CONVOLUTION2D;\n' % cnt)
            write_Convolution2D(fp, config)
        elif class_name == 'Activation':
            fp.write('\tg_nnn.layer[%d].type = TP_ACTIVATION;\n' % cnt)
            write_Activation(fp, config)
        elif class_name == 'MaxPooling2D':
            fp.write('\tg_nnn.layer[%d].type = TP_MAXPOOLING2D;\n' % cnt)
            write__MaxPooling2D(fp, config)
        elif class_name == 'Dropout':
            fp.write('\tg_nnn.layer[%d].type = TP_DROPOUT;\n' % cnt)
            write_Dropout(fp, config)
        elif class_name == 'Flatten':
            fp.write('\tg_nnn.layer[%d].type = TP_FLATTEN;\n' % cnt)
            write_Flatten(fp, config)
        elif class_name == 'Dense':
            fp.write('\tg_nnn.layer[%d].type = TP_DENSE;\n' % cnt)
            write_Dense(fp, config)
        else:
            print("ERROR:layer %s is not supported." % class_name)
            sys.exit(1)

        output_variable = make_output_variable_name(name)

        # いったん入力だけ
        if cnt == 0:
            fp.write('\tg_nnn.layer[%d].input_dtype = NN_UINT8;\n' % cnt)
        else:
            fp.write('\tg_nnn.layer[%d].input_dtype = NN_FLOAT32;\n' % cnt)

        fp.write('\tg_nnn.layer[%d].wight_dtype = NN_FLOAT32;\n' % cnt)
        fp.write('\tg_nnn.layer[%d].output_dtype = NN_FLOAT32;\n' % cnt)

        fp.write('\tg_nnn.layer[%d].p_param = &%s;\n' % (cnt, name))
        fp.write('\tg_nnn.layer[%d].p_data = &%s;\n' % (cnt, output_variable))

        fp.write('\n')

    fp.write('\treturn &g_nnn;\n')
    fp.write('}\n')
    fp.write('\n')


def write_nnn_load_weight_from_files(fp):
    fp.write('int nnn_load_weight_from_files(NNNET* np, const char *path)\n')
    fp.write('{\n')
    fp.write('\tchar buf[NNN_MAX_PATH];\n')
    fp.write('\tint path_len;\n')
    fp.write('\tint fname_w_len;\n')
    fp.write('\tint fname_b_len;\n')
    fp.write('\tint ret;\n')
    fp.write('\n')

    for i, l in enumerate(model.get_config()):
        class_name = l['class_name']
        config = l['config']

        if class_name in ['Convolution2D', 'Dense']:
            name = config['name']
            fname_w = name+'_W_z.npy'
            fname_b = name+'_b_z.npy'
            [variable_name_w, variable_name_w_header, variable_name_b, variable_name_b_header] = make_weight_variable_names(name)
            if class_name == 'Convolution2D':
                prev_dim = get_prev_layer_output_dimension(i)
                w_size = config['nb_row'] * config['nb_col'] * config['nb_filter'] * prev_dim
                b_size = config['nb_filter']
            else:
                #dense
                prev_dim = get_prev_layer_output_dimension(i)
                w_size = config['input_dim'] * prev_dim
                b_size = config['output_dim']

            fp.write('// %s\n' % name)
            fp.write('\tpath_len = strlen(path);\n')
            fp.write('\tfname_w_len = strlen("%s");\n' % fname_w)
            fp.write('\tfname_b_len = strlen("%s");\n' % fname_b)
            fp.write('\tassert(path_len+fname_w_len<NNN_MAX_PATH);\n')
            fp.write('\tassert(path_len+fname_b_len<NNN_MAX_PATH);\n')
            fp.write('\n')
            fp.write('\tstrcpy(buf, path);\n')
            fp.write('\tstrcat(buf, "%s");\n' % fname_w)
            fp.write('\tret = load_from_numpy(%s, buf, %d, &%s);\n' % (variable_name_w, w_size, variable_name_w_header))
            fp.write('\tif(ret != NNN_RET_OK){\n')
            fp.write('\t\treturn ret;\n')
            fp.write('\t}\n')
            fp.write('\tstrcpy(buf, path);\n')
            fp.write('\tstrcat(buf, "%s");\n' % fname_b)
            fp.write('\tret = load_from_numpy(%s, buf, %d, &%s);\n' % (variable_name_b, b_size, variable_name_b_header))
            fp.write('\tif(ret != NNN_RET_OK){\n')
            fp.write('\t\treturn ret;\n')
            fp.write('\t}\n')

            fp.write('\n')

    fp.write('\treturn NNN_RET_OK;\n')
    fp.write('}\n')
    fp.write('\n')



def write_nnn_run(fp):
    fp.write('int nnn_run(NNNET* np, void *dp)\n')
    fp.write('{\n')
    fp.write('\tint ret;\n')
    fp.write('\n')

    for i, l in enumerate(model.get_config()):
        class_name = l['class_name']
        config = l['config']
        name = config['name']
        inp = get_prev_layer_output_name(i)
        outp = make_output_variable_name(name)
        func_name = make_func_name(class_name)
        fp.write("//%s\n" % name)
        fp.write("\tret = %s(&(g_nnn.layer[%d]), %s, %s);\n" % (func_name, i, inp, outp))
        fp.write('\tif(ret != NNN_RET_OK){\n')
        fp.write('\t\treturn ret;\n')
        fp.write('\t}\n')
        fp.write('\n')

    fp.write('\treturn NNN_RET_OK;\n')
    fp.write('}\n')
    fp.write('\n')


def generate_c_file(file):
    with open(file, 'w') as fp:
        write_file_header(fp)
        fp.write('#include "nnn_gen.h"\n')
        write_global_vaiable(fp)
        write_nnn_init(fp)
        write_nnn_load_weight_from_files(fp)
        write_nnn_run(fp)

def write_file_header(fp):
    today = datetime.date.today()

    fp.write("//----------------------------------------------------------------------------------------------------\n")
    fp.write("// This file is automatically generated.\n")
    fp.write("// %s\n" % today.strftime('%Y/%m/%d %H:%M:%S'))
    fp.write("//----------------------------------------------------------------------------------------------------\n")


json_string = open(input_model).read()
model = keras.models.model_from_json(json_string)

layers = model.layers

print(model.summary())

generate_header_file(os.path.join(output_dir, output_hfile))
generate_c_file(os.path.join(output_dir, output_cfile))
