# **********************************************************************************************************************
#   FileName:
#       gen_lld_intf.py
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

relative_output_path = Path('Thor', 'lld', 'interface')


def lld_interface_generator_list() -> List[FileGenerator]:
    """
    Returns:
        All the generators used to create a Chimera peripheral driver
    """
    return [Interface(), PrvData(), Detail(), Types(), CMake()]


class Interface(FileGenerator):
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
        filename = "{}_intf.hpp".format(cfg.driver_name.lower())
        desc = "STM32 LLD {} Interface Spec".format(cfg.driver_name.upper())
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
        filename = "{}_intf.cpp".format(cfg.driver_name.lower())
        desc = "LLD interface functions that are processor independent"
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
        pth = Path(Path(__file__).parent, 'lld_intf/intf_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_source() -> str:
        pth = Path(Path(__file__).parent, 'lld_intf/intf_cpp_template.txt')
        with pth.open('r') as f:
            return f.read()


class PrvData(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "{}_prv_data.hpp".format(cfg.driver_name.lower())
        desc = "Declaration of data that must be defined by the LLD implementation or is\n"\
               "*    shared among all possible drivers.".format(cfg.driver_name.upper())
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

    @staticmethod
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'lld_intf/prv_data_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()


class Detail(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "{}_detail.hpp".format(cfg.driver_name.lower())
        desc = "Includes the LLD specific headers for chip implementation details"
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

    @staticmethod
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'lld_intf/detail_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()


class Types(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "{}_types.hpp".format(cfg.driver_name.lower())
        desc = "Common LLD {} Types".format(cfg.driver_name.upper())
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

    @staticmethod
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'lld_intf/types_hpp_template.txt')
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
        pth = Path(Path(__file__).parent, 'lld_intf/cmake_template.txt')
        with pth.open('r') as f:
            return f.read()
