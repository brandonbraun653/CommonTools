# **********************************************************************************************************************
#   FileName:
#       gen_chimera_driver.py
#
#   Description:
#       Generates a new Chimera driver template
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from src.chimera_driver.generator import parse_arguments, ChimeraDriver


if __name__ == "__main__":
    arguments = parse_arguments()
    gen = ChimeraDriver(arguments)
    gen.create()
