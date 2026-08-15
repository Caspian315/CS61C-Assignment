.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp) #row pointer 
    sw s1, 8(sp) #col pointer
    sw s2, 12(sp) #file descriptor
    sw s3, 16(sp) #address of matrix
    sw s4, 20(sp) #total bytes of matrix data

    mv s0, a1
    mv s1, a2

    mv a1, a0
    li a2, 0

    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s2, a0

    mv a1, s2
    mv a2, s0
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    mv a1, s2
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    lw t0, 0(s0)
    lw t1, 0(s1)
    mul t0, t0, t1
    li t1, 4
    mul t0, t0, t1
    mv s4, t0

    mv a0, s4
    jal malloc
    li t0, 0
    beq a0, t0, malloc_error
    mv s3, a0

    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal fread
    bne a0, s4, fread_error

    mv a1, s2
    jal fclose
    li t0, -1
    beq a0, t0, fclose_error

    mv a0, s3
    # Epilogue
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32
    
    ret

fopen_error:
    addi a1, x0, 90
    jal exit2

fread_error:
    addi a1, x0, 91
    jal exit2

malloc_error: 
    addi a1, x0, 88
    jal exit2

fclose_error:
    addi a1, x0, 92
    jal exit2