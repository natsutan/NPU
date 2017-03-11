#include <stdio.h>
#include <assert.h>
#include "nnnet.h"

int avtivation_relu (NNNET_LAYER *np, void *inp, void *outp);

int nnn_Activation(NNNET_LAYER *np, void *inp, void *outp)
{

	LY_Activation *actp;

	actp = np->p_param;
	int ret;

	if(actp->activation == RELU) {
		//relu
		ret = avtivation_relu(np, inp, outp);
	} else {
		printf("ERROR no supported parameter %s\n", np->name);
    	return NNN_RET_ERR;
	}


    return ret;
}

int avtivation_relu (NNNET_LAYER *np, void *inp, void *outp)
{
	float data;
	float bias;

	LY_Activation *actp;
	actp = np->p_param;

	float *ip = (float *)inp;
	float *op = outp;

    //loop counter
    int k, l, m, n;

    int k_max = actp->nnn_input_shape[3];
    int l_max = actp->nnn_input_shape[2];
    int m_max = actp->nnn_input_shape[1];
    int n_max = actp->nnn_input_shape[0];

    if(k_max == 0) {
    	k_max = 1;
    }
    if(l_max == 0) {
    	l_max = 1;
    }
    assert(m_max!=0);
    assert(n_max!=0);

    //入力と出力は同じサイズなのでidｘを共有
	int idx;
	float o_data;

    for(k=0;k<k_max;k++) {
        for(l=0;l<l_max;l++) {
            for(m=0;m<m_max;m++) {
                for(n=0;n<n_max;n++) {
                    idx =(k * l_max * m_max * n_max) + (l * m_max * n_max) + (m * n_max) + n;
                    data = *(ip+idx);

                    //relu
                    if(data < 0) {
                        o_data = 0;
                    } else {
                        o_data = data;
                    }

                    *(op + idx) = o_data;
                }
            }
        }
    }

	return NNN_RET_OK;
}
