# =============================================================================
# Description:
#   Builds an interface target for correctly compiling onto STM32F4xxxx chips.
#
# Exports:
#   prj_build_target
#   prj_device_target
#
# 2021-2023 | Brandon Braun | brandonbraun653@gmail.com
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
# Shared definitions
# ====================================================
target_compile_definitions(${TARGET_OPTIONS} INTERFACE
  STM32F446xx
  TARGET_STM32F4
)

if (${THOR_IMPL} STREQUAL "HW")
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
    -Wall

    -fno-omit-frame-pointer
    #-H

    # Disables "compound assignment with 'volatile'-qualified left operand"
    #   This shows up when compiling source code that modifies hardware registers.
    #   Given that is the point of a lot of embedded things, that's a lot of warnings.
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-volatile>
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
    -specs=nano.specs

    # Link in support for floating point printf
    -lc
    -lrdimon
    -u _printf_float
  )

  target_compile_definitions(${TARGET_OPTIONS} INTERFACE
    EMBEDDED
  )

  # ====================================================
  # Select the linker script for the supported device
  # ====================================================
  if(GENERATE_MAP_FILE)
  target_link_options(${TARGET_OPTIONS} INTERFACE "-Wl,-Map=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_PROJECT_NAME}.map")
  endif()

  set(LINKER_DIR "${COMMON_TOOL_ROOT}/linker_scripts/stm32f4x")
  if(OVERRIDE_LINKER_SCRIPT)
    message(STATUS "Overriding default linker script for STM32F4 device")
  else()
      target_link_options(${TARGET_OPTIONS} INTERFACE "-T${LINKER_DIR}/${DEVICE_TARGET}_flash.lds")
  endif()

else() # THOR_IMPL == SIM
  target_compile_options(${TARGET_OPTIONS} INTERFACE
    -no-pie
  )
endif() # THOR_IMPL == HW

# ====================================================
# Export the target settings so other libs can build
# ====================================================
export(TARGETS ${TARGET_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_OPTIONS}.cmake")
