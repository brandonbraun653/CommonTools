# =============================================================================
# File:
#   threading_selector.cmake
#
# Description:
#   Common options for configuring build features
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
# ====================================================
# Validate requirements of this module
# ====================================================
if(NOT HAS_THREADS)
  message(WARNING "HAS_THREADS == OFF. Cannot configure test properties.")
endif()

# ====================================================
# Native Threads
# ====================================================
option(THREAD_NATIVE "Enables native threading support" OFF)
if(THREAD_NATIVE)
  message(STATUS "Enabled Native Threads")
  set(Toolchain::REQUIRES_THREAD_NATIVE TRUE CACHE INTERNAL "" FORCE)
else()
  set(Toolchain::REQUIRES_THREAD_NATIVE FALSE CACHE INTERNAL "" FORCE)
endif()

# ====================================================
# FreeRTOS Threads
# ====================================================
option(THREAD_FREERTOS "Enables FreeRTOS threading support" OFF)
if(THREAD_FREERTOS)
  message(STATUS "Enabled Native Threads")
  set(Toolchain::REQUIRES_THREAD_FREERTOS TRUE CACHE INTERNAL "" FORCE)
else()
  set(Toolchain::REQUIRES_THREAD_FREERTOS FALSE CACHE INTERNAL "" FORCE)
endif()


# ====================================================
# Both cannot exist
# ====================================================
if(THREAD_FREERTOS AND THREAD_NATIVE)
  message(FATAL_ERROR "Cannot enable both FreeRTOS and Native threads")
endif()