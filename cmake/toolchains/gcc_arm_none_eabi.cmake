set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# C Compiler
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_C_COMPILER_AR "arm-none-eabi-ar")
set(CMAKE_C_COMPILER_RANLIB "arm-none-eabi-ranlib")

# C++ Compiler
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(CMAKE_CXX_COMPILER_AR "arm-none-eabi-ar")
set(CMAKE_CXX_COMPILER_RANLIB "arm-none-eabi-ranlib")

# CMake Defaults
set(CMAKE_AR "arm-none-eabi-ar")
set(CMAKE_LINKER "arm-none-eabi-ld")
set(CMAKE_NM "arm-none-eabi-nm")
set(CMAKE_OBJCOPY "arm-none-eabi-objcopy")
set(CMAKE_OBJDUMP "arm-none-eabi-objdump")
set(CMAKE_RANLIB "arm-none-eabi-ranlib")
set(CMAKE_STRIP "arm-none-eabi-strip")

set(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs" CACHE INTERNAL "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)