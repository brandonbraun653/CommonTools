# **********************************************************************************************************************
#   FileName:
#       c_cpp_resources.py
#
#   Description:
#       Loads common C/C++ resources for generators
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from pathlib import Path
from src.resource_types import __resource_dir, TextResource


cpp_dir = Path(__resource_dir, 'c_cpp').resolve()


class FileDescription(TextResource):

    def __init__(self):
        self._name = 'file_description.txt'
        self._path = Path(cpp_dir, self._name)

        assert(self._path.exists())

    def get_resource(self) -> str:
        with self._path.open('r') as f:
            return f.read()

    def format(self, filename: str, description: str, date:str, author: str, email: str) -> str:
        raw_string = self.get_resource()
        return raw_string.format(filename=filename, description=description, date=date, author=author, email=email)


