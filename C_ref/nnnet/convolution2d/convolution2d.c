#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

int Convolution2D_3x3_iui8_of(NNNET_LAYER *np, void *inp, void *outp);

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
	float bias;

	LY_Convolution2D *cnvp;
	cnvp = np->p_param;

	unsigned int *ip = (unsigned int *)inp;
	float *op = outp;
	float *wp = cnvp->nnn_wp;
	float *bp = cnvp->nnn_bp;


	int fill_num = cnvp->nb_filter;
	int input_size_x = cnvp->batch_input_shape[1];
	int input_size_y = cnvp->batch_input_shape[2];
	int input_size_num = cnvp->batch_input_shape[3];

	int f, x, y, n;
	int idx_i,idx_o;
	float w_data;

	float o_data;

	//parameter checko_data
	assert(cnvp->nb_row==3);
	assert(cnvp->nb_col==3);
	assert(cnvp->border_mode==BD_VALID);
	assert(cnvp->activation==LINEAR);

	printf("in Convolution2D_3x3_iui8_of\n");

	for(n=0;n<input_size_num;n++){
		for(f=0;f<fill_num;f++) {
			// get filter
			for(x=0;x<3;x++) {
				for(y=0;y<3;y++) {
					idx_i = f * 3 * 3 + y * 3 + x;
					w_data = *(wp+idx_i);
					filter3x3[y][x] = w_data;
				}
			}
			bias = *(bp+f);

			//apply filter
			for(y=1;y<input_size_y;y++) {
				for(x=1;x<input_size_x;x++) {
					idx_i = n * (input_size_y * input_size_x) + (y - 1) * input_size_y + x;
					o_data  = *(ip + idx_i - 1) * filter3x3[0][0];
					o_data += *(ip + idx_i)     * filter3x3[0][1];
					o_data += *(ip + idx_i + 1) * filter3x3[0][2];

					idx_i = n * (input_size_y * input_size_x) + y * input_size_y + x;
					o_data += *(ip + idx_i - 1) * filter3x3[1][0];
					o_data += *(ip + idx_i)     * filter3x3[1][1];
					o_data += *(ip + idx_i + 1) * filter3x3[1][2];

					idx_i = n * (input_size_y * input_size_x) + (y + 1) * input_size_y + x;
					o_data += *(ip + idx_i - 1) * filter3x3[2][0];
					o_data += *(ip + idx_i)     * filter3x3[2][1];
					o_data += *(ip + idx_i + 1) * filter3x3[2][2];

					//activation linear
					o_data += bias;

					idx_o = f * (input_size_y - 2) * (input_size_x - 2) + (y-1) * (input_size_y - 2) + (x-1);
					*(op + idx_o) = o_data;
				}
			}
		}
	}


    return NNN_RET_ERR;

}
