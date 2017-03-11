#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nnnet.h"
#include "nnn_gen/nnn_gen.h"

const char infile[] = "../../keras/data/O.npy";
//const char infile[] = "../../keras/data/p.npy";

extern float convolution2d_1_output[32][26][26];
extern float activation_1_output[32][26][26];
extern float convolution2d_2_output[32][24][24];
extern float activation_2_output[32][24][24];
extern float maxpooling2d_1_output[40][12][12];
extern float dropout_1_output[40][12][12];
extern float flatten_1_output[5760];
extern float dense_1_output[128];
extern float activation_3_output[128];
extern float dropout_2_output[128];
extern float dense_2_output[46];
extern float activation_4_output[46];

int main(void)
{
  int ret;
  NNNET *np;

  unsigned int data[28][28];
  NUMPY_HEADER np_header = default_numpy_header;

  np = nnn_init();

  ret = nnn_load_weight_from_files(np, "../../keras/output/");
  if(ret!=NNN_RET_OK) {
    printf("error nnn_load_weight_from_files returns %d\n", ret);
      exit(1);
  }

  ret = load_from_numpy(data, infile, 28*28, &np_header);
  if(ret!=NNN_RET_OK) {
    printf("error load_from_numpy returns %d\n", ret);
      exit(1);
  }

  ret = nnn_run(np, data);
  if(ret!=NNN_RET_OK) {
    printf("error nnn_run returns %d\n", ret);
  }


  NUMPY_HEADER np_header_f;
  np_header_f = np_header;  //入力のヘッダーをコピー
  np_header_f.descr = NN_FLOAT32;
  np_header_f.shape[0] = 46;
  np_header_f.shape[1] = 1;
  np_header_f.shape[2] = 0;
  np_header_f.shape[3] = 0;

  save_to_numpy(dense_2_output, "output/dense2.npy", &np_header_f);


  printf("finish\n");
  for(int i=0;i<46;i++) {
	  printf("%f\n", activation_4_output[i]);
  }

  return 0;
}
