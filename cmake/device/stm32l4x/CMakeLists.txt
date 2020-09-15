# ====================================================
# Interface for compiling to an STM32L4 chip
# ====================================================
set(TARGET_CHIP prj_device_target)
add_library(${TARGET_CHIP} INTERFACE)
target_compile_options(${TARGET_CHIP} INTERFACE
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
)

target_link_options(${TARGET_CHIP} INTERFACE
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -mabi=aapcs
  -mcpu=cortex-m4
  -mfloat-abi=hard
  -mfpu=fpv4-sp-d16
  -mthumb
  -specs=nano.specs
  #-specs=nosys.specs
)

target_compile_definitions(${TARGET_CHIP} INTERFACE
  STM32L432xx
  EMBEDDED
  CHIMERA_LITTLE_ENDIAN
  TARGET_STM32L4
)

if(OVERRIDE_LINKER_SCRIPT)
  message(STATUS "Overriding default linker script for STM32L4 device")
else()
  # Eventually will need to filter based on the full chip name, but for now this is ok
  if(${THOR_VARIANT} MATCHES "^KB$")
    target_link_options(${TARGET_CHIP} INTERFACE "-T${LINKER_DIR}/STM32L432KB_flash.lds")
  elseif(${THOR_VARIANT} MATCHES "^KC$")
    target_link_options(${TARGET_CHIP} INTERFACE "-T${LINKER_DIR}/STM32L432KC_flash.lds")
  else()
    message(FATAL_ERROR "No custom linker script defined for this chip!")
  endif() # Linker script selector
endif() # Override linker script

export(TARGETS ${TARGET_CHIP} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_CHIP}.cmake")
