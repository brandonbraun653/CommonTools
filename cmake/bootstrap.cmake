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
SET(COMMON_TOOL_ROOT "${CMAKE_CURRENT_LIST_DIR}/../")

# Add all CommonTools directories to CMAKE_MODULE_PATH
# This allows find_package() and include() to find our custom modules
list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_LIST_DIR}/modules"      # Custom CMake modules (Find*.cmake, etc.)
    "${CMAKE_CURRENT_LIST_DIR}/utility"      # Utility functions and macros
    "${CMAKE_CURRENT_LIST_DIR}/options"      # Project option configurations
    "${CMAKE_CURRENT_LIST_DIR}/toolchains"   # Custom toolchain files
)

# Also add to CMAKE_TOOLCHAIN_PATH for toolchain discovery
# (CMAKE_MODULE_PATH is also searched, but this makes it explicit)
list(APPEND CMAKE_TOOLCHAIN_PATH
    "${CMAKE_CURRENT_LIST_DIR}/toolchains"
)

# Detect project level configuration options
include("${CMAKE_CURRENT_LIST_DIR}/options/common.cmake")
