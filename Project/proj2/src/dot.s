.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, dot_error1
    blt a3, t0, dot_error2
    blt a4, t0, dot_error2
    
    li t0, 0   #sum
    li t1, 0   #conut


loop_start:
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t2, t2, t3
    add t0, t0, t2

loop_continue:
    addi t1, t1, 1
    li t4, 4
    mul t2, a3, t4
    mul t3, a4, t4
    add a0, a0, t2
    add a1, a1, t3

    blt t1, a2, loop_start

loop_end:
    add a0, t0, x0

    # Epilogue

    
    ret

dot_error1:
    addi a1, x0, 75
    jal exit2

dot_error2:
    addi a1, x0, 76
    jal exit2