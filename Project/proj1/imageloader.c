/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{	FILE *fp = fopen(filename,"r");
	if(fp == NULL) {
		exit(-1);
	}
	Image* img = malloc(sizeof(Image));
	if(img == NULL){
		fclose(fp);
		exit(-1);
	}

	char type[3];
	fscanf(fp,"%2s",type);
	int cols,rows;
	fscanf(fp,"%d %d",&cols,&rows);
	int maxSize;
	fscanf(fp,"%d",&maxSize);

	img->cols = cols;
	img->image = malloc(cols*rows*sizeof(Color*));
	if(img->image == NULL){
		free(img);
		fclose(fp);
		exit(-1);
	}

	for(int i = 0;i < rows; ++i){
		for(int j = 0;j < cols; ++j){
			int idx = i*cols + j;
			img->image[idx] = malloc(sizeof(Color));
			int r,g,b;
			fscanf(fp,"%d %d %d",&r,&g,&b);
			img->image[idx]->R = r; 
			img->image[idx]->G = g;
			img->image[idx]->B = b;
		}	
	}
	fclose(fp);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	printf("P3\n");
	printf("%d %d\n",(int)image->cols,(int)image->rows);
	printf("255\n");

	for(int idx = 0;idx < image->cols*image->rows; ++idx){
		int row = idx/image->cols;
		int col = idx%image->cols;
		
		uint8_t r,g,b;
		r = image->image[idx]->R;
		g = image->image[idx]->G;
		b = image->image[idx]->B;

		printf("%3d %3d %3d",(int)r,(int)g,(int)b);
		if(col == image->cols - 1){
			printf("\n");
		}else{
			printf("   ");
		}
	}
}

//Frees an image
void freeImage(Image *image)
{
	for(int idx = 0;idx < image->cols*image->rows; ++idx){
		free(image->image[idx]);
	}
	free(image->image);
	free(image);
}