#include <stdio.h>
#include <stdlib.h>

#define DATA_NUM (128)

float data[DATA_NUM];

int main(void)
{
	
	FILE *fp;
	const char *fname = "dense_1_b_z.npy";
	int hsize;
	int i;
	int cnt;
	
	fp = fopen(fname, "rb");
	if(fp == NULL) {
		printf("error can't open %s\n", fname);
		exit(1);
	}
	
	//get header size
	fseek(fp, 8, 0);
	fread(&hsize, 2, 1, fp);
	
	//hedar skip
	printf("hsize = 0x%x(%d)\n", hsize, hsize);
	fseek(fp, 8+2+hsize, 0);
	
	//read data
	cnt = fread(&data, 4, DATA_NUM, fp);
	printf("read cnt = %d\n", cnt);
	
	//print
	for(i=0;i<DATA_NUM;i++) {
		printf("%f\n", data[i]);
	}
	
	
	fclose(fp);
	
	return 0;
}


