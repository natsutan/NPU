#include "nnnet.h"
#include "nnnet_op.h"

int nnn_run(NNNET* np, void *dp)
{

  int i;
  for(i=0;i<np->layernum;i++) {
    layer_print_name(np->layer+i);
  }

  return 0;
}

