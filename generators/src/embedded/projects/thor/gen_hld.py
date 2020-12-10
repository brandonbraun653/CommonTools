# **********************************************************************************************************************
#   FileName:
#       gen_hld.py
#
#   Description:
#
#
#   12/7/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from pathlib import Path
from typing import List

from src.embedded.argument_types import ArgProject
from src.embedded.projects.interface import FileGenerator
from src.embedded.configuration_types import DriverConfig
from src.embedded.c_cpp_resources import FileDescription

relative_output_path = Path('Thor', 'hld')


def hld_generator_list() -> List[FileGenerator]:
    """
    Returns:
        All the generators used to create a Chimera peripheral driver
    """
    return [ChimeraInterface(), HLDDriver(), CMake()]


class ChimeraInterface(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        self.generate_header(cfg)
        self.generate_source(cfg)

    def generate_header(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hld_{}_chimera.hpp".format(cfg.driver_name.lower())
        desc = "Chimera hooks for implementing {}".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(), driver_name_lower=cfg.driver_name.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path, cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_source(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hld_{}_chimera.cpp".format(cfg.driver_name.lower())
        desc = "Implementation of Chimera {} driver hooks".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_source()
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
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_chimera_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_source() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_chimera_cpp_template.txt')
        with pth.open('r') as f:
            return f.read()


class HLDDriver(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        self.generate_header(cfg)
        self.generate_source(cfg)
        self.generate_types(cfg)

    def generate_header(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hld_{}_driver.hpp".format(cfg.driver_name.lower())
        desc = "Thor {} high level driver".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(), driver_name_lower=cfg.driver_name.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path, cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_source(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hld_{}_driver.cpp".format(cfg.driver_name.lower())
        desc = "Implements the custom driver variant of the Thor {} interface.".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_source()
        body = body.format(driver_name_upper=cfg.driver_name.upper(), driver_name_lower=cfg.driver_name.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path, cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_types(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hld_{}_types.cpp".format(cfg.driver_name.lower())
        desc = "Thor {} types".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_types()
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
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_driver_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_source() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_driver_cpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_types() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_types_template.txt')
        with pth.open('r') as f:
            return f.read()


class CMake(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig):
        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        filename = "CMakeLists.txt"
        body = self._body_string()
        body = body.format(driver_name_lower=cfg.driver_name.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path, cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(body)

    @staticmethod
    def _body_string() -> str:
        pth = Path(Path(__file__).parent, 'hld/hld_cmake_template.txt')
        with pth.open('r') as f:
            return f.read()
