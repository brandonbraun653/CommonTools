# =============================================================================
# Description:
#   Builds an interface target for correctly compiling on a generic PC.
#
# Exports:
#   prj_build_target
#   prj_device_target
#
# 2020-2021 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================

# =============================================================================
# Project Build Target:
# Exports build settings that can be applied to other targets
# =============================================================================
# Only release build options
set(BUILD_OPTIONS_REL prj_build_target_rel)
add_library(${BUILD_OPTIONS_REL} INTERFACE)
target_compile_definitions(${BUILD_OPTIONS_REL} INTERFACE "RELEASE")
target_compile_options(${BUILD_OPTIONS_REL} INTERFACE -Os -g0)
export(TARGETS ${BUILD_OPTIONS_REL} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_REL}.cmake")

# Only release with debug build options
set(BUILD_OPTIONS_REL_DBG prj_build_target_rel_dbg)
add_library(${BUILD_OPTIONS_REL_DBG} INTERFACE)
target_compile_definitions(${BUILD_OPTIONS_REL_DBG} INTERFACE "DBG_REL" "REL_DBG")
target_compile_options(${BUILD_OPTIONS_REL_DBG} INTERFACE -O2 -g3 -ggdb)
export(TARGETS ${BUILD_OPTIONS_REL_DBG} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_REL_DBG}.cmake")

# Only debug build options
set(BUILD_OPTIONS_DBG prj_build_target_dbg)
add_library(${BUILD_OPTIONS_DBG} INTERFACE)
target_compile_definitions(${BUILD_OPTIONS_DBG} INTERFACE "DEBUG")
target_compile_options(${BUILD_OPTIONS_DBG} INTERFACE -O0 -g3 -ggdb)
export(TARGETS ${BUILD_OPTIONS_DBG} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_DBG}.cmake")

# High level target that switches based on rel/dbg configuration
set(BUILD_OPTIONS prj_build_target)
add_library(${BUILD_OPTIONS} INTERFACE)
target_link_libraries(${BUILD_OPTIONS} INTERFACE $<$<CONFIG:DEBUG>:${BUILD_OPTIONS_DBG}> $<$<CONFIG:RELEASE>:${BUILD_OPTIONS_REL}>)
export(TARGETS ${BUILD_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS}.cmake")


# =============================================================================
# Project Device Target:
# Exports architectural settings required for the device hardware
# =============================================================================
# ====================================================
# Exported target
# ====================================================
set(TARGET_OPTIONS prj_device_target)
add_library(${TARGET_OPTIONS} INTERFACE)

# ====================================================
# Shared compiler options
# ====================================================
target_compile_options(${TARGET_OPTIONS} INTERFACE
  -fdata-sections
  -ffunction-sections
  -fmessage-length=0
  -fno-common
  -m64
)

if(COVERAGE)
  target_compile_options(${TARGET_OPTIONS} INTERFACE --coverage)
endif()


if(ASAN)
  target_compile_options(${TARGET_OPTIONS} INTERFACE
    -fsanitize=address
    -fno-omit-frame-pointer
    -Wno-format-security
  )
endif()

# ====================================================
# Shared linker options
# ====================================================
target_link_options(${TARGET_OPTIONS} INTERFACE
  -Wl,--gc-sections
  -Wl,--start-group
)

if(ASAN)
  target_link_options(${TARGET_OPTIONS} INTERFACE -fsanitize=address )
endif()

if(COVERAGE)
  target_link_options(${TARGET_OPTIONS} INTERFACE --coverage)
endif()

if(GTEST)
  target_link_libraries(${TARGET_OPTIONS} INTERFACE GTest::gmock GTest::gtest)
endif()

# ====================================================
# Shared definitions
# ====================================================
target_compile_definitions(${TARGET_OPTIONS} INTERFACE
  SIMULATOR
  CHIMERA_SIMULATOR
  WIN32_LEAN_AND_MEAN
)

if(NATIVE_THREADS)
  target_compile_definitions(${TARGET_OPTIONS} INTERFACE USING_NATIVE_THREADS)
  target_link_libraries(${TARGET_OPTIONS} INTERFACE pthread)
endif()

# ====================================================
# Export the target settings so other libs can build
# ====================================================
export(TARGETS ${TARGET_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_OPTIONS}.cmake")
