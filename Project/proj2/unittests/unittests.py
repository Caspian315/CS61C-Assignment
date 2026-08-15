from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    def test_negative(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_invalid_length(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", 0)
        # call the relu function
        t.call("relu")

        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute(code=78)

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-2,12,41,-1145,14,89])
        # TODO
        # load address of the array into register a0
        t.input_array("a0",array0)
        # TODO
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # TODO
        # call the `argmax` function
        t.call("argmax")
        # TODO
        t.check_scalar("a0", 5)
        # TODO
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()
    
    def test_invalid_length(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", 0)
        # call the function
        t.call("argmax")
       
        t.execute(code=77)

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")

        # create arrays in the data section
        array0 = t.array([1, 2, 3])
        array1 = t.array([4, 5, 6])

        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)

        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)

        # call the `dot` function
        t.call("dot")

        # 1*4 + 2*5 + 3*6 = 32
        t.check_scalar("a0", 32)

        t.execute()

    def test_stride(self):
        t = AssemblyTest(self, "dot.s")

        array0 = t.array([1, 99, 2, 99, 3])
        array1 = t.array([4, 5, 6])

        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 2)
        t.input_scalar("a4", 1)

        t.call("dot")

        # 1*4 + 2*5 + 3*6 = 32
        t.check_scalar("a0", 32)
        t.execute()

    def test_invalid_length(self):
        t = AssemblyTest(self, "dot.s")

        array0 = t.array([1])
        array1 = t.array([2])

        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)

        t.call("dot")
        t.execute(code=75)

    def test_invalid_stride_v0(self):
        t = AssemblyTest(self, "dot.s")

        array0 = t.array([1])
        array1 = t.array([2])

        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 1)
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 1)

        t.call("dot")
        t.execute(code=76)

    def test_invalid_stride_v1(self):
        t = AssemblyTest(self, "dot.s")

        array0 = t.array([1])
        array1 = t.array([2])

        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 1)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 0)

        t.call("dot")
        t.execute(code=76)
    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols,
              m1, m1_rows, m1_cols,
              result, code=0):
        t = AssemblyTest(self, "matmul.s")

        # matmul calls dot
        t.include("dot.s")

        # create input and output arrays
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # m0 pointer, rows and columns
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)

        # m1 pointer, rows and columns
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)

        # output matrix pointer
        t.input_array("a6", array_out)

        # call matmul
        t.call("matmul")

        # Error cases terminate before returning, so only check the
        # output matrix for successful calls.
        if code == 0:
            t.check_array(array_out, result)

        t.execute(code=code)
    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )
    
    def test_rectangular(self):
        self.do_matmul(
        [1, 2, 3,
         4, 5, 6], 2, 3,

        [7, 8,
         9, 10,
         11, 12], 3, 2,

        [58, 64,
         139, 154]
    )


    def test_invalid_m0_rows(self):
        self.do_matmul(
            [1], 0, 1,
            [1], 1, 1,
            [0],
            code=72
        )


    def test_invalid_m0_cols(self):
        self.do_matmul(
            [1], 1, 0,
            [1], 1, 1,
            [0],
            code=72
        )


    def test_invalid_m1_rows(self):
        self.do_matmul(
            [1], 1, 1,
            [1], 0, 1,
            [0],
            code=73
        )


    def test_invalid_m1_cols(self):
        self.do_matmul(
            [1], 1, 1,
            [1], 1, 0,
            [0],
            code=73
        )


    def test_dimension_mismatch(self):
        self.do_matmul(
            [1, 2], 1, 2,
            [1, 2, 3], 3, 1,
            [0],
            code=74
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):
    def do_read_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")

        # Input filename
        t.input_read_filename(
            "a0",
            "inputs/test_read_matrix/test_input.bin"
        )

        # Space for output rows and columns
        rows = t.array([-1])
        cols = t.array([-1])

        t.input_array("a1", rows)
        t.input_array("a2", cols)

        t.call("read_matrix")

        if code == 0:
            t.check_array(rows, [3])
            t.check_array(cols, [3])
            t.check_array_pointer(
                "a0",
                [1, 2, 3, 4, 5, 6, 7, 8, 9]
            )

        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix()

    def test_fopen_error(self):
        self.do_read_matrix(fail="fopen", code=90)

    def test_fread_error(self):
        self.do_read_matrix(fail="fread", code=91)

    def test_malloc_error(self):
        self.do_read_matrix(fail="malloc", code=88)

    def test_fclose_error(self):
        self.do_read_matrix(fail="fclose", code=92)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)

class TestWriteMatrix(TestCase):

    def do_write_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        outfile = "outputs/test_write_matrix/student.bin"

        # Output filename
        t.input_write_filename("a0", outfile)

        # Matrix data and dimensions
        matrix = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a1", matrix)
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 3)

        t.call("write_matrix")
        t.execute(fail=fail, code=code)

        # Failed calls may leave no file or a partial file.
        if code == 0:
            t.check_file_output(
                outfile,
                "outputs/test_write_matrix/reference.bin"
            )

    def test_simple(self):
        self.do_write_matrix()

    def test_fopen_error(self):
        self.do_write_matrix(fail="fopen", code=93)

    def test_fwrite_error(self):
        self.do_write_matrix(fail="fwrite", code=94)

    def test_fclose_error(self):
        self.do_write_matrix(fail="fclose", code=95)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)

class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.input_scalar("a2", 0)
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)

        # Compare the output matrix and printed classification.
        t.check_file_output(out_file, ref_file)
        t.check_stdout("2")

    def test_no_print(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student_no_print.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]

        # A nonzero print flag suppresses all output.
        t.input_scalar("a2", 1)
        t.call("classify")
        t.execute(args=args)

        t.check_file_output(out_file, ref_file)
        t.check_stdout("")

    def test_invalid_argc(self):
        t = self.make_test()

        # classify expects argc == 5, including argv[0].
        t.input_scalar("a0", 0)
        t.call("classify")
        t.execute(code=89)

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


class TestMain(TestCase):

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin", f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"
        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args, verbose=False)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")
