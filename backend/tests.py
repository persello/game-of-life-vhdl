from pathlib import Path
from vunit import VUnit

# Root path
ROOT = Path(__file__).resolve().parent

# Entities path
ENTITIES_PATH = ROOT / "entities"

# Testbench path
TESTBENCHES_PATH = ROOT / "testbenches"

# VUnit instance
VU = VUnit.from_argv()
VU.enable_location_preprocessing()

# Entities library
src_lib = VU.add_library("src_lib")
src_lib.add_source_files([ENTITIES_PATH / "cell.vhdl", ENTITIES_PATH / "ones_counter.vhdl", ENTITIES_PATH / "world.vhdl"])

# # Matrix type library
# mat_lib = VU.add_library("mat_lib")
# mat_lib.add_source_file(ROOT / "lib" / "matrix_type.vhdl")

# Testbenches library
tb_lib = VU.add_library("tb_lib")
tb_lib.add_source_files([TESTBENCHES_PATH / "cell_tb.vhdl", TESTBENCHES_PATH / "ones_counter_tb.vhdl", TESTBENCHES_PATH / "world_tb.vhdl"])

VU.main()
