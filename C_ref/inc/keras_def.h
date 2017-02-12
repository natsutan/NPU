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
} KR_ACTIVATION;

typedef enum {
  BD_VALID,
  BD_SAME
} KR_BOADER_MODE;


//
// 未使用　init, activity_regularizer, W_constraint, W_regularizer dim_ordering, b_constraint, trainable, b_regularizer

typedef struct LY_Convolution2D_tag {
  int nb_filter;
  int nb_row;
  int nb_col;
  KR_ACTIVATION activation;
  int batch_input_shape[4];
  KR_BOADER_MODE border_mode;
  bool bias;
  NN_DTYPE input_dtype;
  int subsample[2];
} LY_Convolution2D;



