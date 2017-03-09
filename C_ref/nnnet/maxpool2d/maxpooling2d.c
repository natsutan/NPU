#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

int maxpool2d_2x2(NNNET_LAYER *np, void *inp, void *outp);

int nnn_MaxPooling2D(NNNET_LAYER *np, void *inp, void *outp)
{
    int ret;

    ret = maxpool2d_2x2(np, inp, outp);

    return ret;
}

int maxpool2d_2x2(NNNET_LAYER *np, void *inp, void *outp)
{

    LY_MaxPooling2D *mpp;
    mpp = np->p_param;
    float *ip = inp;
    float *op = outp;


    assert(mpp->pool_size[0]==2);
    assert(mpp->pool_size[1]==2);
    assert(mpp->strides[0]==2);
    assert(mpp->strides[1]==2);
    assert(mpp->border_mode==BD_VALID);

	int input_size_x = mpp->nnn_input_shape[1];
	int input_size_y = mpp->nnn_input_shape[2];
	int input_size_num = mpp->nnn_input_shape[0];

	int x, y, n;
	int idx_i,idx_o;
	float data[4]; //2x2
	float o_data;
	float max;

	for(n=0;n<input_size_num;n++) {
		for(y=0;y<input_size_y;y+=2) {
			for(x=0;x<input_size_x;x+=2){
				idx_i = (n * input_size_y * input_size_x) + (y * input_size_x) + x;
				idx_o = n * (input_size_y * input_size_x / 4) + (y * input_size_x / 2) + (x/2);

				data[0] = *(ip + idx_i);
				data[1] = *(ip + idx_i + 1);
				data[2] = *(ip + idx_i + input_size_x);
				data[3] = *(ip + idx_i + input_size_x + 11);

				//max
				max = data[0];
				if(max < data[1]) {
					max = data[1];
				}
				if(max < data[2]) {
					max = data[2];
				}
				if(max < data[3]) {
					max = data[3];
				}

				*(op + idx_o) = max;
			}
		}
	}


    return NNN_RET_OK;
}
