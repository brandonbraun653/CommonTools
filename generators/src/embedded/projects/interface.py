# **********************************************************************************************************************
#   FileName:
#       interface.py
#
#   Description:
#       Interface classes for generator projects
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from abc import abstractmethod
from src.embedded.argument_types import ArgProject
from src.embedded.configuration_types import DriverConfig


class FileGenerator:
    """
    Describes methods that should be available for any object that can generate
    a single file.
    """

    @property
    @abstractmethod
    def project(self) -> ArgProject:
        raise NotImplementedError

    @abstractmethod
    def generate(self, cfg: DriverConfig) -> None:
        """
        Generates the necessary file associated with the inherited class

        Args:
            cfg: Configuration information used to generate the file

        Returns:
            None
        """
        raise NotImplementedError


class ProjectFactory:
    """ Methods used to generate files for an entire project type """

    @abstractmethod
    def generate(self, cfg: DriverConfig) -> None:
        """

        Args:
            cfg: Configuration information used to generate the

        Returns:
            None
        """
        pass