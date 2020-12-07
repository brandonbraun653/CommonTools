# **********************************************************************************************************************
#   FileName:
#       gen_embedded_driver.py
#
#   Description:
#       Entry point to create embedded driver templates. This is just a convenience wrapper for
#       command line execution.
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from src.embedded.generator import parse_arguments, generate_project_files


if __name__ == "__main__":
    arguments = parse_arguments()
    generate_project_files(arguments)
