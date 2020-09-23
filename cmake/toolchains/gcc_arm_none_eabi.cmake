# =============================================================================
# File:
#   gcc_arm_none_eabi.cmake
#
# Description:
#   Sets some high level variables for configuring the build tool
#
# Variable Requirements:
#   ARM_NONE_EABI_ROOT: Location of binary root for toolchain executables
#
# Exports:
#   Toolchain::HAS_GCC_ARM_NONE_EABI
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
# ====================================================
# Configure the toolchain paths
# ====================================================
# System Type
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# C Compiler
set(CMAKE_C_COMPILER "${ARM_NONE_EABI_ROOT}arm-none-eabi-gcc")
set(CMAKE_C_COMPILER_AR "${ARM_NONE_EABI_ROOT}arm-none-eabi-ar")
set(CMAKE_C_COMPILER_RANLIB "${ARM_NONE_EABI_ROOT}arm-none-eabi-ranlib")

# C++ Compiler
set(CMAKE_CXX_COMPILER "${ARM_NONE_EABI_ROOT}arm-none-eabi-g++")
set(CMAKE_CXX_COMPILER_AR "${ARM_NONE_EABI_ROOT}arm-none-eabi-ar")
set(CMAKE_CXX_COMPILER_RANLIB "${ARM_NONE_EABI_ROOT}arm-none-eabi-ranlib")

# CMake Defaults
set(CMAKE_AR "${ARM_NONE_EABI_ROOT}arm-none-eabi-ar")
set(CMAKE_LINKER "${ARM_NONE_EABI_ROOT}arm-none-eabi-ld")
set(CMAKE_NM "${ARM_NONE_EABI_ROOT}arm-none-eabi-nm")
set(CMAKE_OBJCOPY "${ARM_NONE_EABI_ROOT}arm-none-eabi-objcopy")
set(CMAKE_OBJDUMP "${ARM_NONE_EABI_ROOT}arm-none-eabi-objdump")
set(CMAKE_RANLIB "${ARM_NONE_EABI_ROOT}arm-none-eabi-ranlib")
set(CMAKE_STRIP "${ARM_NONE_EABI_ROOT}arm-none-eabi-strip")

# Postfixes, suffixes, prefixes
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_DEBUG_POSTFIX "_dbg")
set(CMAKE_RELEASE_POSTFIX "_rel")

# Needed for the test program to compile when --configuring
set(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs" CACHE INTERNAL "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# ====================================================
# Exports
# ====================================================
set(Toolchain::HAS_GCC_ARM_NONE_EABI TRUE CACHE INTERNAL "" FORCE)