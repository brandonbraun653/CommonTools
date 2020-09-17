# =============================================================================
# File:
#   testing_selector.cmake
#
# Description:
#   Common options for configuring build features
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================
# ====================================================
# Validate requirements of this module
# ====================================================
if(NOT TEST_BUILD)
  message(WARNING "Test Build == OFF. Cannot configure test properties.")
endif()

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