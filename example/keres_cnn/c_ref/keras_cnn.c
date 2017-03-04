#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "nnnet.h"
#include "nnn_gen/nnn_gen.h"


const char infile[] = "/home/natu/proj/myproj/NPU/example/keres_cnn/keras/data/I.npy";

int main(void)
{
  unsigned char data[28][28];
  int ret;
  NNNET *np;

  NUMPY_HEADER np_header = default_numpy_header;

  np = nnn_init();

  ret = nnn_load_weight_from_files(np, "/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/");
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
      exit(1);
  }

  return 0;
}

