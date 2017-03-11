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

   //loop counter
	int k, l, m, n;

	int k_max = flp->nnn_input_shape[3]; //1
	int l_max = flp->nnn_input_shape[2]; //12
	int m_max = flp->nnn_input_shape[1]; //12
	int n_max = flp->nnn_input_shape[0]; //40
	assert(k_max!=0);
	assert(l_max!=0);
	assert(m_max!=0);
	assert(n_max!=0);


	float *ip = (float *)inp;
	float *op = outp;
	int idx_i;
	int idx_o;
	float data;

	printf("k = %d, l = %d, m = %d, n = %d\n", k_max, l_max, m_max, n_max);

	//テンソルの並びを逆にする。3次元でないと計算合わないかも
	assert(k_max==1);
	assert(l_max==m_max);


	idx_o = 0;
	for(k=0;k<k_max;k++) {
		for(l=0;l<l_max;l++) {
			for(m=0;m<m_max;m++) {
				for(n=0;n<n_max;n++) {
					idx_i = (k * l_max * m_max * n_max) + (n * m_max * l_max)  + (l * m_max) + m;
					data = *(ip + idx_i);
					*(op + idx_o) = data;
					idx_o++;
				}
			}
		}
	}



	return NNN_RET_ERR;
}


