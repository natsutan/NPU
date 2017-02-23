#include <stdio.h>
#include <string.h>
#include "numpy.h"
#include "assert.h"

//see https://docs.scipy.org/doc/numpy-dev/neps/npy-format.html
const NUMPY_HEADER default_numpy_header = {0,0,0,0,0,{0,0,0,0}};


//x93NUMPY
const unsigned char np_magic[6] = {0x93, 0x4E, 0x55, 0x4D, 0x50, 0x59};

int np_check_header(FILE *fp, NUMPY_HEADER *hp);
void np_print_heaer_info(const NUMPY_HEADER *hp);

int load_from_numpy(void *dp, const char *numpy_fname, int size, NUMPY_HEADER *hp)
{

  FILE *fp;
  int ret;
  int size_from_shape;

  assert(dp!=NULL);
  assert(numpy_fname!=NULL);
  assert(size > 0);
  assert(hp!=NULL);

  fp = fopen(numpy_fname, "rb");
  if(fp==NULL) {
	printf("ERROR:cant'open %s\n", numpy_fname);
	return NNN_ERR_NO_FILE;

  }
  
  ret = np_check_header(fp, hp);
  if(ret != NNN_RET_OK) {
	printf("ERROR:numpy header error %s\n", numpy_fname);
	return ret;
  }

  printf("load from %s\n", numpy_fname);
  np_print_heaer_info(hp);

  //引数のサイズと、numpyヘッダーのサイズを比較
  size_from_shape = hp->shape[0] *  hp->shape[1] *  hp->shape[2] *  hp->shape[3];
  if(size != size_from_shape) {
	printf("ERROR:numpy header error %s\n", numpy_fname);
	return NNN_NP_HEADER_ERR;	
  }

  fread(dp, 4, size, fp);


  fclose(fp);

  return NNN_RET_OK;
}

//---------------------------------------------------------------------
// np_check_header
// 機能：numpyファイルのヘッダーチェックし、fpをデータの先頭までseekする 
//
// 引数：
//   fp numpyファイルへのファイルポインタ。ファイル先頭を指していること
//      (fopen直後の状態であること)
//   hp ヘッダー情報の格納先
//
// 戻り値：
//   ヘッダー情報がおかしいとき、NNN_NP_HEADER_ERRを返す。
//   ヘッダー情報が問題ない場合は, NNN_RET_OKを返す。
int np_check_header(FILE *fp, NUMPY_HEADER *hp)
{
  unsigned char buf[NNN_NP_BUF_SIZE];
  int i;
  int size;
  char *cp;
  const char *delimiter = ",{} ";
  int ch;
  int dim = 0;
  int ret;

  //check magic number
  fread(&buf, 1, 6, fp);
  for(i=0;i<6;i++) {
	if(buf[i]!=np_magic[i]) {
	  return NNN_NP_HEADER_ERR;
	}
  }
  //version
  fread(&buf, 1, 2, fp);
  hp->major_version = buf[0];
  hp->minor_version = buf[1];
  
  //header_size 
  fread(&size, 2, 1, fp);
  hp->header_len = size;
  assert(hp->header_len < NNN_NP_BUF_SIZE-1);

  //info 
  fread(&buf, 1, hp->header_len, fp);
  buf[hp->header_len] = '\0';
  hp->shape[0] = 0;
  hp->shape[1] = 0;
  hp->shape[2] = 0;
  hp->shape[3] = 0;

  cp = strtok((char *)buf, delimiter);
  while(cp!=NULL) {
	ch = *cp;
	if ((ch == ' ') || ch == '{') {
	  cp = strtok(NULL, delimiter);
	  continue;
	} 

	if(strstr(cp, "'descr':")!=NULL) {
	  cp = strtok(NULL, delimiter);
	  if(strstr(cp, "'<f4'")!=NULL) {
		hp->descr = NN_FLOAT32; 
	  } else {
		printf("ERROR unkown descr %s\n", cp);
		return NNN_NP_HEADER_ERR;
	  }
	} else if(strstr(cp, "'fortran_order'")!=NULL) {
	  cp = strtok(NULL, delimiter);
	  //一文字目で判断
	  if(*cp=='F') {
		hp->fortran_order = false;
	  } else {
		printf("ERROR unsupported fortran_order %s\n", cp);
		return NNN_NP_HEADER_ERR;
	  }
	} else if(strstr(cp, "'shape':")!=NULL) {
	  do {
		cp = strtok(NULL, delimiter);
		//要素数が1の時は終了
		if(*cp==')') break;
		//(はスペースでつぶす
		if(*cp=='(') *cp = ' ';
		ret = sscanf(cp, "%d", &size);
		if(ret!=1) {
		  printf("ERROR unsupported shape %s\n", cp);
		  return NNN_NP_HEADER_ERR;
		}

		//hp->shapeがサイズ4の配列だから。
		if(dim>4) {
		  printf("ERROR unsupported shape %s\n", cp);
		  return NNN_NP_HEADER_ERR;
		}
		hp->shape[dim] = size;
		dim++;
	  } while(strstr(cp, ")")==NULL);

	}
	cp = strtok(NULL, delimiter);
  }

  fseek(fp, 8+2+(hp->header_len), 0);

  return NNN_RET_OK;
}


void np_print_heaer_info(const NUMPY_HEADER *hp)
{
  printf("major_version=%d\n", hp->major_version);
  printf("minor_version=%d\n", hp->minor_version);
  printf("HEADER LEN=%d\n", hp->header_len);

  printf("descr=");
  switch(hp->descr) {
  case NN_INT32:
	printf("int32");
	break;
  case  NN_FLOAT32:
	printf("float32");
	break;
  case  NN_QINT8:
	printf("qint8");
	break;
  case NN_DTYPE_NONE:
	printf("none");
	break;
  default:
	printf("\nERROR unkown descr = %d", hp->descr);
  }
  printf("\n");

  if(hp->fortran_order) {
	printf("fortran_order=True\n");
  } else {
	printf("fortran_order=False\n");
  }

  printf("shape = (%d, %d, %d, %d)\n", hp->shape[0], hp->shape[1], hp->shape[2], hp->shape[3]);

}

int save_to_numpy(void *dp, const char *numpy_fname, NUMPY_HEADER hp)
{

  return NNN_RET_OK;
}


