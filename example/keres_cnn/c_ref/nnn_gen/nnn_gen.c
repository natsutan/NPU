//----------------------------------------------------------------------------------------------------
// This file is automatically generated.
// 2017/03/07 00:00:00
//----------------------------------------------------------------------------------------------------
#include "nnn_gen.h"
// network
NNNET g_nnn;

// layers
LY_Convolution2D convolution2d_1;
LY_Activation activation_1;
LY_Convolution2D convolution2d_2;
LY_Activation activation_2;
LY_MaxPooling2D maxpooling2d_1;
LY_Dropout dropout_1;
LY_Flatten flatten_1;
LY_Dense dense_1;
LY_Activation activation_3;
LY_Dropout dropout_2;
LY_Dense dense_2;
LY_Activation activation_4;

// weights
NUMPY_HEADER nph_convolution2d_1_W;
NUMPY_HEADER nph_convolution2d_1_b;
float w_convolution2d_1_W[32][3][3];
float w_convolution2d_1_b[32];
NUMPY_HEADER nph_convolution2d_2_W;
NUMPY_HEADER nph_convolution2d_2_b;
float w_convolution2d_2_W[40][40][3][3];
float w_convolution2d_2_b[40];
NUMPY_HEADER nph_dense_1_W;
NUMPY_HEADER nph_dense_1_b;
float w_dense_1_W[128][5760];
float w_dense_1_b[5760];
NUMPY_HEADER nph_dense_2_W;
NUMPY_HEADER nph_dense_2_b;
float w_dense_2_W[46][128];
float w_dense_2_b[128];

// output
float convolution2d_1_output[32][26][26];
float activation_1_output[32][26][26];
float convolution2d_2_output[40][24][24];
float activation_2_output[40][24][24];
float maxpooling2d_1_output[40][12][12];
float dropout_1_output[40][12][12];
float flatten_1_output[5760];
float dense_1_output[128];
float activation_3_output[128];
float dropout_2_output[128];
float dense_2_output[46];
float activation_4_output[46];

