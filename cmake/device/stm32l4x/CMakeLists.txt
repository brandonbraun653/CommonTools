# =============================================================================
# Description:
#   Builds an interface target for correctly compiling onto STM32L4xxxx chips.
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

# Only release with debug build options
set(BUILD_OPTIONS_DBG prj_build_target_rel_dbg)
add_library(${BUILD_OPTIONS_DBG} INTERFACE)
target_compile_options(${BUILD_OPTIONS_DBG} INTERFACE -O2 -g3 -ggdb)
export(TARGETS ${BUILD_OPTIONS_DBG} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${BUILD_OPTIONS_DBG}.cmake")

# Only debug build options
set(BUILD_OPTIONS_DBG prj_build_target_dbg)
add_library(${BUILD_OPTIONS_DBG} INTERFACE)
target_compile_options(${BUILD_OPTIONS_DBG} INTERFACE -Og -g3 -ggdb)
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
  -mcpu=cortex-m4
  -mfloat-abi=hard
  -mfpu=fpv4-sp-d16
  -mthumb
)

# ====================================================
# Shared linker options
# ====================================================
target_link_options(${TARGET_OPTIONS} INTERFACE
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -mabi=aapcs
  -mcpu=cortex-m4
  -mfloat-abi=hard
  -mfpu=fpv4-sp-d16
  -mthumb
  -specs=nano.specs
)

# ====================================================
# Shared definitions
# ====================================================
target_compile_definitions(${TARGET_OPTIONS} INTERFACE
  STM32L432xx
  EMBEDDED
  CHIMERA_LITTLE_ENDIAN
  TARGET_STM32L4
)

# ====================================================
# Select the linker script for the supported device
# ====================================================
target_link_options(${TARGET_OPTIONS} INTERFACE "-Wl,-Map=${LAST_BUILT_VERSION_DIRECTORY}/${CMAKE_PROJECT_NAME}.map")

set(LINKER_DIR "${COMMON_TOOL_ROOT}/linker_scripts/stm32l4x")
if(OVERRIDE_LINKER_SCRIPT)
  message(STATUS "Overriding default linker script for STM32L4 device")
else()
    target_link_options(${TARGET_OPTIONS} INTERFACE "-T${LINKER_DIR}/${DEVICE_TARGET}_flash.lds")
endif()

# ====================================================
# Export the target settings so other libs can build
# ====================================================
export(TARGETS ${TARGET_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_OPTIONS}.cmake")
