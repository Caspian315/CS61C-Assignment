/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{	
	if(image == NULL){
		exit(-1);
	}

	Color* clr = malloc(sizeof(Color));
	if(clr == NULL)exit(-1);
	if(image->image==NULL || row < 0 || row >= image->rows || col < 0 || col >= image->cols){
		free(clr);
		exit(-1);
	}
	int idx = row*image->cols + col;
	if(idx >= image->cols*image->rows){
		free(clr);
		exit(-1);
	}

	if(image->image[idx]->B&1){
		clr->R = 255;
		clr->G = 255;
		clr->B = 255;
	}else{
		clr->R = 0;
		clr->G = 0;
		clr->B = 0;
	}

	return clr;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	if(image == NULL)exit(-1);
	Image* newImage = malloc(sizeof(Image));
	if(newImage == NULL)exit(-1);	
	int cols,rows;
	cols = image->cols;
	rows = image->rows;
	newImage->cols = cols;
	newImage->rows = rows;
	newImage->image = malloc(cols*rows*sizeof(Color*));
	if(newImage->image == NULL){
		free(newImage);
		exit(-1);
	}	

	for(int idx = 0;idx < cols*rows;++idx){
		int row = idx / cols;
		int col = idx % cols;
		newImage->image[idx] = evaluateOnePixel(image,row,col);
		if(newImage->image[idx] == NULL){
			for(int i = 0;i < idx; ++i){
				free(newImage->image[i]);
			}
			free(newImage->image);
			free(newImage);
			exit(-1);
		}
	}	
	return newImage;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if(argc != 2){
		exit(-1);
	}
	char* filename = argv[1];
	Image* image = readData(filename);
	Image* newImage = steganography(image);
	writeData(newImage);
	freeImage(image);
	freeImage(newImage);
	return 0;
}
