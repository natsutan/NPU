#include <stdio.h>
#include "nnnet_op.h"

int layer_print_name(const NNNET_LAYER *lp)
{

  printf("%s\n", lp->name);

  return 0;

}

