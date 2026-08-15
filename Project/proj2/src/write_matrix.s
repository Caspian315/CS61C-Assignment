.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    mv s0, a1
    mv s1, a2
    mv s2, a3
    sw a2, 20(sp)
    sw a3, 24(sp)
    mv s3, a0

    mv a1, s3
    li a2, 1
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s3, a0

    mv a1, s3
    addi a2, sp, 20
    li a3, 1
    li a4, 4
    jal fwrite
    li t0 ,1
    bne a0, t0, fwrite_error

    mv a1, s3
    addi a2, sp, 24
    li a3, 1
    li a4, 4
    jal fwrite
    li t0 ,1
    bne a0, t0, fwrite_error

    mul s1, s1, s2
    mv a1, s3
    mv a2, s0
    mv a3, s1
    li a4, 4
    jal fwrite
    bne a0, s1, fwrite_error

    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, fclose_error

    # Epilogue
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32

    ret

fopen_error:
    addi a1, x0, 93
    jal exit2

fwrite_error:
    addi a1, x0, 94
    jal exit2

fclose_error:
    addi a1, x0, 95
    jal exit2