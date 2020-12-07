# **********************************************************************************************************************
#   FileName:
#       gen_peripheral.py
#
#   Description:
#       Generators for files that belong to a peripheral driver
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from pathlib import Path
from typing import List

from src.embedded.argument_types import ArgProject
from src.embedded.projects.interface import FileGenerator
from src.embedded.configuration_types import DriverConfig
from src.embedded.c_cpp_resources import FileDescription

relative_output_path = Path('Chimera', 'source', 'drivers', 'peripherals')


def peripheral_generator_list() -> List[FileGenerator]:
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
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "{}_intf.hpp".format(cfg.driver_name.lower())
        desc = "Models the Chimera {} interface".format(cfg.driver_name.upper())

        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)
        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._body_string()
        body = body.format(driver_name_upper=cfg.driver_name.upper(), driver_name_lower=cfg.driver_name.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path, cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    @staticmethod
    def _body_string() -> str:
        pth = Path(Path(__file__).parent, 'periph_intf_template.txt')
        with pth.open('r') as f:
            return f.read()


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
