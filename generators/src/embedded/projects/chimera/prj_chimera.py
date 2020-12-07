# **********************************************************************************************************************
#   FileName:
#       prj_chimera.py
#
#   Description:
#
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

from src.embedded.argument_types import ArgLayer, ArgProject, ArgModule
from src.embedded.configuration_types import DriverConfig
from src.embedded.projects.chimera.gen_peripheral import peripheral_generator_list


def generate_project(cfg: DriverConfig):
    """
    Generates the Chimera project drivers

    Args:
        cfg: Parsed configuration options

    Returns:
        None
    """
    if cfg.layer != ArgLayer.ALL or cfg.project != ArgProject.CHIMERA:
        return

    if cfg.module_type == ArgModule.PERIPHERAL:
        for generator in peripheral_generator_list():
            generator.generate(cfg)
