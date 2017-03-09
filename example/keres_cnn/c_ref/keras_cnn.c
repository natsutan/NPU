#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nnnet.h"
#include "nnn_gen/nnn_gen.h"

const char infile[] = "../../keras/data/I.npy";
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
      //exit(1);
  }


  NUMPY_HEADER np_header_26;
  np_header_26 = np_header;  //入力のヘッダーをコピー
  np_header_26.descr = NN_FLOAT32;
  np_header_26.shape[0] = 26;
  np_header_26.shape[1] = 26;
  np_header_26.shape[2] = 0;
  np_header_26.shape[3] = 0;

  char out_fname[256];

  for(int f=0;f<32;f++) {
	  sprintf(out_fname, "output/conv2d1_%02d.npy", f);
	  save_to_numpy(convolution2d_1_output[f], out_fname, &np_header_26);
  }

  for(int f=0;f<32;f++) {
	  sprintf(out_fname, "output/act1_%02d.npy", f);
	  save_to_numpy(activation_1_output[f], out_fname, &np_header_26);
  }

  NUMPY_HEADER np_header_24;
  np_header_24 = np_header;  //入力のヘッダーをコピー
  np_header_24.descr = NN_FLOAT32;
  np_header_24.shape[0] = 24;
  np_header_24.shape[1] = 24;
  np_header_24.shape[2] = 0;
  np_header_24.shape[3] = 0;
  for(int f=0;f<32;f++) {
	  sprintf(out_fname, "output/act2_%02d.npy", f);
	  save_to_numpy(activation_2_output[f], out_fname, &np_header_24);
  }

  NUMPY_HEADER np_header_12;
  np_header_12 = np_header;  //入力のヘッダーをコピー
  np_header_12.descr = NN_FLOAT32;
  np_header_12.shape[0] = 12;
  np_header_12.shape[1] = 12;
  np_header_12.shape[2] = 0;
  np_header_12.shape[3] = 0;
  for(int f=0;f<40;f++) {
	  sprintf(out_fname, "output/do_%02d.npy", f);
	  save_to_numpy(dropout_1_output[f], out_fname, &np_header_12);
  }



  return 0;
}

