//----------------------------------------------------------------------------------------------------
// This file is automatically generated.
// 2017/02/22 00:00:00
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
float w_convolution2d_1_W[32][3][3];
float w_convolution2d_1_B[32];
float w_convolution2d_2_W[32][3][3];
float w_convolution2d_2_B[32];
float w_dense_1_W[4608];
float w_dense_1_B[4608];
float w_dense_2_W[128];
float w_dense_2_B[128];

// output
float convolution2d_1_output[26][26][32];
float activation_1_output[26][26][32];
float convolution2d_2_output[24][24][32];
float activation_2_output[24][24][32];
float maxpooling2d_1_output[12][12][32];
float dropout_1_output[12][12][32];
float flatten_1_output[4608];
float dense_1_output[128];
float activation_3_output[128];
float dropout_2_output[128];
float dense_2_output[46];
float activation_4_output[46];

NNNET* nnn_init(void)
{
	g_nnn.layernum = 12;

	strcpy(g_nnn.layer[0].name, "convolution2d_1");
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
	g_nnn.layer[0].p_param = &convolution2d_1;
	g_nnn.layer[0].p_data = &convolution2d_1_output;

	strcpy(g_nnn.layer[1].name, "activation_1");
	activation_1.activation = RELU;
	g_nnn.layer[1].p_param = &activation_1;
	g_nnn.layer[1].p_data = &activation_1_output;

	strcpy(g_nnn.layer[2].name, "convolution2d_2");
	convolution2d_2.nb_filter = 32;
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
	g_nnn.layer[2].p_param = &convolution2d_2;
	g_nnn.layer[2].p_data = &convolution2d_2_output;

	strcpy(g_nnn.layer[3].name, "activation_2");
	activation_2.activation = RELU;
	g_nnn.layer[3].p_param = &activation_2;
	g_nnn.layer[3].p_data = &activation_2_output;

	strcpy(g_nnn.layer[4].name, "maxpooling2d_1");
	maxpooling2d_1.strides[0] = 2;
	maxpooling2d_1.strides[1] = 2;
	maxpooling2d_1.pool_size[0] = 2;
	maxpooling2d_1.pool_size[1] = 2;
	maxpooling2d_1.border_mode = BD_VALID;
	g_nnn.layer[4].p_param = &maxpooling2d_1;
	g_nnn.layer[4].p_data = &maxpooling2d_1_output;

	strcpy(g_nnn.layer[5].name, "dropout_1");
	dropout_1.p = 0.25;
	g_nnn.layer[5].p_param = &dropout_1;
	g_nnn.layer[5].p_data = &dropout_1_output;

	strcpy(g_nnn.layer[6].name, "flatten_1");
	g_nnn.layer[6].p_param = &flatten_1;
	g_nnn.layer[6].p_data = &flatten_1_output;

	strcpy(g_nnn.layer[7].name, "dense_1");
	dense_1.input_dim = 4608;
	dense_1.output_dim = 128;
	dense_1.activation = LINEAR;
	dense_1.b_regularizer = RG_NONE;
	dense_1.W_regularizer = RG_NONE;
	dense_1.activity_regularizer = RG_NONE;
	dense_1.bias = true;
	g_nnn.layer[7].p_param = &dense_1;
	g_nnn.layer[7].p_data = &dense_1_output;

	strcpy(g_nnn.layer[8].name, "activation_3");
	activation_3.activation = RELU;
	g_nnn.layer[8].p_param = &activation_3;
	g_nnn.layer[8].p_data = &activation_3_output;

	strcpy(g_nnn.layer[9].name, "dropout_2");
	dropout_2.p = 0.5;
	g_nnn.layer[9].p_param = &dropout_2;
	g_nnn.layer[9].p_data = &dropout_2_output;

	strcpy(g_nnn.layer[10].name, "dense_2");
	dense_2.input_dim = 128;
	dense_2.output_dim = 46;
	dense_2.activation = LINEAR;
	dense_2.b_regularizer = RG_NONE;
	dense_2.W_regularizer = RG_NONE;
	dense_2.activity_regularizer = RG_NONE;
	dense_2.bias = true;
	g_nnn.layer[10].p_param = &dense_2;
	g_nnn.layer[10].p_data = &dense_2_output;

	strcpy(g_nnn.layer[11].name, "activation_4");
	activation_4.activation = SOFTMAX;
	g_nnn.layer[11].p_param = &activation_4;
	g_nnn.layer[11].p_data = &activation_4_output;

	return &g_nnn;
}
