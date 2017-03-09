#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "nnnet.h"


int nnn_Dropout(NNNET_LAYER *np, void *inp, void *outp)
{
	LY_Dropout *dop;
	dop = np->p_param;

	int size = dop->nnn_input_shape[0] * dop->nnn_input_shape[1] * dop->nnn_input_shape[2] * dop->nnn_input_shape[3];

	//float
	memmove(outp, inp, size * 4);


    return NNN_RET_OK;
}


