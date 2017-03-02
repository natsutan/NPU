#pragma once
//nnnetでネットワークを記述するための型宣言

#include "keras_def.h"

typedef struct nnnet_layer_tag {
  KR_LAYER_TYPE type;
  char name[NNN_MAX_LAYER_NAME];
  int prev_dim;
  void *p_param;  //pointer to parameters
  void *p_data;   //pointer to data, eg:weights
} NNNET_LAYER;


typedef struct nnnet_tag {
  int layernum;
  NNNET_LAYER layer[NNN_MAX_LAYER_NUM];
} NNNET;
