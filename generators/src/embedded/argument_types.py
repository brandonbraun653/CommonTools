# **********************************************************************************************************************
#   FileName:
#       argument_types.py
#
#   Description:
#       Arguments types associated with the embedded generator inputs
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from __future__ import annotations
from enum import Enum


class ArgProject(Enum):
    UNKNOWN = 0
    APOLLO = 1
    CHIMERA = 2
    THOR = 3

    @classmethod
    def to_type(cls, arg: str or ArgProject) -> ArgProject:
        if type(arg) == ArgProject:
            return arg

        if arg.lower() == 'apollo':
            return cls.APOLLO
        elif arg.lower() == 'chimera':
            return cls.CHIMERA
        elif arg.lower() == 'thor':
            return cls.THOR
        else:
            return cls.UNKNOWN


class ArgLayer(Enum):
    UNKNOWN = 0
    HLD = 1
    LLD = 2
    LLD_INTERFACE = 3
    ALL = 4

    @classmethod
    def to_type(cls, arg: str or ArgLayer) -> ArgLayer:
        if type(arg) == ArgLayer:
            return arg

        if arg.lower() == 'hld':
            return cls.HLD
        elif arg.lower() == 'lld':
            return cls.LLD
        elif arg.lower() == 'lld_intf' or arg.lower() == 'lld_interface':
            return cls.LLD_INTERFACE
        elif arg.lower() == 'all':
            return cls.ALL
        else:
            return cls.UNKNOWN


class ArgModule(Enum):
    UNKNOWN = 0
    PERIPHERAL = 1  # Some kind of peripheral driver
    GENERIC = 2     # A generic driver

    @classmethod
    def to_type(cls, arg: str or ArgModule) -> ArgModule:
        if type(arg) == ArgModule:
            return arg

        if arg.lower() in ['periph', 'peripheral']:
            return cls.PERIPHERAL
        elif arg.lower() in ['gen', 'generic']:
            return cls.GENERIC
        else:
            return cls.UNKNOWN
