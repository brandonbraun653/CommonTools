# **********************************************************************************************************************
#   FileName:
#       gen_lld.py
#
#   Description:
#
#
#   12/7/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

import re

from pathlib import Path
from typing import List

from src.embedded.argument_types import ArgProject
from src.embedded.projects.interface import FileGenerator
from src.embedded.configuration_types import DriverConfig
from src.embedded.c_cpp_resources import FileDescription


def lld_generator_list() -> List[FileGenerator]:
    """
    Returns:
        All the generators used to create a Chimera peripheral driver
    """
    return [CMake(), Data(), Driver(), Project(), Types(), Variant()]


def relative_output_path(cfg: DriverConfig):
    chip_folder = 'STM32{}x'.format(ChipNameView(cfg.target_device).family)
    return Path('Thor', 'lld', chip_folder.lower())


class ChipNameView:
    """ Translates microcontroller chip names into different forms """

    def __init__(self, chip: str):
        self._chip = chip

    @property
    def full(self):
        """ Returns the full chip name """
        return self._chip.upper()

    @property
    def abbreviated(self):
        """ Grabs the L432KC of STM32L432KC """
        return self.chip + self.variant

    @property
    def family(self):
        """ Gets the L4 part of STM32L432KC """
        return re.search(r"[a-zA-Z]{3}\d{2}(\w{2})", self._chip).group(1).upper()

    @property
    def chip(self):
        """ Gets the L432 part of STM32L432KC """
        return re.search(r"[a-zA-Z]\d{3}", self._chip).group(0).upper()

    @property
    def variant(self):
        """ Gets the KC part of STM32L432KC """
        return re.search(r"\d{3}([a-zA-Z]{2})", self._chip).group(1).upper()


