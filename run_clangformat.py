# **********************************************************************************
#   FileName:
#       run_clangformat.py
#
#   Description:
#       Runs custom clang-formatting options on the Thor project
#
#   Usage Examples:
#       python run_clangformat.py
#
#   2019 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************

import os
import sys
import swqa
import argparse

from swqa.clangformat import ClangFormatter


def run_clang_format():
    """
    Executes clang formatting on the Thor project

    :return: Process status code
    :rtype: int
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', dest='format_file', default='',
                        help='Gives the path to the format .json file, relative to this script')

    args = parser.parse_args()

    format_file = os.path.realpath(os.path.join(os.getcwd(), args.format_file))
    working_dir = os.path.dirname(format_file)
    print("Working Dir: {}".format(working_dir))
    print("Format File: {}".format(format_file))

    cf = ClangFormatter(project_file=format_file, working_dir=working_dir, clang_format_exe=swqa.clang_format_exe)
    return cf.execute()


if __name__ == "__main__":
    sys.exit(run_clang_format())

