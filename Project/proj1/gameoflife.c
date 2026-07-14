/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
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

	int cnt1 = 0,cnt2 = 0,cnt3 = 0;
	int cols = image->cols;
	int rows = image->rows;
	for(int delta1 = -1;delta1 <= 1; ++delta1){
		for(int delta2 = -1;delta2 <= 1; ++delta2){
			if(delta1 == 0 && delta2 == 0)continue;;
			int i = (row + delta1 + rows) % rows;
			int j = (col + delta2 + cols) % cols;
			int idx = i*cols + j;
			if(image->image[idx]->B&1){
				cnt1++;
			}
		}
	}
	if(image->image[row*cols+col]->B&1){
		clr->B = ((rule>>(9 + cnt1))&1) ? 255 : 0;
	}else{	
		clr->B = ((rule>>(cnt1))&1) ? 255 : 0;
	}

	for(int delta1 = -1;delta1 <= 1; ++delta1){
		for(int delta2 = -1;delta2 <= 1; ++delta2){
			if(delta1 == 0 && delta2 == 0)continue;;
			int i = (row + delta1 + rows) % rows;
			int j = (col + delta2 + cols) % cols;
			int idx = i*cols + j;
			if(image->image[idx]->G&1){
				cnt2++;
			}
		}
	}
	if(image->image[row*cols+col]->G&1){
		clr->G = ((rule>>(9 + cnt2))&1) ? 255 : 0;
	}else{	
		clr->G = ((rule>>(cnt2))&1) ? 255 : 0;
	}
	
	for(int delta1 = -1;delta1 <= 1; ++delta1){
		for(int delta2 = -1;delta2 <= 1; ++delta2){
			if(delta1 == 0 && delta2 == 0)continue;;
			int i = (row + delta1 + rows) % rows;
			int j = (col + delta2 + cols) % cols;
			int idx = i*cols + j;
			if(image->image[idx]->R&1){
				cnt3++;
			}
		}
	}

	if(image->image[row*cols+col]->R&1){
		clr->R = ((rule>>(9 + cnt3))&1) ? 255 : 0;
	}else{	
		clr->R = ((rule>>(cnt3))&1) ? 255 : 0;
	}

	
	return clr;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
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
		newImage->image[idx] = evaluateOneCell(image,row,col,rule);
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
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if(argc != 3){
		exit(-1);
	}
	uint32_t rule = strtol(argv[2],NULL,0);
	Image* image = readData(argv[1]);
	Image* newImage = life(image,rule);
	writeData(newImage);
	freeImage(image);
	freeImage(newImage);

	return 0;
}
