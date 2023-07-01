
# ====================================================
# Target device
# ====================================================
set(_BAD_CHIP "XXXXXXXXXXX")
set(SUPPORTED_CHIPS
  STM32L432KB
  STM32L432KC
  STM32F446RE
)

#
set(EMBEDDED_TARGET
  FULL  # Selects both HLD & LLD embedded drivers
  HLD   # Selects only the HLD driver
  LLD   # Selects only the LLD driver
)

set(VIRTUAL_TARGET "SIM" CACHE STRING ""
  SIM        # Simulates
  MOCK
  HLD_SIM
  HLD_MOCK
  LLD_SIM
  LLD_MOCK
)

# ====================================================
# Regex matchers for parsing the device string
# ====================================================
# Grabs the STM32 part of STM32L432KC
set(_DEV_REGEX "^(STM32)[A-Z][0-9]+[A-Z]+$")

# Grabs the L4 part of STM32L432KC
set(_FAMILY_REGEX "^STM32([A-Z][0-9])[0-9A-Z]+$")

# Grabs the L432 part of STM32L432KC
set(_CHIP_REGEX "^STM32([A-Z][0-9]+)[A-Z]+$")

# Grabs the KC part of STM32L432KC
set(_VARIANT_REGEX "^STM32[A-Z][0-9]+([A-Z]+)$")


# ====================================================
# Known options for the STM32 regex matching pieces.
# Defaults to simulated as an unknown literal device
# must mean it's somehow virtualized. If user's chip
# exists, these will be populated appropriately.
# ====================================================
set(THOR_FAMILY "SIM" CACHE STRING "Detected STM32 family type")
set_property(CACHE THOR_FAMILY PROPERTY STRINGS
  F4
  F7
  H7
  L4
)

set(THOR_CHIP "SIM" CACHE STRING "Detected STM32 chip type")
set_property(CACHE THOR_CHIP PROPERTY STRINGS
  F446
  F767
  H743
  L432
)

set(THOR_VARIANT "SIM" CACHE STRING "Detected STM32 variant type")
set_property(CACHE THOR_VARIANT PROPERTY STRINGS
  KB
  KC
  RE
  ZI
)

set(THOR_IMPL "SIM" CACHE STRING "Detected STM32 implementation type")
set_property(CACHE THOR_IMPL PROPERTY STRINGS
  SIM
  HW
)

# ====================================================
# Sanitize the user's device input
# ====================================================
if(NOT DEVICE_TARGET)
  set(DEVICE_TARGET "" CACHE STRING "Thor target device")
else()
  string(TOUPPER "${DEVICE_TARGET}" DEVICE_TARGET)
endif()

# ====================================================
# Parse the string for available device targets
# ====================================================
if(${DEVICE_TARGET} MATCHES ${_DEV_REGEX})
  # ====================================================
  # Make sure the explicit device exists
  # ====================================================
  if(NOT ${DEVICE_TARGET} IN_LIST SUPPORTED_CHIPS)
    message(STATUS "Chip ${DEVICE_TARGET} isn't in supported device list")
  endif()

  # ====================================================
  # Validate the device family
  # ====================================================
  if(${DEVICE_TARGET} MATCHES ${_FAMILY_REGEX})
    set(THOR_FAMILY ${CMAKE_MATCH_1})
  endif()

  get_property(thor_family_allowed_strings CACHE THOR_FAMILY PROPERTY STRINGS)
  if(NOT ${THOR_FAMILY} IN_LIST thor_family_allowed_strings)
    message(FATAL_ERROR "Unknown Thor Family: ${THOR_FAMILY}")
  endif()

  # ====================================================
  # Validate the chip
  # ====================================================
  if(${DEVICE_TARGET} MATCHES ${_CHIP_REGEX})
    set(THOR_CHIP ${CMAKE_MATCH_1})
  endif()

  get_property(thor_chip_allowed_strings CACHE THOR_CHIP PROPERTY STRINGS)
  if(NOT ${THOR_CHIP} IN_LIST thor_chip_allowed_strings)
    message(FATAL_ERROR "Unknown Thor Chip: ${THOR_CHIP}")
  endif()

  # ====================================================
  # Validate the variant
  # ====================================================
  if(${DEVICE_TARGET} MATCHES ${_VARIANT_REGEX})
    set(THOR_VARIANT ${CMAKE_MATCH_1})
  endif()

  get_property(thor_variant_allowed_strings CACHE THOR_VARIANT PROPERTY STRINGS)
  if(NOT ${THOR_VARIANT} IN_LIST thor_variant_allowed_strings)
    message(FATAL_ERROR "Unknown Thor Variant: ${THOR_VARIANT}")
  endif()

  # ====================================================
  # A nice success message. Yay! Set a few config vars.
  # ====================================================
  message(STATUS "Target device ${DEVICE_TARGET} supported")
  set(Thor::Embedded TRUE CACHE INTERNAL "Whether or not Thor will run on an embedded device" FORCE)

  # ====================================================
  # Pull in the device target compiler/linker options
  # ====================================================
  if(${THOR_FAMILY} MATCHES "^L4$")
    add_subdirectory("${COMMON_TOOL_ROOT}/cmake/device/stm32l4x" ${PROJECT_BINARY_DIR}/DeviceTarget)
  elseif(${THOR_FAMILY} MATCHES "^F4$")
    add_subdirectory("${COMMON_TOOL_ROOT}/cmake/device/stm32f4x" ${PROJECT_BINARY_DIR}/DeviceTarget)
  else()
    # Add more here
  endif()
else() # Are some kind of simulated device
  message(STATUS "Using simulated Thor device support")
  add_subdirectory("${COMMON_TOOL_ROOT}/cmake/device/generic" ${PROJECT_BINARY_DIR}/DeviceTarget)
endif()