NNNET* nnn_init(void)
{
	g_nnn.layernum = 12;

	strcpy(g_nnn.layer[0].name, "convolution2d_1");
	g_nnn.layer[0].prev_dim = 1;
	g_nnn.layer[0].type = TP_CONVOLUTION2D;
	convolution2d_1.nb_filter = 32;
	convolution2d_1.nb_row = 3;
	convolution2d_1.nb_col = 3;
	convolution2d_1.activation = LINEAR;
	convolution2d_1.batch_input_shape[0] = 0;
	convolution2d_1.batch_input_shape[1] = 28;
	convolution2d_1.batch_input_shape[2] = 28;
	convolution2d_1.batch_input_shape[3] = 1;
	convolution2d_1.border_mode = BD_VALID;
	convolution2d_1.b_regularizer = RG_NONE;
	convolution2d_1.W_regularizer = RG_NONE;
	convolution2d_1.activity_regularizer = RG_NONE;
	convolution2d_1.bias = true;
	convolution2d_1.input_dtype = NN_FLOAT32;
	convolution2d_1.subsample[0] = 1;
	convolution2d_1.subsample[1] = 1;
	convolution2d_1.nnn_wp=w_convolution2d_1_W;
	convolution2d_1.nnn_bp=w_convolution2d_1_b;
	convolution2d_1.nnn_whp=&nph_convolution2d_1_W;
	convolution2d_1.nnn_bhp=&nph_convolution2d_1_b;
	convolution2d_1.nnn_input_shape[0]=0;
	convolution2d_1.nnn_input_shape[1]=0;
	convolution2d_1.nnn_input_shape[2]=0;
	convolution2d_1.nnn_input_shape[3]=0;
	g_nnn.layer[0].input_dtype = NN_UINT8;
	g_nnn.layer[0].wight_dtype = NN_FLOAT32;
	g_nnn.layer[0].output_dtype = NN_FLOAT32;
	g_nnn.layer[0].p_param = &convolution2d_1;
	g_nnn.layer[0].p_data = &convolution2d_1_output;

	strcpy(g_nnn.layer[1].name, "activation_1");
	g_nnn.layer[1].prev_dim = 32;
	g_nnn.layer[1].type = TP_ACTIVATION;
	activation_1.activation = RELU;
	activation_1.nnn_input_shape[0]=32;
	activation_1.nnn_input_shape[1]=26;
	activation_1.nnn_input_shape[2]=26;
	activation_1.nnn_input_shape[3]=1;
	g_nnn.layer[1].input_dtype = NN_FLOAT32;
	g_nnn.layer[1].wight_dtype = NN_FLOAT32;
	g_nnn.layer[1].output_dtype = NN_FLOAT32;
	g_nnn.layer[1].p_param = &activation_1;
	g_nnn.layer[1].p_data = &activation_1_output;

	strcpy(g_nnn.layer[2].name, "convolution2d_2");
	g_nnn.layer[2].prev_dim = 40;
	g_nnn.layer[2].type = TP_CONVOLUTION2D;
	convolution2d_2.nb_filter = 40;
	convolution2d_2.nb_row = 3;
	convolution2d_2.nb_col = 3;
	convolution2d_2.activation = LINEAR;
	convolution2d_2.batch_input_shape[0] = 0;
	convolution2d_2.border_mode = BD_VALID;
	convolution2d_2.b_regularizer = RG_NONE;
	convolution2d_2.W_regularizer = RG_NONE;
	convolution2d_2.activity_regularizer = RG_NONE;
	convolution2d_2.bias = true;
	convolution2d_2.input_dtype = NN_DTYPE_NONE;
	convolution2d_2.subsample[0] = 1;
	convolution2d_2.subsample[1] = 1;
	convolution2d_2.nnn_wp=w_convolution2d_2_W;
	convolution2d_2.nnn_bp=w_convolution2d_2_b;
	convolution2d_2.nnn_whp=&nph_convolution2d_2_W;
	convolution2d_2.nnn_bhp=&nph_convolution2d_2_b;
	convolution2d_2.nnn_input_shape[0]=32;
	convolution2d_2.nnn_input_shape[1]=26;
	convolution2d_2.nnn_input_shape[2]=26;
	convolution2d_2.nnn_input_shape[3]=1;
	g_nnn.layer[2].input_dtype = NN_FLOAT32;
	g_nnn.layer[2].wight_dtype = NN_FLOAT32;
	g_nnn.layer[2].output_dtype = NN_FLOAT32;
	g_nnn.layer[2].p_param = &convolution2d_2;
	g_nnn.layer[2].p_data = &convolution2d_2_output;

	strcpy(g_nnn.layer[3].name, "activation_2");
	g_nnn.layer[3].prev_dim = 40;
	g_nnn.layer[3].type = TP_ACTIVATION;
	activation_2.activation = RELU;
	activation_2.nnn_input_shape[0]=40;
	activation_2.nnn_input_shape[1]=24;
	activation_2.nnn_input_shape[2]=24;
	activation_2.nnn_input_shape[3]=1;
	g_nnn.layer[3].input_dtype = NN_FLOAT32;
	g_nnn.layer[3].wight_dtype = NN_FLOAT32;
	g_nnn.layer[3].output_dtype = NN_FLOAT32;
	g_nnn.layer[3].p_param = &activation_2;
	g_nnn.layer[3].p_data = &activation_2_output;

	strcpy(g_nnn.layer[4].name, "maxpooling2d_1");
	g_nnn.layer[4].prev_dim = 40;
	g_nnn.layer[4].type = TP_MAXPOOLING2D;
	maxpooling2d_1.strides[0] = 2;
	maxpooling2d_1.strides[1] = 2;
	maxpooling2d_1.pool_size[0] = 2;
	maxpooling2d_1.pool_size[1] = 2;
	maxpooling2d_1.border_mode = BD_VALID;
	g_nnn.layer[4].input_dtype = NN_FLOAT32;
	g_nnn.layer[4].wight_dtype = NN_FLOAT32;
	g_nnn.layer[4].output_dtype = NN_FLOAT32;
	g_nnn.layer[4].p_param = &maxpooling2d_1;
	g_nnn.layer[4].p_data = &maxpooling2d_1_output;

	strcpy(g_nnn.layer[5].name, "dropout_1");
	g_nnn.layer[5].prev_dim = 40;
	g_nnn.layer[5].type = TP_DROPOUT;
	dropout_1.p = 0.25;
	g_nnn.layer[5].input_dtype = NN_FLOAT32;
	g_nnn.layer[5].wight_dtype = NN_FLOAT32;
	g_nnn.layer[5].output_dtype = NN_FLOAT32;
	g_nnn.layer[5].p_param = &dropout_1;
	g_nnn.layer[5].p_data = &dropout_1_output;

	strcpy(g_nnn.layer[6].name, "flatten_1");
	g_nnn.layer[6].prev_dim = 5760;
	g_nnn.layer[6].type = TP_FLATTEN;
	g_nnn.layer[6].input_dtype = NN_FLOAT32;
	g_nnn.layer[6].wight_dtype = NN_FLOAT32;
	g_nnn.layer[6].output_dtype = NN_FLOAT32;
	g_nnn.layer[6].p_param = &flatten_1;
	g_nnn.layer[6].p_data = &flatten_1_output;

	strcpy(g_nnn.layer[7].name, "dense_1");
	g_nnn.layer[7].prev_dim = 128;
	g_nnn.layer[7].type = TP_DENSE;
	dense_1.input_dim = 5760;
	dense_1.output_dim = 128;
	dense_1.activation = LINEAR;
	dense_1.b_regularizer = RG_NONE;
	dense_1.W_regularizer = RG_NONE;
	dense_1.activity_regularizer = RG_NONE;
	dense_1.bias = true;
	g_nnn.layer[7].input_dtype = NN_FLOAT32;
	g_nnn.layer[7].wight_dtype = NN_FLOAT32;
	g_nnn.layer[7].output_dtype = NN_FLOAT32;
	g_nnn.layer[7].p_param = &dense_1;
	g_nnn.layer[7].p_data = &dense_1_output;

	strcpy(g_nnn.layer[8].name, "activation_3");
	g_nnn.layer[8].prev_dim = 128;
	g_nnn.layer[8].type = TP_ACTIVATION;
	activation_3.activation = RELU;
	activation_3.nnn_input_shape[0]=128;
	activation_3.nnn_input_shape[1]=1;
	activation_3.nnn_input_shape[2]=0;
	activation_3.nnn_input_shape[3]=0;
	g_nnn.layer[8].input_dtype = NN_FLOAT32;
	g_nnn.layer[8].wight_dtype = NN_FLOAT32;
	g_nnn.layer[8].output_dtype = NN_FLOAT32;
	g_nnn.layer[8].p_param = &activation_3;
	g_nnn.layer[8].p_data = &activation_3_output;

	strcpy(g_nnn.layer[9].name, "dropout_2");
	g_nnn.layer[9].prev_dim = 128;
	g_nnn.layer[9].type = TP_DROPOUT;
	dropout_2.p = 0.5;
	g_nnn.layer[9].input_dtype = NN_FLOAT32;
	g_nnn.layer[9].wight_dtype = NN_FLOAT32;
	g_nnn.layer[9].output_dtype = NN_FLOAT32;
	g_nnn.layer[9].p_param = &dropout_2;
	g_nnn.layer[9].p_data = &dropout_2_output;

	strcpy(g_nnn.layer[10].name, "dense_2");
	g_nnn.layer[10].prev_dim = 46;
	g_nnn.layer[10].type = TP_DENSE;
	dense_2.input_dim = 128;
	dense_2.output_dim = 46;
	dense_2.activation = LINEAR;
	dense_2.b_regularizer = RG_NONE;
	dense_2.W_regularizer = RG_NONE;
	dense_2.activity_regularizer = RG_NONE;
	dense_2.bias = true;
	g_nnn.layer[10].input_dtype = NN_FLOAT32;
	g_nnn.layer[10].wight_dtype = NN_FLOAT32;
	g_nnn.layer[10].output_dtype = NN_FLOAT32;
	g_nnn.layer[10].p_param = &dense_2;
	g_nnn.layer[10].p_data = &dense_2_output;

	strcpy(g_nnn.layer[11].name, "activation_4");
	g_nnn.layer[11].prev_dim = 46;
	g_nnn.layer[11].type = TP_ACTIVATION;
	activation_4.activation = SOFTMAX;
	activation_4.nnn_input_shape[0]=46;
	activation_4.nnn_input_shape[1]=1;
	activation_4.nnn_input_shape[2]=0;
	activation_4.nnn_input_shape[3]=0;
	g_nnn.layer[11].input_dtype = NN_FLOAT32;
	g_nnn.layer[11].wight_dtype = NN_FLOAT32;
	g_nnn.layer[11].output_dtype = NN_FLOAT32;
	g_nnn.layer[11].p_param = &activation_4;
	g_nnn.layer[11].p_data = &activation_4_output;

	return &g_nnn;
}

