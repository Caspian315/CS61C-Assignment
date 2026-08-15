# fa20-proj2-starter

```
.
├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
```


## Here's what I did in project 2:

### Part A: RISC-V Matrix Operations

Part A implements the core integer-vector and matrix operations used by the
classifier. All functions are written in RISC-V assembly and follow the
project's calling-convention and error-handling requirements.

#### Implemented functions

| File | Functionality | Error handling |
|---|---|---|
| `src/abs.s` | Returns the absolute value of an integer | N/A |
| `src/relu.s` | Applies ReLU to an integer array in place | Exit `78` when length is less than 1 |
| `src/argmax.s` | Returns the first index of the maximum element | Exit `77` when length is less than 1 |
| `src/dot.s` | Computes a dot product with independent vector strides | Exit `75` for invalid length and `76` for invalid stride |
| `src/matmul.s` | Multiplies two row-major integer matrices using `dot` | Exit `72`, `73`, or `74` for invalid dimensions |

#### Implementation notes

- Matrix elements are 32-bit integers stored in row-major order.
- `dot` treats strides as element counts and converts them to byte offsets when advancing pointers.
- `argmax` updates its saved index only for a strictly larger value, so ties return the earliest index.
- `matmul` computes each output element as the dot product of one row from the first matrix and one column from the second matrix.
- `matmul` preserves `ra` and `s0`-`s6` in a 32-byte aligned stack frame before making nested calls to `dot`.
- Dimension and argument checks are performed in the order required by the specification.

#### Testing

Run all Part A tests from the `unittests` directory:

```bash
python3 -m unittest -v \
  unittests.TestAbs \
  unittests.TestRelu \
  unittests.TestArgmax \
  unittests.TestDot \
  unittests.TestMatmul
```

Current results:

| Function | Coverage |
|---|---:|
| `abs.s` | 3/3 |
| `relu.s` | 14/14 |
| `argmax.s` | 17/17 |
| `dot.s` | 23/23 |
| `matmul.s` | 58/58 |

All 19 Part A unit tests pass, including invalid arguments, non-unit strides,
rectangular matrix multiplication, and dimension mismatch cases.

### Part B: File I/O and Neural Network Classification

Part B combines the Part A matrix functions into a complete inference pipeline.
It reads pretrained weights and an input matrix from binary files, runs two
linear layers with ReLU between them, writes the output matrix, and returns the
index of the largest output value as the classification.

#### Implemented functions

| File | Functionality | Error handling |
|---|---|---|
| `src/read_matrix.s` | Reads matrix dimensions and row-major integer data from a binary file, allocating the data buffer on the heap | Exit `88`, `90`, `91`, or `92` for malloc/open/read/close failures |
| `src/write_matrix.s` | Writes matrix dimensions and row-major integer data to a binary file | Exit `93`, `94`, or `95` for open/write/close failures |
| `src/classify.s` | Runs the complete classifier and optionally prints the predicted label | Exit `89` for invalid argc and `88` for malloc failure |

#### Binary matrix format

Each matrix file contains little-endian 32-bit integers in this order:

```text
rows
columns
matrix elements in row-major order
```

The first 8 bytes hold the two dimensions. The remaining
`rows * columns * 4` bytes hold the matrix elements.

#### Classification pipeline

```text
m0, m1, input = read_matrix(...)
h = matmul(m0, input)
h = relu(h)
o = matmul(m1, h)
write_matrix(output, o)
classification = argmax(o)
```

#### Implementation notes

- `read_matrix` verifies the exact number of bytes returned by every `fread` call.
- `write_matrix` checks the number of items returned by `fwrite`, rather than comparing against a byte count.
- `classify` stores all six matrix dimensions in a 64-byte aligned stack frame and preserves `ra` and `s0`-`s7` across nested calls.
- The output is printed only when `print_classification` is zero.
- All five allocated matrices (`m0`, `m1`, `input`, `h`, and `o`) are freed before a successful return.

#### Testing

Run the Part B and end-to-end tests from the `unittests` directory:

```bash
python3 -m unittest -v \
  unittests.TestReadMatrix \
  unittests.TestWriteMatrix \
  unittests.TestClassify \
  unittests.TestMain
```

Current results:

| Function | Coverage |
|---|---:|
| `read_matrix.s` | 64/64 |
| `write_matrix.s` | 56/56 |
| `classify.s` | 104/106 |

All 14 Part B and end-to-end tests pass. The end-to-end tests verify both
provided input sets, output-file bytes, printed classifications, silent mode,
and invalid command-line arguments. The two uncovered `classify` instructions
belong to its local malloc-error handler; the provided failure hook reaches the
earlier allocation inside `read_matrix` first.

To run the complete Project 2 regression suite:

```bash
python3 -m unittest -v unittests.py
```

All 33 Project 2 tests currently pass.
