import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# conv2d 1
#keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/convolution2d_out.npy'
# act 1
#keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/act1_out.npy'

# conv2
keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/conv2_out.npy'

# act 2
keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/act2_out.npy'

nnn_dir = '/home/natu/myproj/NPU/example/keres_cnn/c_ref/output/output/'

kr_data = np.load(keras_file)
print(kr_data.shape)

#for i in range(32):
i=0
ko = kr_data[:,:,:,i]
nn = np.load(nnn_dir + 'act2_%02d.npy' % i)
ko_f = ko.flatten()
nn_f = nn.flatten()

x = np.arange(len(ko_f))
plt.plot(x, ko_f, color='b')
plt.plot(x, nn_f, color='r')
plt.show()