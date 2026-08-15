.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    li t0, 1
    blt a1, t0, argmax_error
    li t0, 0
    lw t1, 0(a0)
    li t3, 0

loop_start:
    lw t2, 0(a0)
    blt t2, t1, loop_continue
    beq t2, t1, loop_continue

    add t1, t2, x0
    add t0, t3, x0

loop_continue:
    addi t3, t3, 1
    addi a0, a0, 4
    blt t3, a1, loop_start

loop_end:
    add a0, t0, x0

    # Epilogue
    ret

argmax_error:
    addi a1, x0, 77
    jal exit2
