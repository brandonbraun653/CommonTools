# =============================================================================
# Description:
#   Builds an interface target for correctly compiling onto STM32L4xxxx chips.
#
# Exports:
#   prj_device_target
#
# 2020 | Brandon Braun | brandonbraun653@gmail.com
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
  $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
  $<$<CONFIG:DEBUG>:-O1;-g3;-ggdb>
  $<$<CONFIG:RELEASE>:-Os;-g0;>
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
