#include <stdio.h>
#include <string.h>

#include "nnnet.h"

#include "keras_cnn.h"

int main(void)
{

  //layrer
  convolution2d_1.nb_filter = 32;
  convolution2d_1.nb_row = 3;
  convolution2d_1.nb_col = 3;
  convolution2d_1.activation = LINEAR;
  convolution2d_1.border_mode = BD_VALID;
  convolution2d_1.input_dtype = NN_FLOAT32;
  convolution2d_1.subsample[0] = 1;
  convolution2d_1.subsample[1] = 1;
  convolution2d_1.batch_input_shape[0] = 0;
  convolution2d_1.batch_input_shape[1] = 28;
  convolution2d_1.batch_input_shape[2] = 28;
  convolution2d_1.batch_input_shape[3] = 1;

  //NN
  chiyaha_cnn.layernum = 1;

  chiyaha_cnn.layer[0].type = TP_CONVOLUTION2D;
  strcpy(chiyaha_cnn.layer[0].name, "convolution2d_1");
  chiyaha_cnn.layer[0].p_param = &convolution2d_1;
  chiyaha_cnn.layer[1].p_data = NULL;
  

  return 0;
}
