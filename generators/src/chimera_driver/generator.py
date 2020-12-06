# **********************************************************************************************************************
#   FileName:
#       generator.py
#
#   Description:
#       Implements the generator for Chimera drivers
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

import argparse
from pathlib import Path
from typing import Dict


def parse_arguments():
    # ---------------------------------------------
    # Add arguments
    # ---------------------------------------------
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--driver', action="store", required=True, type=str,
                        help="Name of the driver being created")

    parser.add_argument('-o', '--output')

    arguments = parser.parse_known_args()[0]

    # ---------------------------------------------
    # Sanitize the inputs
    # ---------------------------------------------
    # None for now

    return arguments


class ChimeraDriver:

    def __init__(self, args: Dict):
        """
        Args:
            args: Arguments from the "parse_arguments" function.
        """

    def create(self):
        pass
