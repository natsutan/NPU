from PIL import Image
import numpy as np
from matplotlib import pylab as plt

img = np.array(Image.new("RGB", (28, 28)))
img[:,:,:] = 255

img[2,2,:] = 0

img[2,5,:] = 0
img[2,6,:] = 0

img[2,10,:] = 0
img[2,11,:] = 0
img[3,10,:] = 0
img[3,11,:] = 0


plt.imshow(img)

plt.imsave("p.png", img)
np.save('p,npy', img, allow_pickle=False)