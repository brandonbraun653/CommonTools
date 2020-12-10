# **********************************************************************************************************************
#   FileName:
#       prj_thor.py
#
#   Description:
#
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from src.embedded.argument_types import ArgLayer, ArgProject, ArgModule
from src.embedded.configuration_types import DriverConfig
from src.embedded.projects.thor.gen_hld import hld_generator_list
from src.embedded.projects.thor.gen_lld import lld_generator_list
from src.embedded.projects.thor.gen_lld_intf import lld_interface_generator_list


def supported_targets():
    return ['stm32l432kc']


def generate_project(cfg: DriverConfig):
    """
    Generates the Chimera project drivers

    Args:
        cfg: Parsed configuration options

    Returns:
        None
    """
    if cfg.project != ArgProject.THOR or cfg.module_type != ArgModule.PERIPHERAL:
        return

    if cfg.layer == ArgLayer.HLD:
        for generator in hld_generator_list():
            generator.generate(cfg)
    elif cfg.layer == ArgLayer.LLD:
        for generator in lld_generator_list():
            generator.generate(cfg)
    elif cfg.layer == ArgLayer.LLD_INTERFACE:
        for generator in lld_interface_generator_list():
            generator.generate(cfg)
    else:
        raise ValueError("{} not a supported Thor layer".format(cfg.layer))
