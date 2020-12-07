# **********************************************************************************************************************
#   FileName:
#       gen_peripheral.py
#
#   Description:
#       Generators for files that belong to a peripheral driver
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from typing import List

from src.embedded.argument_types import ArgProject
from src.embedded.projects.interface import FileGenerator
from src.embedded.configuration_types import DriverConfig


def generator_list() -> List[FileGenerator]:
    """
    Returns:
        All the generators used to create a Chimera peripheral driver
    """
    return [Interface(), User(), Types(), CMake()]


class Interface(FileGenerator):

    @property
    def project(self) -> ArgProject:
        return ArgProject.CHIMERA

    def generate(self, cfg: DriverConfig):
        pass


class User(FileGenerator):

    @property
    def project(self) -> ArgProject:
        return ArgProject.CHIMERA

    def generate(self, cfg: DriverConfig):
        pass


class Types(FileGenerator):

    @property
    def project(self) -> ArgProject:
        return ArgProject.CHIMERA

    def generate(self, cfg: DriverConfig):
        pass


class CMake(FileGenerator):

    @property
    def project(self) -> ArgProject:
        return ArgProject.CHIMERA

    def generate(self, cfg: DriverConfig):
        pass
