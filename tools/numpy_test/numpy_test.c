#include <stdio.h>

#include "nnnet.h"

// weights
float w_convolution2d_1_W[32][3][3];
//float w_convolution2d_1_W[3][3][32];

float w_convolution2d_1_B[32];


int main(void)
{
  int ret;
  NUMPY_HEADER header;

  ret = load_from_numpy(w_convolution2d_1_W, "input/convolution2d_1_W_zf.npy", 32*3*3, &header);
  //  ret = load_from_numpy(w_convolution2d_1_W, "input/convolution2d_1_b_z.npy", 32, &header);
  printf("load_from_numpy %d\n", ret);

  printf("%f\n", w_convolution2d_1_W[0][0][0]);
  printf("%f\n", w_convolution2d_1_W[0][0][1]);
  printf("%f\n", w_convolution2d_1_W[0][0][2]);

  printf("%f\n", w_convolution2d_1_W[0][1][0]);
  printf("%f\n", w_convolution2d_1_W[0][1][1]);
  printf("%f\n", w_convolution2d_1_W[0][1][2]);

  
  
  //  ret = save_to_numpy(w_convolution2d_1_W, "output/2d1w.npy", &header);
  //printf("save_to_numpy %d\n", ret);


  return 0;
}
