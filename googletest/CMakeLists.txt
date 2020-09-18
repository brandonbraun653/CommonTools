# ====================================================
#
# ====================================================
add_library(gtest_inc INTERFACE)
target_include_directories(gtest_inc INTERFACE "googletest/googletest/include" "googletest/googletest")
export(TARGETS gtest_inc FILE "${PROJECT_BINARY_DIR}/google/gtest-inc.cmake")


add_library(gtest_src STATIC
  googletest/googletest/src/gtest-death-test.cc
  googletest/googletest/src/gtest-filepath.cc
  googletest/googletest/src/gtest-matchers.cc
  googletest/googletest/src/gtest-port.cc
  googletest/googletest/src/gtest-printers.cc
  googletest/googletest/src/gtest-test-part.cc
  googletest/googletest/src/gtest-typed-test.cc
  googletest/googletest/src/gtest.cc
)
target_link_libraries(gtest_src PRIVATE ${LINK_LIBS} gtest_inc)
export(TARGETS gtest_src FILE "${PROJECT_BINARY_DIR}/google/gtest_src.cmake")


add_library(gtest_main STATIC
  googletest/googletest/src/gtest_main.cc
)
target_link_libraries(gtest_main PRIVATE ${LINK_LIBS} gtest_inc)
export(TARGETS gtest_main FILE "${PROJECT_BINARY_DIR}/google/gtest_main.cmake")