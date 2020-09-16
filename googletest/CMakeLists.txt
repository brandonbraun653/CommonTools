# ====================================================
#
# ====================================================
add_library(gtest_inc INTERFACE)
target_include_directories(gtest_inc INTERFACE "googletest/googletest/include" "googletest/googletest")
export(TARGETS gtest_inc FILE "${PROJECT_BINARY_DIR}/google/gtest-inc.cmake")


add_library(gtest STATIC
  googletest/googletest/src/gtest-death-test.cc
  googletest/googletest/src/gtest-filepath.cc
  googletest/googletest/src/gtest-matchers.cc
  googletest/googletest/src/gtest-port.cc
  googletest/googletest/src/gtest-printers.cc
  googletest/googletest/src/gtest-test-part.cc
  googletest/googletest/src/gtest-typed-test.cc
  googletest/googletest/src/gtest.cc
)
target_link_libraries(gtest PRIVATE ${LINK_LIBS} gtest_inc)
export(TARGETS gtest FILE "${PROJECT_BINARY_DIR}/google/gtest.cmake")