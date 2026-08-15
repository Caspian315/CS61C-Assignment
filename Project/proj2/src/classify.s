.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminates the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, classify_argc_error

    # Stack frame:
    #   0-32: saved ra and s0-s7
    #   36-40: m0 rows/cols
    #   44-48: m1 rows/cols
    #   52-56: input rows/cols
    addi sp, sp, -64
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    mv s0, a1                  # argv
    mv s1, a2                  # print flag

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0.
    lw a0, 4(s0)
    addi a1, sp, 36
    addi a2, sp, 40
    jal read_matrix
    mv s2, a0

    # Load pretrained m1.
    lw a0, 8(s0)
    addi a1, sp, 44
    addi a2, sp, 48
    jal read_matrix
    mv s3, a0

    # Load input matrix.
    lw a0, 12(s0)
    addi a1, sp, 52
    addi a2, sp, 56
    jal read_matrix
    mv s4, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    h = m0 * input
    # 2. NONLINEAR LAYER: h = ReLU(h)
    # 3. LINEAR LAYER:    o = m1 * h

    # Allocate h: m0_rows * input_cols integers.
    lw t0, 36(sp)
    lw t1, 56(sp)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, x0, classify_malloc_error
    mv s5, a0

    # h = matmul(m0, input)
    mv a0, s2
    lw a1, 36(sp)
    lw a2, 40(sp)
    mv a3, s4
    lw a4, 52(sp)
    lw a5, 56(sp)
    mv a6, s5
    jal matmul

    # ReLU(h)
    mv a0, s5
    lw t0, 36(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal relu

    # Allocate o: m1_rows * input_cols integers.
    lw t0, 44(sp)
    lw t1, 56(sp)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0, x0, classify_malloc_error
    mv s6, a0

    # o = matmul(m1, h)
    mv a0, s3
    lw a1, 44(sp)
    lw a2, 48(sp)
    mv a3, s5
    lw a4, 36(sp)
    lw a5, 56(sp)
    mv a6, s6
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    lw a0, 16(s0)
    mv a1, s6
    lw a2, 44(sp)
    lw a3, 56(sp)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    mv a0, s6
    lw t0, 44(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal argmax
    mv s7, a0

    # Print the classification and a newline only when requested.
    bne s1, x0, classify_skip_print
    mv a1, s7
    jal print_int
    li a1, '\n'
    jal print_char

classify_skip_print:
    # Release every matrix allocated by read_matrix or classify.
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free

    mv a0, s7

    # Epilogue
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 64
    ret

classify_argc_error:
    li a1, 89
    jal exit2

classify_malloc_error:
    li a1, 88
    jal exit2
