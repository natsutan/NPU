import numpy as np
from PIL import Image
from PIL import ImageOps

image_size = 28
infile = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/data/O.png'
outfile  = '/home/natu/proj/myproj/NPU/example/keres_cnn/keras/data/O.npy'

img_ori = Image.open(infile)
img_rgb = img_ori.convert('RGB')
img_gray = ImageOps.grayscale(img_ori)
img_resized = img_gray.resize((image_size, image_size))
#    img_resized = img_rgb.resize((image_size,image_size))

img_ary = np.asarray(img_resized)
img_ary = 255 - img_ary

np.save(outfile, img_ary, allow_pickle=False)