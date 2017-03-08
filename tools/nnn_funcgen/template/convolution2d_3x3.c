
int $func_name (NNNET_LAYER *np, void *inp, void *outp)
{
	$weight_type filter3x3[3][3];
	$input_type data3x3[3][3];
	$weight_type bias;

	LY_Convolution2D *cnvp;
	cnvp = np->p_param;

	$input_type *ip = ($input_type *)inp;
	$output_type *op = outp;
	$weight_type *wp = cnvp->nnn_wp;
	$weight_type *bp = cnvp->nnn_bp;

	int fill_num = cnvp->nb_filter;
	int input_size_x;
	int input_size_y;
	int input_size_num;

	int f, x, y, n;
	int idx_i,idx_o;
	$weight_type w_data;
	$output_type o_data;

    if (cnvp->nnn_input_shape[0] == 0) {
        //入力層はbatch_input_shapeの値を使う
	    input_size_x = cnvp->batch_input_shape[1];
	    input_size_y = cnvp->batch_input_shape[2];
	    input_size_num = cnvp->batch_input_shape[3];
    } else {
        //ここは怪しい
	    input_size_x = cnvp->nnn_input_shape[1];  //画像サイズ
	    input_size_y = cnvp->nnn_input_shape[2];  //画像サイズ
	    input_size_num = cnvp->nnn_input_shape[0]; //入力の数
    }

	//parameter check o_data
	assert(cnvp->nb_row==3);
	assert(cnvp->nb_col==3);
	assert(cnvp->border_mode==BD_VALID);
	assert(cnvp->activation==LINEAR);

	for(n=0;n<input_size_num;n++){
		for(f=0;f<fill_num;f++) {
			// get filter
			for(x=0;x<3;x++) {
				for(y=0;y<3;y++) {
					idx_i = f * 3 * 3 + y * 3 + x;
					w_data = *(wp+idx_i);
					filter3x3[x][y] = w_data;
				}
			}
			bias = *(bp+f);

			//apply filter
			for(y=1;y<input_size_y;y++) {
				for(x=1;x<input_size_x;x++) {
					//get data
					idx_i = n * (input_size_y * input_size_x) + (y - 1) * input_size_y + x;
					data3x3[0][0] = *(ip + idx_i - 1);
					data3x3[0][1] = *(ip + idx_i);
					data3x3[0][2] = *(ip + idx_i + 1);

					idx_i = n * (input_size_y * input_size_x) + y * input_size_y + x;
					data3x3[1][0] = *(ip + idx_i - 1);
					data3x3[1][1] = *(ip + idx_i);
					data3x3[1][2] = *(ip + idx_i + 1);

					idx_i = n * (input_size_y * input_size_x) + (y + 1) * input_size_y + x;
					data3x3[2][0] = *(ip + idx_i - 1);
					data3x3[2][1] = *(ip + idx_i);
					data3x3[2][2] = *(ip + idx_i + 1);


					o_data  = filter3x3[0][0] * data3x3[0][0];
					o_data += filter3x3[0][1] * data3x3[0][1];
					o_data += filter3x3[0][2] * data3x3[0][2];
					o_data += filter3x3[1][0] * data3x3[1][0];
					o_data += filter3x3[1][1] * data3x3[1][1];
					o_data += filter3x3[1][2] * data3x3[1][2];
					o_data += filter3x3[2][0] * data3x3[2][0];
					o_data += filter3x3[2][1] * data3x3[2][1];
					o_data += filter3x3[2][2] * data3x3[2][2];

					//activation linear
					o_data += bias;

					idx_o = f * (input_size_y - 2) * (input_size_x - 2) + (y-1) * (input_size_y - 2) + (x-1);
					*(op + idx_o) = o_data;
				}
			}
		}
	}
    return NNN_RET_OK;
}
