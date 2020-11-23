# =============================================================================
# Description:
#   Builds an interface target for correctly compiling onto AM335x chips.
#
# Exports:
#   prj_build_target
#   prj_device_target
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
# =============================================================================

# =============================================================================
# Project Build Target:
# Exports build settings that can be applied to other targets
# =============================================================================
# Only release build options
set(BUILD_OPTIONS_REL prj_build_target_rel)
add_library(${BUILD_OPTIONS_REL} INTERFACE)
target_compile_options(${BUILD_OPTIONS_REL} INTERFACE -Os -g0)
export(TARGETS ${BUILD_OPTIONS_REL} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_REL}.cmake")

# Only debug build options
set(BUILD_OPTIONS_DBG prj_build_target_dbg)
add_library(${BUILD_OPTIONS_DBG} INTERFACE)
target_compile_options(${BUILD_OPTIONS_DBG} INTERFACE -O0 -g3 -ggdb)
export(TARGETS ${BUILD_OPTIONS_DBG} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_DBG}.cmake")

# High level target that switches based on rel/dbg configuration
set(BUILD_OPTIONS prj_build_target)
add_library(${BUILD_OPTIONS} INTERFACE)
target_compile_options(${BUILD_OPTIONS} INTERFACE $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>)
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
  -fno-exceptions
  -mcpu=cortex-a8
  -mfloat-abi=hard
  -mtune=cortex-a8
  -mfpu=vfpv3
  -marm
)

# ====================================================
# Shared linker options
# ====================================================
target_link_options(${TARGET_OPTIONS} INTERFACE
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -mabi=aapcs
  -mcpu=cortex-a8
  -mfloat-abi=hard
  -mtune=cortex-a8
  -mfpu=vfpv3
  -marm
)

# ====================================================
# Shared definitions
# ====================================================
target_compile_definitions(${TARGET_OPTIONS} INTERFACE
)

# ====================================================
# Export the target settings so other libs can build
# ====================================================
export(TARGETS ${TARGET_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_OPTIONS}.cmake")
