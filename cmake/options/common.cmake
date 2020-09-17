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

# ====================================================
# Testing
# ====================================================
option(TEST_BUILD "Enables/disables test frameworks" OFF)
if(TEST_BUILD)
  include("${COMMON_TOOL_ROOT}/cmake/testing/testing_selector.cmake")
endif()

# ====================================================
# Threading
# ====================================================
option(HAS_THREADS "Enables/disables threading support" OFF)
if(HAS_THREADS)
  include("${COMMON_TOOL_ROOT}/cmake/threading/threading_selector.cmake")
endif()