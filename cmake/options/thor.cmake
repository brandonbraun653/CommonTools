# ====================================================
# Device Family Options
# ====================================================
set(THOR_FAMILY "NotSet" CACHE STRING "Selects high level STM32 family type")
set_property(CACHE THOR_FAMILY PROPERTY STRINGS
  F4
  F7
  H7
  L4
  MOCK
  SIM
)

# Validate the device family
get_property(thor_family_allowed_strings CACHE THOR_FAMILY PROPERTY STRINGS)
if(${THOR_FAMILY} IN_LIST thor_family_allowed_strings)
  message("-- Selecting Thor Family: ${THOR_FAMILY}")
else()
  message(FATAL_ERROR "Unknown Thor Family: ${THOR_FAMILY}")
endif()

# ====================================================
# Device Chip Options
# ====================================================
set(THOR_CHIP "NotSet" CACHE STRING "Selects STM32 chip type")
set_property(CACHE THOR_CHIP PROPERTY STRINGS
  F4xx
  F446
  F7xx
  F767
  H7xx
  H743
  L4xx
  L432
  MOCK
  SIM
)

# Validate the chip
get_property(thor_chip_allowed_strings CACHE THOR_CHIP PROPERTY STRINGS)
if(${THOR_CHIP} IN_LIST thor_chip_allowed_strings)
  message("-- Selecting Thor Chip: ${THOR_CHIP}")
else()
  message(FATAL_ERROR "Unknown Thor Chip: ${THOR_CHIP}")
endif()

# ====================================================
# Device Variant Options
# ====================================================
set(THOR_VARIANT "NotSet" CACHE STRING "Selects STM32 variant type")
set_property(CACHE THOR_VARIANT PROPERTY STRINGS
  KB
  KC
  RE
  ZI
  SIM
  MOCK
)

# Validate the variant
get_property(thor_variant_allowed_strings CACHE THOR_VARIANT PROPERTY STRINGS)
if(${THOR_VARIANT} IN_LIST thor_variant_allowed_strings)
  message("-- Selecting Thor Variant: ${THOR_VARIANT}")
else()
  message(FATAL_ERROR "Unknown Thor Variant: ${THOR_VARIANT}")
endif()