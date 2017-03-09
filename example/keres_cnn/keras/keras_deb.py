import numpy as np
from PIL import Image
from PIL import ImageOps
from keras.models import model_from_json
from keras import backend as K

json_string = open('output/cnn.json', 'r').read()
model = model_from_json(json_string)
model.load_weights('output/cnn.h5')

# load image
images = np.empty([0, 28, 28], np.float32)
img_ori = Image.open('data/I.png')
#img_ori = Image.open('data/p.png')

img_gray = ImageOps.grayscale(img_ori)

img_ary = np.asarray(img_gray)
img_ary = 255 - img_ary
images = np.append(images, [img_ary], axis=0)

images = images.reshape(1, 28, 28, 1)

# predict
ret = model.predict(images, 1, 1)
print(ret)

# output
get_1st_layer_output = K.function([model.layers[0].input],
                                  [model.layers[0].output])
layer_output = get_1st_layer_output([images,])
print(layer_output[0].shape)
np.save('output/conv1_out.npy', layer_output[0], allow_pickle=False)
#np.save('output/p.npy', img_ary, allow_pickle=False)

get_2nd_layer_output = K.function([model.layers[0].input],
                                  [model.layers[1].output])

layer_output = get_2nd_layer_output([images,])
print(layer_output[0].shape)
np.save('output/act1_out.npy', layer_output[0], allow_pickle=False)

get_3rd_layer_output = K.function([model.layers[0].input],
                                  [model.layers[2].output])

layer_output = get_3rd_layer_output([images,])
print(layer_output[0].shape)
np.save('output/conv2_out.npy', layer_output[0], allow_pickle=False)

get_4th_layer_output = K.function([model.layers[0].input],
                                  [model.layers[3].output])

layer_output = get_4th_layer_output([images,])
print(layer_output[0].shape)
np.save('output/act2_out.npy', layer_output[0], allow_pickle=False)


get_5th_layer_output = K.function([model.layers[0].input],
                                  [model.layers[4].output])

layer_output = get_5th_layer_output([images,])
print(layer_output[0].shape)
np.save('output/maxpool_out.npy', layer_output[0], allow_pickle=False)

