import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# conv2d 1
#keras_file = '../../example/keres_cnn/keras/output/convolution2d_out.npy'
# act 1
#keras_file = '../../example/keres_cnn/keras/output/act1_out.npy'

# conv2
#keras_file = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/conv2_out.npy'

# act 2
#keras_file = '../../example/keres_cnn/keras/output/act2_out.npy'
act2_file = '../../example/keres_cnn/keras/output/act2_out.npy'



# mp
lakeras_file = '../../example/keres_cnn/keras/output/flat_out.npy'

nnn_dir = '../../example/keres_cnn/c_ref/output/output/'



i=39

kr_data = np.load(keras_file)
print(kr_data.shape)

#for i in range(32):
#ko = kr_data[:,:,:,i]
ko = kr_data[0,:]

#nn = np.load(nnn_dir + 'act2_%02d.npy' % i)
nn = np.load(nnn_dir + 'flat.npy')


ko_f = ko.flatten()
nn_f = nn.flatten()

x = np.arange(len(ko_f))
plt.plot(x, ko_f, color='b')
plt.plot(x, nn_f, color='r')
plt.show()