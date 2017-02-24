#include <stdio.h>

#include "nnnet.h"

// weights
float w_convolution2d_1_W[32][3][3];
float w_convolution2d_1_B[32];


int main(void)
{
  int ret;
  NUMPY_HEADER header;

  ret = load_from_numpy(w_convolution2d_1_W, "input/convolution2d_1_W_z.npy", 32*3*3, &header);
  //  ret = load_from_numpy(w_convolution2d_1_W, "input/convolution2d_1_b_z.npy", 32, &header);
  printf("load_from_numpy %d\n", ret);

  ret = save_to_numpy(w_convolution2d_1_W, "output/2d1w.npy", &header);
  printf("save_to_numpy %d\n", ret);


  return 0;
}
