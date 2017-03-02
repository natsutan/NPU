#include <stdio.h>
#include <string.h>

#include "nnnet.h"
#include "nnn_gen/nnn_gen.h"


int main(void)
{
  int data[28][28];

  NNNET *np;
  np = nnn_init();
  printf("%p\n", np);
  nnn_run(np, NULL);
  nnn_load_weight_from_files(np, "/home/natu/proj/myproj/NPU/example/keres_cnn/keras/output/");
  nnn_run(np, data);

  return 0;
}

