# **********************************************************************************************************************
#   FileName:
#       generator.py
#
#   Description:
#       Parses command line arguments and redirects them into the proper
#       generator targets for a given project type
#
#   12/6/20 | Brandon Braun | brandonbraun653@gmail.com
# **********************************************************************************************************************

import argparse
import src.embedded.projects.apollo.prj_apollo as apollo
import src.embedded.projects.chimera.prj_chimera as chimera
import src.embedded.projects.thor.prj_thor as thor

from pathlib import Path
from typing import Dict
from src.embedded.argument_types import ArgLayer, ArgProject, ArgModule
from src.embedded.configuration_types import DriverConfig


def parse_arguments() -> Dict:
    # ---------------------------------------------------------
    # Add arguments
    # ---------------------------------------------------------
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--driver', action="store", required=True, type=str,
                        help="Name of the driver being created")
    parser.add_argument('-o', '--output', action="store", required=False, type=str, default=".",
                        help="Output directory to place generated files in")
    parser.add_argument('-p', '--project', action="store", required=True, type=str,
                        choices=['Chimera', 'Thor', 'Apollo'],
                        help='Which project structure to target')
    parser.add_argument('-t', '--target', action="store", required=False, type=str, default="",
                        help="Which target device is the driver for")
    parser.add_argument('-l', '--layer', action="store", required=False, type=str, default="all",
                        choices=['all', 'hld', 'lld', 'lld_interface'],
                        help="Which driver layer(s) to generate")
    parser.add_argument('-m', '--module', action="store", required=True, type=str,
                        choices=['peripheral', 'generic'],
                        help="The driver module type that is being created. This affects architecture.")

    arguments = parser.parse_known_args()[0]

    # ---------------------------------------------------------
    # Sanitize the inputs
    # ---------------------------------------------------------
    sanitized = {}

    # Resolve the output path (relative or absolute)
    pth = Path(arguments.output)
    actual_path = None
    if pth.is_absolute() and pth.exists():
        actual_path = pth
    else:
        rel_path = Path(Path.cwd(), pth).resolve()
        if rel_path.exists():
            actual_path = rel_path

    sanitized['output'] = actual_path

    # Resolve the remaining arguments
    sanitized['driver'] = arguments.driver.strip()
    sanitized['target'] = arguments.target.strip()
    sanitized['layer'] = ArgLayer.to_type(arguments.layer)
    sanitized['project'] = ArgProject.to_type(arguments.project)
    sanitized['module'] = ArgModule.to_type(arguments.module)

    return sanitized


def generate_project_files(args: Dict) -> None:
    """
    Generates the appropriate driver templates based on the given arguments

    Args:
        args: Parsed arguments
    """
    # ---------------------------------------------------------
    # Build the system configuration
    # ---------------------------------------------------------
    cfg = DriverConfig()

    cfg.project = args['project']
    cfg.layer = args['layer']
    cfg.output_dir = args['output']
    cfg.target_device = args['target']
    cfg.driver_name = args['driver']
    cfg.module_type = args['module']
    cfg.author = "Brandon Braun"
    cfg.email = "brandonbraun653@gmail.com"

    # ---------------------------------------------------------
    # Invoke the proper generator target
    # ---------------------------------------------------------
    if args['project'] == ArgProject.CHIMERA:
        chimera.generate_project(cfg)
    elif args['project'] == ArgProject.APOLLO:
        apollo.generate_project(cfg)
    elif args['project'] == ArgProject.THOR:
        thor.generate_project(cfg)
    else:
        raise ValueError('Unknown project type')