class CMake(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig):
        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        view = ChipNameView(cfg.target_device)

        filename = "CMakeLists.txt"
        body = self._body_string()
        body = body.format(driver_name_lower=cfg.driver_name.lower(),
                           family_lower=view.family.lower(),
                           family_upper=view.family.upper(),
                           chip_upper=view.chip.upper(),
                           abbreviated_lower=view.abbreviated.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(body)

    @staticmethod
    def _body_string() -> str:
        pth = Path(Path(__file__).parent, 'lld/cmake_template.txt')
        with pth.open('r') as f:
            return f.read()


class Data(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        self.generate_header(cfg)
        self.generate_source(cfg)

    def generate_header(self, cfg: DriverConfig) -> None:
        pass

    def generate_source(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hw_{}_data.cpp".format(cfg.driver_name.lower())
        desc = "Provides implementation details for private {} driver data".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        view = ChipNameView(cfg.target_device)
        body = self._get_source()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_upper=view.family.upper())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    @staticmethod
    def _get_header() -> str:
        pass

    @staticmethod
    def _get_source() -> str:
        pth = Path(Path(__file__).parent, 'lld/data_template.txt')
        with pth.open('r') as f:
            return f.read()


class Driver(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        self.generate_header(cfg)
        self.generate_source(cfg)

    def generate_header(self, cfg: DriverConfig) -> None:
        pass

    def generate_source(self, cfg: DriverConfig) -> None:
        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hw_{}_driver.cpp".format(cfg.driver_name.lower())
        desc = "Implements the LLD interface to the {} hardware.".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        view = ChipNameView(cfg.target_device)
        body = self._get_source()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_upper=view.family.upper(),
                           family_lower=view.family.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    @staticmethod
    def _get_header() -> str:
        pass

    @staticmethod
    def _get_source() -> str:
        pth = Path(Path(__file__).parent, 'lld/driver_template.txt')
        with pth.open('r') as f:
            return f.read()


class Project(FileGenerator):
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
        filename = "hw_{}_prj.hpp".format(cfg.driver_name.lower())
        desc = "Pulls in target specific definitions and resources used in the actual driver"
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        view = ChipNameView(cfg.target_device)
        body = self._get_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_upper=view.family.upper(),
                           family_lower=view.family.lower(),
                           abbreviated_lower=view.abbreviated.lower(),
                           chip_upper=view.chip.upper())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_source(self, cfg: DriverConfig) -> None:
        pass

    @staticmethod
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'lld/prj_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_source() -> str:
        pass


class Types(FileGenerator):
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
        filename = "hw_{}_types.hpp".format(cfg.driver_name.lower())
        desc = "LLD types for the {} Peripheral".format(cfg.driver_name.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        view = ChipNameView(cfg.target_device)
        body = self._get_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_lower=view.family.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_source(self, cfg: DriverConfig) -> None:
        pass

    @staticmethod
    def _get_header() -> str:
        pth = Path(Path(__file__).parent, 'lld/types_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_source() -> str:
        pass


class Variant(FileGenerator):
    @property
    def project(self) -> ArgProject:
        return ArgProject.THOR

    def generate(self, cfg: DriverConfig) -> None:
        self.generate_common_header(cfg)
        self.generate_device_header(cfg)
        self.generate_device_source(cfg)

    def generate_common_header(self, cfg: DriverConfig) -> None:
        view = ChipNameView(cfg.target_device)

        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hw_{}_register_stm32{}xxxx.hpp".format(cfg.driver_name.lower(), view.family.lower())
        desc = "{} register definitions for the STM32{}xxxx series chips.".format(cfg.driver_name.upper(),
                                                                                  view.family.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_common_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_upper=view.family.upper(),
                           family_lower=view.family.lower(),
                           abbreviated_lower=view.abbreviated.lower())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), 'variant', filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_device_header(self, cfg: DriverConfig) -> None:
        view = ChipNameView(cfg.target_device)

        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hw_{}_register_stm32{}.hpp".format(cfg.driver_name.lower(), view.abbreviated.lower())
        desc = "{} register definitions for the STM32{} series chips.".format(cfg.driver_name.upper(),
                                                                                  view.abbreviated.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_device_header()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           abbreviated_upper=view.abbreviated.upper())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), 'variant', filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    def generate_device_source(self, cfg: DriverConfig) -> None:
        view = ChipNameView(cfg.target_device)

        # ---------------------------------------------------------
        # File header
        # ---------------------------------------------------------
        filename = "hw_{}_register_stm32{}.cpp".format(cfg.driver_name.lower(), view.abbreviated.lower())
        desc = "{} register definitions for the STM32{} series chips.".format(cfg.driver_name.upper(),
                                                                                  view.abbreviated.upper())
        header = FileDescription().format(filename=filename, description=desc, date=cfg.year, author=cfg.author,
                                          email=cfg.email)

        # ---------------------------------------------------------
        # Body
        # ---------------------------------------------------------
        body = self._get_device_source()
        body = body.format(driver_name_upper=cfg.driver_name.upper(),
                           driver_name_lower=cfg.driver_name.lower(),
                           family_upper=view.family.upper(),
                           family_lower=view.family.lower(),
                           abbreviated_lower=view.abbreviated.lower(),
                           chip_upper=view.chip.upper())

        # ---------------------------------------------------------
        # Write to file
        # ---------------------------------------------------------
        output = Path(cfg.output_dir, relative_output_path(cfg), cfg.driver_name.lower(), 'variant', filename)
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open('w') as f:
            f.write(header)
            f.write(body)

    @staticmethod
    def _get_common_header() -> str:
        pth = Path(Path(__file__).parent, 'lld/register_general_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_device_header() -> str:
        pth = Path(Path(__file__).parent, 'lld/register_specific_hpp_template.txt')
        with pth.open('r') as f:
            return f.read()

    @staticmethod
    def _get_device_source() -> str:
        pth = Path(Path(__file__).parent, 'lld/register_specific_cpp_template.txt')
        with pth.open('r') as f:
            return f.read()
