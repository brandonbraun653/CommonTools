# =============================================================================
# File: PreLoad.cmake
#
# Description:
#   Placing this file in the project root directory will cause CMake to load
#   it before anything else. This is useful when you want to build using the
#   command line and expect a default configuration to simply work.
# =============================================================================
# Configure the output generator type
set(CMAKE_GENERATOR "Unix Makefiles" CACHE INTERNAL "" FORCE)

# Configure which toolchain file to use
set(CMAKE_TOOLCHAIN_FILE "lib/CommonTools/cmake/toolchains/gcc_arm_none_eabi.cmake" CACHE INTERNAL "" FORCE)

# Where to install things
set(PRJ_INSTALL_PREFIX "build" CACHE INTERNAL "" FORCE)

# Prevent cluttering of the project directory with build files
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/artifacts/lib CACHE INTERNAL "" FORCE)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/artifacts/lib CACHE INTERNAL "" FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build/bin CACHE INTERNAL "" FORCE)