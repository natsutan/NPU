//-----------------------------
//compile時のdefine上書きで変更可能
#define NNN_MAX_LAYER_NUM   16  //最大レイヤー数
#define NNN_MAX_LAYER_NAME 256  //レイヤー名の最大文字数

//-----------------------------
//戻り値定義
#define NNN_RET_OK (0)      //正常終了
#define NNN_RET_ERR (-1)    //エラー

//----------------------------
//ファイルのR/W用定義
#define NNN_MAX_PATH 256


#include "nnnet_def.h"
#include "numpy.h"
