# ====================================================
# Interface for compiling to an STM32L4 chip
# ====================================================
add_library(prj_device_target INTERFACE)
target_compile_options(prj_device_target INTERFACE
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

target_link_options(prj_device_target INTERFACE
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -mabi=aapcs
  -mcpu=cortex-m4
  -mfloat-abi=hard
  -mfpu=fpv4-sp-d16
  -mthumb
  -specs=nano.specs
  -specs=nosys.specs
)

target_compile_definitions(prj_device_target INTERFACE
  STM32L432xx
  EMBEDDED
  CHIMERA_LITTLE_ENDIAN
  TARGET_STM32L4
)
export(TARGETS prj_device_target FILE "${PROJECT_BINARY_DIR}/DeviceTarget/device-target.cmake")