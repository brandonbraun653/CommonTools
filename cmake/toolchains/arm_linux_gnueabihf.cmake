# =============================================================================
# File:
#   arm_linux_gnueabihf.cmake
#
# Description:
#   Sets some high level variables for configuring the build tool
#
# Variable Requirements:
#   ARM_LINUX_EABI_ROOT: Location of binary root for toolchain executables
#
# Exports:
#   Toolchain::HAS_GCC_ARM_LINUX_EABIHF
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
# ====================================================
# Configure the toolchain paths
# ====================================================
# System Type
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# ASM Compiler
set(CMAKE_ASM_COMPILER "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-as")

# C Compiler
set(CMAKE_C_COMPILER "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-gcc")
set(CMAKE_C_COMPILER_AR "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ar")
set(CMAKE_C_COMPILER_RANLIB "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ranlib")

# C++ Compiler
set(CMAKE_CXX_COMPILER "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-g++")
set(CMAKE_CXX_COMPILER_AR "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ar")
set(CMAKE_CXX_COMPILER_RANLIB "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ranlib")

# CMake Defaults
set(CMAKE_AR "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ar")
set(CMAKE_LINKER "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ld")
set(CMAKE_NM "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-nm")
set(CMAKE_OBJCOPY "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-objcopy")
set(CMAKE_OBJDUMP "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-objdump")
set(CMAKE_RANLIB "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-ranlib")
set(CMAKE_STRIP "${ARM_LINUX_EABI_ROOT}arm-linux-gnueabihf-strip")

# Postfixes, suffixes, prefixes
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_DEBUG_POSTFIX "_dbg")
set(CMAKE_RELEASE_POSTFIX "_rel")

# Needed for the test program to compile when --configuring
# set(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs" CACHE INTERNAL "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# ====================================================
# Exports
# ====================================================
set(Toolchain::HAS_GCC_ARM_LINUX_EABIHF TRUE CACHE INTERNAL "" FORCE)