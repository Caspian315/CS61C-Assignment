.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the length of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    blt a1, t0, relu_error

    add t0, a0, x0
    add t2, x0, x0

loop_start:
    lw t1, 0(t0)
    bge t1, x0, loop_continue
    li t1, 0
    sw t1, 0(t0)
    
loop_continue:
    addi t2, t2 ,1
    addi t0, t0, 4
    blt t2, a1, loop_start

loop_end:
    # Epilogue
    

	ret

relu_error:
    addi a1, x0, 78
    jal exit2