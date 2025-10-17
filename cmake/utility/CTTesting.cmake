#------------------------------------------------------------------------------
# CTTesting.cmake - GoogleTest Testing Utilities
#------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.25.0)

#------------------------------------------------------------------------------
# FUNCTION: gen_gtest_executable
#
#   Creates a GoogleTest executable for a set of test source files and
#   automatically registers it with CTest.
#
# INTERFACE:
#   TARGET
#       This is simply the name you want to reference the generated test
#       executable target by.
#
#   SOURCES
#       Test source files to be compiled into the executable
#
#   DEPENDENCIES
#       Targets this test executable depends on
#
#   INCLUDES
#       Include paths needed to build the test module
#
#   DEFINES
#       Preprocessor definitions needed to compile the test module
#
#   LIBRARIES
#       Additional library targets to link against (gtest is automatically linked)
#
#------------------------------------------------------------------------------
function(gen_gtest_executable)
  #----------------------------------------------------------
  # Parse the input arguments
  #----------------------------------------------------------
  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs SOURCES DEPENDENCIES INCLUDES DEFINES LIBRARIES)
  cmake_parse_arguments(GEN_GTEST "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #----------------------------------------------------------
  # Validate required parameters
  #----------------------------------------------------------
  if(NOT GEN_GTEST_TARGET)
    message(FATAL_ERROR "GoogleTest executable generation function requires a TARGET entry")
  endif()

  if(NOT GEN_GTEST_SOURCES)
    message(FATAL_ERROR "GoogleTest executable generation function requires SOURCES entry")
  endif()

  #----------------------------------------------------------
  # Create the executable with the desired properties
  #----------------------------------------------------------
  add_executable(${GEN_GTEST_TARGET} ${GEN_GTEST_SOURCES})

  # Include Paths
  if(GEN_GTEST_INCLUDES)
    target_include_directories(${GEN_GTEST_TARGET} PRIVATE ${GEN_GTEST_INCLUDES})
  endif()

  # Compiler preprocessor definitions
  if(GEN_GTEST_DEFINES)
    target_compile_definitions(${GEN_GTEST_TARGET} PRIVATE ${GEN_GTEST_DEFINES})
  endif()

  # Additional Libraries
  if(GEN_GTEST_LIBRARIES)
    target_link_libraries(${GEN_GTEST_TARGET} PRIVATE ${GEN_GTEST_LIBRARIES})
  endif()

  # Dependencies
  if(GEN_GTEST_DEPENDENCIES)
    add_dependencies(${GEN_GTEST_TARGET} ${GEN_GTEST_DEPENDENCIES})
  endif()

  # Always link against these, which provides the GoogleTest framework
  target_link_libraries(${GEN_GTEST_TARGET} PRIVATE gtest)

  # Always link against these, which defines critical target device compiler options such as the
  # ARM core variant, build flags, FPU support, etc. Every source file in the project MUST be
  # compiled with these in order to build/link properly.
  #
  # See the target device definitions in the CommonTool/cmake/device folders.
  target_link_libraries(${GEN_GTEST_TARGET} PRIVATE prj_device_target prj_build_target)

  #----------------------------------------------------------
  # Register test with CTest for automatic discovery
  #----------------------------------------------------------
  include(GoogleTest)
  gtest_discover_tests(${GEN_GTEST_TARGET}
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    PROPERTIES
      TIMEOUT "60"
      ENVIRONMENT "GTEST_COLOR=1"
  )
endfunction() #gen_gtest_executable
