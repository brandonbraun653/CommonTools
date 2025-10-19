# =============================================================================
# Developer Tools Integration
# =============================================================================

include(CMakeParseArguments)

# =============================================================================
# Function: add_clang_format_target
# Adds a target to format code with clang-format
# =============================================================================
function(add_clang_format_target)
  set(options "")
  set(oneValueArgs TARGET_NAME)
  set(multiValueArgs FILES)
  cmake_parse_arguments(CF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT CF_TARGET_NAME)
    set(CF_TARGET_NAME "clang-format")
  endif()

  find_program(CLANG_FORMAT_EXE clang-format)
  if(NOT CLANG_FORMAT_EXE)
    message(STATUS "clang-format not found, skipping format target")
    return()
  endif()

  add_custom_target(${CF_TARGET_NAME}
    COMMAND ${CLANG_FORMAT_EXE} -i ${CF_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Formatting source files with clang-format"
    VERBATIM
  )

  # Add check format target
  add_custom_target(${CF_TARGET_NAME}-check
    COMMAND ${CLANG_FORMAT_EXE} --dry-run --Werror ${CF_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Checking source file formatting with clang-format"
    VERBATIM
  )
endfunction()

# =============================================================================
# Function: add_clang_tidy_target
# Adds a target to analyze code with clang-tidy
# =============================================================================
function(add_clang_tidy_target)
  set(options "")
  set(oneValueArgs TARGET_NAME)
  set(multiValueArgs FILES)
  cmake_parse_arguments(CT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT CT_TARGET_NAME)
    set(CT_TARGET_NAME "clang-tidy")
  endif()

  find_program(CLANG_TIDY_EXE clang-tidy)
  if(NOT CLANG_TIDY_EXE)
    message(STATUS "clang-tidy not found, skipping tidy target")
    return()
  endif()

  # Get compile commands for clang-tidy
  if(CMAKE_EXPORT_COMPILE_COMMANDS)
    set(COMPILE_COMMANDS_ARG "--compile-commands-dir=${CMAKE_BINARY_DIR}")
  endif()

  add_custom_target(${CT_TARGET_NAME}
    COMMAND ${CLANG_TIDY_EXE} ${COMPILE_COMMANDS_ARG} ${CT_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Analyzing source files with clang-tidy"
    VERBATIM
  )

  # Add fix target
  add_custom_target(${CT_TARGET_NAME}-fix
    COMMAND ${CLANG_TIDY_EXE} ${COMPILER_COMMANDS_ARG} --fix ${CT_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Fixing source files with clang-tidy"
    VERBATIM
  )
endfunction()

# =============================================================================
# Function: add_cppcheck_target
# Adds a target to analyze code with cppcheck
# =============================================================================
function(add_cppcheck_target)
  set(options "")
  set(oneValueArgs TARGET_NAME)
  set(multiValueArgs FILES INCLUDE_DIRS)
  cmake_parse_arguments(CP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT CP_TARGET_NAME)
    set(CP_TARGET_NAME "cppcheck")
  endif()

  find_program(CPPCHECK_EXE cppcheck)
  if(NOT CPPCHECK_EXE)
    message(STATUS "cppcheck not found, skipping cppcheck target")
    return()
  endif()

  # Build include arguments
  set(INCLUDE_ARGS "")
  foreach(inc ${CP_INCLUDE_DIRS})
    list(APPEND INCLUDE_ARGS "-I${inc}")
  endforeach()

  add_custom_target(${CP_TARGET_NAME}
    COMMAND ${CPPCHECK_EXE}
      --enable=all
      --std=c++20
      --language=c++
      --platform=unix64
      --suppress=missingIncludeSystem
      --suppress=unusedFunction
      --suppress=unmatchedSuppression
      --inline-suppr
      --error-exitcode=1
      ${INCLUDE_ARGS}
      ${CP_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Analyzing source files with cppcheck"
    VERBATIM
  )
endfunction()

# =============================================================================
# Function: add_developer_targets
# Convenience function to add all developer tools
# =============================================================================
function(add_developer_targets)
  set(options "")
  set(oneValueArgs "")
  set(multiValueArgs SOURCE_FILES INCLUDE_DIRS)
  cmake_parse_arguments(DT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Add individual tool targets
  add_clang_format_target(FILES ${DT_SOURCE_FILES})
  add_clang_tidy_target(FILES ${DT_SOURCE_FILES})
  add_cppcheck_target(FILES ${DT_SOURCE_FILES} INCLUDE_DIRS ${DT_INCLUDE_DIRS})

  # Add combined target
  add_custom_target(developer-tools
    DEPENDS clang-format-check clang-tidy cppcheck
    COMMENT "Running all developer tools (format check, tidy, cppcheck)"
  )

  # Add documentation target if Doxygen is available
  find_package(Doxygen)
  if(DOXYGEN_FOUND)
    add_custom_target(docs
      COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_SOURCE_DIR}/doc/doxygen/Doxyfile
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      COMMENT "Generating documentation with Doxygen"
      VERBATIM
    )
  endif()
endfunction()

# =============================================================================
# Function: collect_source_files
# Recursively collects source files for tooling
# =============================================================================
function(collect_source_files RESULT_VAR)
  set(options RECURSIVE)
  set(oneValueArgs BASE_DIR)
  set(multiValueArgs EXTENSIONS EXCLUDE_PATTERNS)
  cmake_parse_arguments(CSF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT CSF_BASE_DIR)
    set(CSF_BASE_DIR "${CMAKE_SOURCE_DIR}")
  endif()

  if(NOT CSF_EXTENSIONS)
    set(CSF_EXTENSIONS "*.cpp" "*.hpp" "*.h" "*.cc" "*.cxx")
  endif()

  set(SOURCE_FILES "")

  foreach(ext ${CSF_EXTENSIONS})
    if(CSF_RECURSIVE)
      file(GLOB_RECURSE files "${CSF_BASE_DIR}/${ext}")
    else()
      file(GLOB files "${CSF_BASE_DIR}/${ext}")
    endif()

    list(APPEND SOURCE_FILES ${files})
  endforeach()

  # Remove excluded patterns
  if(CSF_EXCLUDE_PATTERNS)
    foreach(pattern ${CSF_EXCLUDE_PATTERNS})
      list(FILTER SOURCE_FILES EXCLUDE REGEX "${pattern}")
    endforeach()
  endif()

  set(${RESULT_VAR} ${SOURCE_FILES} PARENT_SCOPE)
endfunction()
