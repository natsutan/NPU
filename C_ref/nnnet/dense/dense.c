#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

int full_connection(NNNET_LAYER *np, void *inp, void *outp);


int nnn_Dense(NNNET_LAYER *np, void *inp, void *outp)
{
	int ret;

	ret = full_connection(np, inp, outp);

    return ret;
}


int full_connection(NNNET_LAYER *np, void *inp, void *outp)
{
	LY_Dense *dp = np->p_param;

	int f, n;

	int fillter_num = dp->output_dim;
	int input_num = dp->input_dim;

	float *ip = (float *)inp;
	float *op = outp;
	float *wp = dp->nnn_wp;
	float *bp = dp->nnn_bp;

	int idx_i, idx_o;
	float data;
	float weight;
	float bias;
	float accumlator;

	assert(dp->activation == LINEAR);
	assert(dp->b_regularizer == RG_NONE);
	assert(dp->W_regularizer == RG_NONE);
	assert(dp->activity_regularizer == RG_NONE);
	assert(dp->bias == true);

	for(f=0;f<fillter_num;f++) {
		accumlator = 0;
		for(n=0;n<input_num;n++) {
			idx_i = n;
			data = *(ip + idx_i );
			weight = *(wp + (f * input_num) + idx_i);
			accumlator += data * weight;
		}
		idx_o = f;
		bias = *(bp + f);
		accumlator += bias;
		*(op + idx_o) = accumlator;
	}


	return NNN_RET_OK;

}



