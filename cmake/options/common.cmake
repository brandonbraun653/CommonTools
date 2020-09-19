# =============================================================================
# File:
#   common.cmake
#
# Description:
#   Common options for configuring build features
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
# ====================================================
# Validate requirements of this module
# ====================================================
if(NOT COMMON_TOOL_ROOT)
message(FATAL_ERROR "Path to the CommonTool root must be defined")
endif()

# ====================================================
# Coverage Builds
# ====================================================
option(COVERAGE_BUILD "Enables/disables coverage generation" OFF)

# ===================================================================
# Testing
# ===================================================================
# ====================================================
# GTest
# ====================================================
option(GTEST "Enables GTest support" OFF)
if(GTEST)
  message(STATUS "Enabled GTest")
  set(Testing::REQUIRES_GTEST TRUE CACHE INTERNAL "" FORCE)
else()
  set(Testing::REQUIRES_GTEST FALSE CACHE INTERNAL "" FORCE)
endif()

# ====================================================
# GMock
# ====================================================
option(GMOCK "Enables GMock support" OFF)
if(GMOCK)
  message(STATUS "Enabled GMock")
  set(Testing::REQUIRES_GMOCK TRUE CACHE INTERNAL "" FORCE)
else()
  set(Testing::REQUIRES_GMOCK FALSE CACHE INTERNAL "" FORCE)
endif()

# ====================================================
# CppUTest
# ====================================================
option(CPPUTEST "Enabled CppUTest support" OFF)
if(CPPUTEST)
  message(STATUS "Enabled CppUTest")
  set(Testing::REQUIRES_CPPUTEST TRUE CACHE INTERNAL "" FORCE)
else()
  set(Testing::REQUIRES_CPPUTEST FALSE CACHE INTERNAL "" FORCE)
endif()

# ===================================================================
# Threading
# ===================================================================
# ====================================================
# Native Threads
# ====================================================
option(NATIVE_THREADS "Enables native threading support" OFF)
if(NATIVE_THREADS)
  message(STATUS "Enabled Native Threads")
  set(Toolchain::REQUIRES_NATIVE_THREADS TRUE CACHE INTERNAL "" FORCE)
else()
  set(Toolchain::REQUIRES_NATIVE_THREADS FALSE CACHE INTERNAL "" FORCE)
endif()

# ====================================================
# FreeRTOS Threads
# ====================================================
option(FREERTOS_THREADS "Enables FreeRTOS threading support" OFF)
if(FREERTOS_THREADS OR LIB_FREERTOS)
  message(STATUS "Enabled FreeRTOS Threads")
  set(Toolchain::REQUIRES_FREERTOS_THREADS TRUE CACHE INTERNAL "" FORCE)

  # Enable for sanity as this could execute due to LIB_FREERTOS==ON
  set(FREERTOS_THREADS ON)
else()
  set(Toolchain::REQUIRES_FREERTOS_THREADS FALSE CACHE INTERNAL "" FORCE)
endif()


# ====================================================
# Both cannot exist
# ====================================================
if(FREERTOS_THREADS AND NATIVE_THREADS)
  message(FATAL_ERROR "Cannot enable both FreeRTOS and Native threads")
endif()