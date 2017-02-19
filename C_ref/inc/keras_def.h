#pragma once
#include <stdbool.h>

#include "nnntype.h"

typedef enum  {
  //core
  TP_DENSE,
  TP_ACTIVATION,
  TP_DROPOUT,
  TP_FLATTEN,
  TP_RESHAPE,
  TP_PERMUTE,
  TP_REPEATVECTOR,
  TP_MERGE,
  TP_LAMBDA,
  TP_ACTIVITYREGULARIZATION,
  TP_MASKING,
  TP_HIGHWAY,
  TP_MAXOUTDENSE,
  TP_TIMEDISTRIBUTEDDENSE,
  //convolution
  TP_CONVOLUTION1D,
  TP_CONVOLUTION2D,
  TP_ATROUSCONVOLUTION2D,
  TP_DECONVOLUTION2D,
  TP_CONVOLUTION3D,
  TP_UPSAMPLING1D,
  TP_UPSAMPLING2D,
  TP_UPSAMPLING3D,
  TP_ZEROPADDING1D,
  TP_ZEROPADDING2D,
  TP_ZEROPADDING3D,
  //pooling
  TP_MAXPOOLING1D,
  TP_MAXPOOLING2D,
  TP_MAXPOOLING3D,
  TP_AVERAGEPOOLING1D,
  TP_AVERAGEPOOLING2D,
  TP_AVERAGEPOOLING3D,
  TP_GLOBALMAXPOOLING1D,
  TP_GLOBALAVERAGEPOOLING1D,
  TP_GLOBALMAXPOOLING2D,
  TP_GLOBALAVERAGEPOOLING2D,
    
} KR_LAYER_TYPE;


//活性化関数
typedef enum {
  SOFTMAX,
  SOFTPLUS,
  SOFTSIGN,
  RELU,
  TANH,
  SIGMOID,
  HARD_SIGMOID,
  LINEAR,
  //-------
  NO_ACTIVATION
} KR_ACTIVATION;

typedef enum {
  BD_VALID,
  BD_SAME,
  //-------
  BD_NONE
} KR_BOADER_MODE;


typedef enum {
  RG_L1,
  RG_L2,
  RG_L1L2,
  RG_ACTIVITY_L1,
  RG_ACTIVITY_L2,
  RG_ACTIVITY_L1L2,
  //--------
  RG_NONE
} KR_REGULARIZER;


// 未使用　init, , W_constraint,  dim_ordering, b_constraint, trainable,
typedef struct LY_Convolution2D_tag {
  int nb_filter;
  int nb_row;
  int nb_col;
  KR_ACTIVATION activation;
  int batch_input_shape[4];
  KR_BOADER_MODE border_mode;
  KR_REGULARIZER activity_regularizer;
  KR_REGULARIZER W_regularizer;
  KR_REGULARIZER b_regularizer;
  bool bias;
  NN_DTYPE input_dtype;
  int subsample[2];
} LY_Convolution2D;


typedef struct LY_Activation_tag {
  KR_ACTIVATION activation;
} LY_Activation;


typedef struct LY_Dropout_tag {
  float p;
} LY_Dropout;


typedef struct LY_Flatten_tag {
  /* nothing */
} LY_Flatten;


typedef struct LY_Dense_tag {
  int input_dim;
  int output_dim;
  KR_ACTIVATION activation;
  KR_REGULARIZER W_regularizer;
  KR_REGULARIZER b_regularizer;
  KR_REGULARIZER activity_regularizer;
  bool bias;
} LY_Dense;

typedef struct LY_MaxPooling2D_tag {
  int strides[2];
  int pool_size[2];
  KR_BOADER_MODE border_mode;  
} LY_MaxPooling2D;
