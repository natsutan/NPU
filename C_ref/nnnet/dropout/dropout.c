#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "nnnet.h"


int nnn_Dropout(NNNET_LAYER *np, void *inp, void *outp)
{
	LY_Dropout *dop;
	dop = np->p_param;

	int s0 = dop->nnn_input_shape[0];
	int s1 = dop->nnn_input_shape[1];
	int s2 = dop->nnn_input_shape[2];
	int s3 = dop->nnn_input_shape[3];


	if(s2==0) {
		s2 = 1;
	}
	if(s3 == 0) {
		s3 = 1;
	}
	assert(s1!=0);
	assert(s0!=0);

	int size = s0 * s1 * s2 * s3;

	assert(size!=0);

	//float
	memmove(outp, inp, size * 4);


    return NNN_RET_OK;
}


