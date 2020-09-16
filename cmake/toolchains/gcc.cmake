# ====================================================
# Eexpects the user to have defined GCC_BIN_ROOT either
# in the CMakeLists.txt or in Environment Variables
# ====================================================
# C Compiler
set(CMAKE_C_COMPILER "${GCC_BIN_ROOT}/gcc")
set(CMAKE_C_COMPILER_AR "${GCC_BIN_ROOT}/ar")
set(CMAKE_C_COMPILER_RANLIB "${GCC_BIN_ROOT}/ranlib")

# C++ Compiler
set(CMAKE_CXX_COMPILER "${GCC_BIN_ROOT}/g++")
set(CMAKE_CXX_COMPILER_AR "${GCC_BIN_ROOT}/ar")
set(CMAKE_CXX_COMPILER_RANLIB "${GCC_BIN_ROOT}/ranlib")

# CMake Defaults
set(CMAKE_AR "${GCC_BIN_ROOT}/ar")
set(CMAKE_LINKER "${GCC_BIN_ROOT}/ld")
set(CMAKE_NM "${GCC_BIN_ROOT}/nm")
set(CMAKE_OBJCOPY "${GCC_BIN_ROOT}/objcopy")
set(CMAKE_OBJDUMP "${GCC_BIN_ROOT}/objdump")
set(CMAKE_RANLIB "${GCC_BIN_ROOT}/ranlib")
set(CMAKE_STRIP "${GCC_BIN_ROOT}/strip")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)