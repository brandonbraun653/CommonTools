# =============================================================================
# File:
#   toolchain.cmake
#
# Description:
#   Sets some high level variables for configuring the build tool
#
# Variable Requirements:
#   COMMON_TOOL_ROOT: Location of the CommonTool root directory
#
# CommonTool Github: https://github.com/brandonbraun653/CommonTools.git
#
# 2020-2021 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
cmake_minimum_required(VERSION 3.18.0)

# ====================================================
# Validate requirements of this module
# ====================================================
if(NOT COMMON_TOOL_ROOT)
message(FATAL_ERROR "Path to the CommonTool root must be defined")
endif()

# ====================================================
# Set default options for supported toolchains
# ====================================================
set(TOOLCHAIN "gcc" CACHE STRING "Selects the toolchain used in compilation")
set_property(CACHE TOOLCHAIN PROPERTY STRINGS
  gcc
  arm-none-eabi
  arm-linux-gnueabihf
  msvc
  clang
)

# ====================================================
# Check that a valid toolchain is selected
# ====================================================
get_property(toolchain_allowed_strings CACHE TOOLCHAIN PROPERTY STRINGS)
if(NOT ${TOOLCHAIN} IN_LIST toolchain_allowed_strings)
  message(FATAL_ERROR "Unsupported toolchain: ${TOOLCHAIN}")
endif()

# ====================================================
# Pull in the appropriate toolchain file
# ====================================================
if(${TOOLCHAIN} MATCHES "^arm-none-eabi$")
  set(CMAKE_GENERATOR "Unix Makefiles" CACHE INTERNAL "" FORCE)
  set(CMAKE_TOOLCHAIN_FILE "${COMMON_TOOL_ROOT}/cmake/toolchains/gcc_arm_none_eabi.cmake" CACHE INTERNAL "" FORCE)
elseif(${TOOLCHAIN} MATCHES "^arm-linux-gnueabihf$")
  set(CMAKE_GENERATOR "Unix Makefiles" CACHE INTERNAL "" FORCE)
  set(CMAKE_TOOLCHAIN_FILE "${COMMON_TOOL_ROOT}/cmake/toolchains/arm_linux_gnueabihf.cmake" CACHE INTERNAL "" FORCE)
elseif(${TOOLCHAIN} MATCHES "^gcc$")
  set(CMAKE_GENERATOR "Unix Makefiles" CACHE INTERNAL "" FORCE)
  set(CMAKE_TOOLCHAIN_FILE "${COMMON_TOOL_ROOT}/cmake/toolchains/gcc.cmake" CACHE INTERNAL "" FORCE)
else()
  message(STATUS "Didn't match any toolchains")
endif()

# ====================================================
# Prevent cluttering of the project directory with build files
# ====================================================
# User variables
set(ARTIFACTS_DIR ${CMAKE_BINARY_DIR}/../artifacts CACHE INTERNAL "" FORCE)

# CMake variables
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib CACHE INTERNAL "" FORCE)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib CACHE INTERNAL "" FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ARTIFACTS_DIR}/last_build_version CACHE INTERNAL "" FORCE)
