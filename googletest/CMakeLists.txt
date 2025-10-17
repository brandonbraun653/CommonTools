# ====================================================
# GoogleTest Integration with FetchContent
# ====================================================
include(FetchContent)

# Declare GoogleTest
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)

# Make GoogleTest available
FetchContent_MakeAvailable(googletest)

# Set up GoogleTest properties for better CI integration
set_target_properties(gtest gtest_main gmock gmock_main
  PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
