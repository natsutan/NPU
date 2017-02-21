import numpy as np

file = 'dense_1_b_z.npy'

data = np.load(file)
print(data.shape)
print(data)