int nnn_load_weight_from_files(NNNET* np, const char *path)
{
	char buf[NNN_MAX_PATH];
	int path_len;
	int fname_w_len;
	int fname_b_len;
	int ret;

// convolution2d_1
	path_len = strlen(path);
	fname_w_len = strlen("convolution2d_1_W_z.npy");
	fname_b_len = strlen("convolution2d_1_b_z.npy");
	assert(path_len+fname_w_len<NNN_MAX_PATH);
	assert(path_len+fname_b_len<NNN_MAX_PATH);

	strcpy(buf, path);
	strcat(buf, "convolution2d_1_W_z.npy");
	ret = load_from_numpy(w_convolution2d_1_W, buf, 288, &nph_convolution2d_1_W);
	if(ret != NNN_RET_OK){
		return ret;
	}
	strcpy(buf, path);
	strcat(buf, "convolution2d_1_b_z.npy");
	ret = load_from_numpy(w_convolution2d_1_b, buf, 32, &nph_convolution2d_1_b);
	if(ret != NNN_RET_OK){
		return ret;
	}

// convolution2d_2
	path_len = strlen(path);
	fname_w_len = strlen("convolution2d_2_W_z.npy");
	fname_b_len = strlen("convolution2d_2_b_z.npy");
	assert(path_len+fname_w_len<NNN_MAX_PATH);
	assert(path_len+fname_b_len<NNN_MAX_PATH);

	strcpy(buf, path);
	strcat(buf, "convolution2d_2_W_z.npy");
	ret = load_from_numpy(w_convolution2d_2_W, buf, 14400, &nph_convolution2d_2_W);
	if(ret != NNN_RET_OK){
		return ret;
	}
	strcpy(buf, path);
	strcat(buf, "convolution2d_2_b_z.npy");
	ret = load_from_numpy(w_convolution2d_2_b, buf, 40, &nph_convolution2d_2_b);
	if(ret != NNN_RET_OK){
		return ret;
	}

// dense_1
	path_len = strlen(path);
	fname_w_len = strlen("dense_1_W_z.npy");
	fname_b_len = strlen("dense_1_b_z.npy");
	assert(path_len+fname_w_len<NNN_MAX_PATH);
	assert(path_len+fname_b_len<NNN_MAX_PATH);

	strcpy(buf, path);
	strcat(buf, "dense_1_W_z.npy");
	ret = load_from_numpy(w_dense_1_W, buf, 737280, &nph_dense_1_W);
	if(ret != NNN_RET_OK){
		return ret;
	}
	strcpy(buf, path);
	strcat(buf, "dense_1_b_z.npy");
	ret = load_from_numpy(w_dense_1_b, buf, 128, &nph_dense_1_b);
	if(ret != NNN_RET_OK){
		return ret;
	}

// dense_2
	path_len = strlen(path);
	fname_w_len = strlen("dense_2_W_z.npy");
	fname_b_len = strlen("dense_2_b_z.npy");
	assert(path_len+fname_w_len<NNN_MAX_PATH);
	assert(path_len+fname_b_len<NNN_MAX_PATH);

	strcpy(buf, path);
	strcat(buf, "dense_2_W_z.npy");
	ret = load_from_numpy(w_dense_2_W, buf, 5888, &nph_dense_2_W);
	if(ret != NNN_RET_OK){
		return ret;
	}
	strcpy(buf, path);
	strcat(buf, "dense_2_b_z.npy");
	ret = load_from_numpy(w_dense_2_b, buf, 46, &nph_dense_2_b);
	if(ret != NNN_RET_OK){
		return ret;
	}

	return NNN_RET_OK;
}

