# =============================================================================
# CommonTools CMake Bootstrap
#
# This file initializes the CMake environment by automatically adding all
# necessary module, utility, options, and toolchain paths to the CMake search paths.
#
# Usage:
#   include("path/to/CommonTools/cmake/bootstrap.cmake")
#
# This should be included early in your root CMakeLists.txt, before any
# find_package() or include() calls that depend on the CommonTools modules.
# =============================================================================

# Get the directory containing this bootstrap file
get_filename_component(_COMMON_TOOLS_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

# Add all CommonTools directories to CMAKE_MODULE_PATH
# This allows find_package() and include() to find our custom modules
list(APPEND CMAKE_MODULE_PATH
    "${_COMMON_TOOLS_CMAKE_DIR}/modules"      # Custom CMake modules (Find*.cmake, etc.)
    "${_COMMON_TOOLS_CMAKE_DIR}/utility"      # Utility functions and macros
    "${_COMMON_TOOLS_CMAKE_DIR}/options"      # Project option configurations
    "${_COMMON_TOOLS_CMAKE_DIR}/toolchains"   # Custom toolchain files
)

# Also add to CMAKE_TOOLCHAIN_PATH for toolchain discovery
# (CMAKE_MODULE_PATH is also searched, but this makes it explicit)
list(APPEND CMAKE_TOOLCHAIN_PATH
    "${_COMMON_TOOLS_CMAKE_DIR}/toolchains"
)

# Detect project level configuration options
include("${_COMMON_TOOLS_CMAKE_DIR}/options/common.cmake")

# Clean up temporary variable
unset(_COMMON_TOOLS_CMAKE_DIR)
