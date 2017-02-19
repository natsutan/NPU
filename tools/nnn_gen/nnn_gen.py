#!/usr/bin/python3
import os
import datetime
import keras
import sys
# いろいろいったん決め打ちで

input_model = '/home/natu/myproj/NPU/example/keres_cnn/keras/output/cnn.json'
output_dir = '/home/natu/myproj/NPU/example/keres_cnn/c_ref/nnn_gen'

output_cfile = 'nnn_gen.c'
output_hfile = 'nnn_gen.h'

# nnnet.hに合わせる
NNN_MAX_LAYER_NAME = 256

activation_dic = {'linear' : 'LINEAR', 'relu' : 'RELU', 'softmax' : 'SOFTMAX'}
border_mode_dic = {'valid' : 'BD_VALID'}
input_dtype_dic = { 'float32' : 'NN_FLOAT32'}
regularizer_dic = { None : 'RG_NONE'}


def generate_header_file(file):
    with open(file, 'w') as fp:
        write_file_header(fp)
        fp.write('#include <string.h>\n')
        fp.write('#include "nnnet.h"\n')
        fp.write('NNNET* nnn_init(void);\n')
        fp.write('int nnn_load_weight(NNNET* np);\n')
        fp.write('int nnn_run(NNNET* np, void *dp);\n')


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


def print_info(func):
    import functools
    import os
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

    cnt = 0
    for l in model.get_config():
        class_name = l['class_name']
        config = l['config']

        name = config['name']

        fp.write('\tstrcpy(g_nnn.layer[%d].name, "%s");\n' % (cnt, name) )

        if len(name) > NNN_MAX_LAYER_NAME:
            print("ERROR %s is too long" % name)
            sys.exit(1)

        if class_name == 'Convolution2D':
            write_Convolution2D(fp, config)
        elif class_name == 'Activation':
            write_Activation(fp, config)
        elif class_name == 'MaxPooling2D':
            write__MaxPooling2D(fp, config)
        elif class_name == 'Dropout':
            write_Dropout(fp, config)
        elif class_name == 'Flatten':
            write_Flatten(fp, config)
        elif class_name == 'Dense':
            write_Dense(fp, config)
        else:
            print("ERROR:layer %s is not supported." % class_name)
            sys.exit(1)

        fp.write('\tg_nnn.layer[%d].p_param = &%s;\n' % (cnt, name))
        fp.write('\tg_nnn.layer[%d].p_data = NULL;\n' % cnt)

        fp.write('\n')
        cnt+=1


    fp.write('\treturn &g_nnn;\n')
    fp.write('}\n')



def generate_c_file(file):
    with open(file, 'w') as fp:
        write_file_header(fp)
        fp.write('#include "nnn_gen.h"\n')
        write_global_vaiable(fp)
        write_nnn_init(fp)




def write_file_header(fp):
    today = datetime.date.today()

    fp.write("//----------------------------------------------------------------------------------------------------\n")
    fp.write("// This file is automatically generated.\n")
    fp.write("// %s\n" % today.strftime('%Y/%m/%d %H:%M:%S'))
    fp.write("//----------------------------------------------------------------------------------------------------\n")



json_string = open(input_model).read()
model = keras.models.model_from_json(json_string)

print(model.summary())

generate_header_file(os.path.join(output_dir, output_hfile))
generate_c_file(os.path.join(output_dir, output_cfile))
