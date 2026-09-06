# CS61CPU

This project implements a two-stage pipelined RISC-V CPU in Logisim Evolution.

## Author

- Zhao Chongren

This project was completed individually.

## Pipeline

The processor is divided into two stages:

1. Instruction Fetch (IF)
2. Instruction Decode, Execute, Memory, and Write Back (EX)

Pipeline registers preserve both the fetched instruction and its corresponding
program counter. The execute-stage PC is used for PC-relative instructions and
for calculating the return address of jump instructions.

## Components

### ALU

The 32-bit ALU supports the arithmetic, logical, comparison, shift, and
multiplication operations needed by the implemented instruction set. `ALUSel`
selects the result, while opcode, `funct3`, and `funct7` decoding distinguish
instructions that share an encoding field.

### Register File

The register file contains 32 32-bit registers with two combinational read ports
and one clocked write port. Writes are decoded to exactly one destination
register, and `x0` is permanently held at zero.

### Immediate Generator

The immediate generator reconstructs and extends I-, S-, B-, U-, and J-type
immediates. `ImmSel` chooses the format required by the current execute-stage
instruction.

### Branch Comparator

The branch comparator produces equality and less-than results for two register
operands. `BrUn` selects signed or unsigned comparison. The control logic uses
these outputs to implement `beq`, `bne`, `blt`, `bge`, `bltu`, and `bgeu`.

### Control Logic and Datapath

The control logic generates `PCSel`, `ImmSel`, `RegWEn`, `BrUn`, `BSel`,
`ASel`, `MemRW`, `WBSel`, `ALUSel`, `CSRSel`, and `CSRWen`. The main datapath
uses these signals to select ALU operands, calculate branch and jump targets,
access data memory, and choose register-file write-back data.

For taken branches and all jumps, `PCSel` redirects the program counter to the
ALU result. A bubble is inserted into the instruction stream so that the
wrong-path instruction already fetched by the IF stage cannot modify processor
state.

### Jumps

`jal` computes its target from the execute-stage PC and a J-type immediate.
`jalr` computes its target from `ReadData1` and an I-type immediate. Both write
`PC_X + 4` as the return address; writes to `x0` are discarded by the register
file.

### Memory

The ALU computes effective addresses from a base register and an immediate.
The currently verified word operations are `lw` and `sw`. Load data is selected
by the write-back multiplexer, while stores drive the external memory address,
write data, and byte write-enable outputs.

### CSR

The processor implements the `tohost` CSR at address `0x51E`. `csrw` writes a
register value, while `csrwi` writes a zero-extended 5-bit immediate encoded in
the instruction's `rs1` field. The CSR register changes only when its address
matches `0x51E` and its write enable is asserted.

## Verification

The following provided test groups pass:

- ALU: 7/7
- Register file: 4/4
- Pipelined `addi`: 1/1
- Part B pipelined sanity tests: 8/8

The passing Part B sanity tests cover arithmetic and U-type instructions,
pipelined `addi`, word memory operations, branches, jumps, combined branch/jump
control flow, and both required CSR writes.

## Known Limitations

This checkpoint passes all provided sanity tests, but it is not a complete
hidden-test submission. The following work remains outside this checkpoint:

- `lb` and `lh`
- `sb` and `sh`
- custom unit, integration, and edge-case tests
