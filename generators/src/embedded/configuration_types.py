# **********************************************************************************************************************
#   FileName:
#       configuration_types.py
#
#   Description:
#
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

import datetime

from pathlib import Path
from src.embedded.argument_types import ArgLayer, ArgProject, ArgModule


class DriverConfig:
    """ Common properties to describe the driver being built """

    def __init__(self):
        self._author = ""
        self._email = ""
        self._project = ArgProject.UNKNOWN
        self._layer = ArgLayer.UNKNOWN
        self._module = ArgModule.UNKNOWN
        self._target_device = ""
        self._driver_name = ""
        self._output_dir = Path.cwd()

    # ---------------------------------------------------------
    # Properties about the implementer
    # ---------------------------------------------------------
    @property
    def author(self) -> str:
        return self._author

    @author.setter
    def author(self, value: str) -> None:
        self._author = value

    @property
    def email(self) -> str:
        return self._email

    @email.setter
    def email(self, value: str) -> None:
        self._email = value

    # ---------------------------------------------------------
    # System Time
    # ---------------------------------------------------------
    @property
    def date(self) -> str:
        return datetime.datetime.now().strftime("%m/%d/%Y")

    @property
    def year(self) -> str:
        return datetime.datetime.now().strftime("%Y")

    # ---------------------------------------------------------
    # Project descriptions
    # ---------------------------------------------------------
    @property
    def module_type(self) -> ArgModule:
        return self._module

    @module_type.setter
    def module_type(self, value) -> None:
        self._module = ArgModule.to_type(value)

    @property
    def driver_name(self) -> str:
        return self._driver_name

    @driver_name.setter
    def driver_name(self, value) -> None:
        self._driver_name = value

    @property
    def output_dir(self) -> Path:
        return self._output_dir

    @output_dir.setter
    def output_dir(self, value: Path or str) -> None:
        pth = Path(value).resolve()
        if not pth.exists():
            raise ValueError("Path doesn't exist: {}".format(str(pth)))
        else:
            self._output_dir = pth

    @property
    def project(self) -> ArgProject:
        return self._project

    @project.setter
    def project(self, value: str or ArgProject) -> None:
        self._project = ArgProject.to_type(value)

    @property
    def layer(self) -> ArgLayer:
        return self._layer

    @layer.setter
    def layer(self, value: str or ArgLayer) -> None:
        self._layer = ArgLayer.to_type(value)

    @property
    def target_device(self) -> str:
        return self._target_device

    @target_device.setter
    def target_device(self, value: str) -> None:
        # TODO: Eventually push this through a proper filter
        self._target_device = value
