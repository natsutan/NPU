import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/convolution2d_out.npy'
nnn_dir = '/home/natu/myproj/NPU/example/keres_cnn/c_ref/output/output/'

kr_data = np.load(keras_file)
print(kr_data.shape)

#for i in range(32):
i=31
ko = kr_data[:,:,:,i]
nn = np.load(nnn_dir + 'conv2d1_%02d.npy' % i)
ko_f = ko.flatten()
nn_f = nn.flatten()

x = np.arange(26*26)
plt.plot(x, ko_f, color='b')
plt.plot(x, nn_f, color='r')
plt.show()