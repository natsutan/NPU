import numpy as np

file = '../../example/keres_cnn/keras/output/convolution2d_2_W_z.npy'

data = np.load(file)

for i in range(32):
    f = data[0,i,:,:]
    print(f)