int nnn_run(NNNET* np, void *dp)
{
	int ret;

//convolution2d_1
	ret = nnn_Convolution2D(&(g_nnn.layer[0]), dp, convolution2d_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//activation_1
	ret = nnn_Activation(&(g_nnn.layer[1]), convolution2d_1_output, activation_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//convolution2d_2
	ret = nnn_Convolution2D(&(g_nnn.layer[2]), activation_1_output, convolution2d_2_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//activation_2
	ret = nnn_Activation(&(g_nnn.layer[3]), convolution2d_2_output, activation_2_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//maxpooling2d_1
	ret = nnn_MaxPooling2D(&(g_nnn.layer[4]), activation_2_output, maxpooling2d_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//dropout_1
	ret = nnn_Dropout(&(g_nnn.layer[5]), maxpooling2d_1_output, dropout_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//flatten_1
	ret = nnn_Flatten(&(g_nnn.layer[6]), dropout_1_output, flatten_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//dense_1
	ret = nnn_Dense(&(g_nnn.layer[7]), flatten_1_output, dense_1_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//activation_3
	ret = nnn_Activation(&(g_nnn.layer[8]), dense_1_output, activation_3_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//dropout_2
	ret = nnn_Dropout(&(g_nnn.layer[9]), activation_3_output, dropout_2_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//dense_2
	ret = nnn_Dense(&(g_nnn.layer[10]), dropout_2_output, dense_2_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

//activation_4
	ret = nnn_Activation(&(g_nnn.layer[11]), dense_2_output, activation_4_output);
	if(ret != NNN_RET_OK){
		return ret;
	}

	return NNN_RET_OK;
}

