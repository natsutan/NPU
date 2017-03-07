import numpy as np

file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/convolution2d_2_W_z.npy'

data = np.load(file)
print(data.shape)
print(data)