/*
 * flatten.c
 *
 *  Created on: 2017/03/11
 *      Author: natu
 */
#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

int flatten(NNNET_LAYER *np, void *inp, void *outp);


int nnn_Flatten(NNNET_LAYER *np, void *inp, void *outp)
{
	int ret;
	ret = flatten(np, inp, outp);

    return ret;
}


int flatten(NNNET_LAYER *np, void *inp, void *outp)
{
	//sizeチェック必要
	LY_Flatten *flp;
	flp = np->p_param;

	int size = flp->nnn_input_shape[0] * flp->nnn_input_shape[1] * flp->nnn_input_shape[2] * flp->nnn_input_shape[3];

	//float
	memmove(outp, inp, size * 4);

	return NNN_RET_OK;
}


