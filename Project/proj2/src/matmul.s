.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, m1_error
    blt a2, t0, m1_error
    blt a4, t0, m2_error
    blt a5, t0, m2_error
    bne a2, a4, unmatch_error
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a5
    mv s5, a6
    li s6, 0


outer_loop_start:
    li t0, 0
    beq s1, t0, outer_loop_end
    li s6, 0

inner_loop_start:
    bge s6, s4, inner_loop_end
    slli t0, s6, 2
    add t1, s3, t0
    add a0, s0, x0
    add a1, t1, x0
    add a2, s2, x0
    li a3, 1
    add a4, s4, x0
    jal dot
    sw a0, 0(s5)
    addi s5, s5, 4
    addi s6, s6, 1
    j inner_loop_start


inner_loop_end:
    slli t2, s2, 2
    add s0, s0, t2
    addi s1, s1, -1
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32

    ret

m1_error:
    addi a1, x0, 72 
    jal exit2

m2_error:
    addi a1, x0, 73
    jal exit2

unmatch_error:
    addi a1, x0, 74
    jal exit2