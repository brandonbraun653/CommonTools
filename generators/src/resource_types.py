# **********************************************************************************************************************
#   FileName:
#       resource_types.py
#
#   Description:
#       Discovers and loads resources from the resources directory
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from abc import ABCMeta, abstractmethod
from pathlib import Path


__resource_dir = Path(Path(__file__).parent, '../resources').resolve()


class TextResource(metaclass=ABCMeta):

    @abstractmethod
    def get_resource(self) -> str:
        """
        Reads the text source and returns it as a string to the user

        Returns:
            str
        """
        raise NotImplementedError
