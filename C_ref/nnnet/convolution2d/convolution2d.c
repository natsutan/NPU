#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

#include "convolution2d.h"

int Convolution2D_3x3_iui8_of(NNNET_LAYER *np, void *inp, void *outp);

int nnn_Convolution2D(NNNET_LAYER *np, void *inp, void *outp)
{
	LY_Convolution2D *cnvp;

	cnvp = np->p_param;
	int ret;

	if((cnvp->nb_row == 3) && (cnvp->nb_col == 3)) {
		//3x3 filter
		if((np->input_dtype == NN_UINT8) && (np->wight_dtype == NN_FLOAT32) && (np->wight_dtype == NN_FLOAT32)) {
			ret = convolution2d3x3_iui8_of(np, inp, outp);
		}
	} else {
		printf("ERROR no supported parameter %s\n", np->name);
    	return NNN_RET_ERR;
	}


    return ret;
}

