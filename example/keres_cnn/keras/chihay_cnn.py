# https://github.com/fchollet/keras/blob/master/examples/mnist_cnn.py
import sys
import numpy as np
from PIL import Image
from PIL import ImageOps
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Convolution2D, MaxPooling2D


np.random.seed(1337)  # for reproducibility

batch_size = 128
nb_epoch = 100

kana_list = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん'
image_size = 28
kana_num = len(kana_list)

# input image dimensions
img_rows, img_cols = image_size, image_size

# number of convolutional filters to use
nb_filters = 32
# size of pooling area for max pooling
pool_size = (2, 2)
# convolution kernel size
kernel_size = (3, 3)

def input_data_from_csv(file):

    """
    引数で指定されたcsvファイルから、画像データとラベルを読み込み、numpyの配列として返す。
    """
    images = np.empty([0, image_size, image_size], np.float32)
    labels = np.empty([0, kana_num], np.int)
    try:
        fp = open(file, 'r')
    except FileNotFoundError:
        print("Error %s がオープンできません" % file)
        sys.exit()

    for l in fp.readlines():
        l = l.rstrip()
        img_name, label = l.split(',')

        # 画像ファイルを開き、モノクロ化、リサイズ
        img_ori = Image.open(img_name)
        img_rgb = img_ori.convert('RGB')
        img_gray = ImageOps.grayscale(img_ori)
        img_resized = img_gray.resize((image_size,image_size))
    #    img_resized = img_rgb.resize((image_size,image_size))

        img_ary = np.asarray(img_resized)
        img_ary = 255 - img_ary
        images = np.append(images, [img_ary], axis=0)

        # ラベルの追加
        label_array = np.zeros(kana_num)
        label_array[int(label)] = 1
        labels = np.append(labels, [label_array], axis=0)

    return images, labels


(X_train, y_train) = input_data_from_csv('/media/natu/data/data/src/output/train.csv')
(X_test, y_test) = input_data_from_csv('/media/natu/data/data/src/output/test.csv')


X_train = X_train.reshape(X_train.shape[0], img_rows, img_cols, 1)
X_test = X_test.reshape(X_test.shape[0], img_rows, img_cols, 1)
input_shape = (img_rows, img_cols, 1)

# convert class vectors to binary class matrices
Y_train = y_train
Y_test = y_test

model = Sequential()

model.add(Convolution2D(nb_filters, kernel_size[0], kernel_size[1],
                        border_mode='valid',
                        input_shape=input_shape))
model.add(Activation('relu'))
model.add(Convolution2D(nb_filters, kernel_size[0], kernel_size[1]))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=pool_size))
model.add(Dropout(0.25))

model.add(Flatten())
model.add(Dense(128))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(kana_num))
model.add(Activation('softmax'))

model.compile(loss='categorical_crossentropy',
              optimizer='adadelta',
              metrics=['accuracy'])

with open('output/cnn.json', 'w') as fp:
    json_string = model.to_json()
    fp.write(json_string)

with open('output/cnn.yaml', 'w') as fp:
    yaml_string = model.to_yaml()
    fp.write(yaml_string)

model.fit(X_train, Y_train, batch_size=batch_size, nb_epoch=nb_epoch,
          verbose=1, validation_data=(X_test, Y_test))
score = model.evaluate(X_test, Y_test, verbose=0)
print('Test score:', score[0])
print('Test accuracy:', score[1])

#print model
print(model.summary())
config = model.get_config()
for l in config:
    print(l)

# save model
model.save('output/cnn.h5')
