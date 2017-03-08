import numpy as np

arr = np.load('input/convolution2d_1_W_z.npy')
print('input/convolution2d_1_W_z.npy')
fil_0 = arr[:,:,:,0]
print(fil_0)
print('')
fil_1 = arr[:,:,:,1]
print(fil_1)

arr_2 = arr.reshape((32,1,3,3))

fil2_0 = arr_2[0,:,:,:]
print(fil2_0)

print(arr_2.shape)

