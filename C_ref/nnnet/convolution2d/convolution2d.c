#include <assert.h>
#include "nnnet.h"

int nnn_Convolution2D(NNNET_LAYER *np, void *inp, void *outp)
{
	LY_Convolution2D *cnvp;

	cnvp = np->p_param;
	int ret;

	if((cnvp->nb_row == 3) && (cnvp->nb_col == 3)) {
		//3x3 filter
		if((np->input_dtype == NN_UINT8) && (np->wight_dtype == NN_FLOAT32) && (np->wight_dtype == NN_FLOAT32)) {
			ret = Convolution2D_3x3_iui8_of(np, inp, outp);
		}
	} else {
		printf("ERROR no supported parameter %s\n", np->name);
    	return NNN_RET_ERR;
	}







    return ret;
}


int Convolution2D_3x3_iui8_of(NNNET_LAYER *np, void *inp, void *outp)
{
	float filter3x3[3][3];

	LY_Convolution2D *cnvp;
	cnvp = np->p_param;

	unsigned int *ip = (unsigned int *)inp;
	float *op = outp;
	float *wp = cnvp->nnn_wp;
	float *bp = cnvp->nnn_bp;


	int fill_num = cnvp->nb_filter;
	assert(cnvp->nb_row==3);
	assert(cnvp->nb_col==3);


	int input_size_x = cnvp->batch_input_shape[0];
	int input_size_y = cnvp->batch_input_shape[1];
	int input_size_num = cnvp->batch_input_shape[2];

	int f, x, y;
	int idx;
	float w_data;

	printf("in Convolution2D_3x3_iui8_of\n");

	for(f=0;f<fill_num;f++) {
		// get filter
		for(x=0;x<3;x++) {
			for(y=0;y<3;y++) {
				idx = f * 3 * 3 + y * 3 + x;
				w_data = *(wp+idx);
				filter3x3[y][x] = w_data;
			}
		}






	}





    return NNN_RET_ERR;

}
