# =============================================================================
# Description:
#   Builds an interface target for correctly compiling onto AM335x chips.
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
#
# -f Options:
#   data-sections:            Splits data into own ELF sections for improved optimization
#   freestanding:             Implies no standard library and entry may not be at main
#   function-sections:        Same as data sections, but for functions
#   no-common:                Ensure each global declaration occurs only once
#   no-exceptions:            Disable exceptions
#   stack-protector-strong:   Emits guards for functions that allocate on the stack
#
# -m Options:
#   arch=armv7-a:             AM335x uses the ARMv7-a architecture
#   tune=cortex-a8:           CPU core type to tune for
#   float-abi=hard            Creates hardware FPU instructions for math
#   fpu=vfpv3                 FPU hardware revision on the processor
# ====================================================
target_compile_options(${TARGET_OPTIONS} INTERFACE
  -fdata-sections
  -ffreestanding
  -ffunction-sections
  -fno-common
  -fno-exceptions
  -fstack-protector-strong
  -march=armv7-a
  -mfloat-abi=hard
  -mfpu=vfpv3
  -mtune=cortex-a8
  -Wall
  -Wextra

  # Disables "compound assignment with 'volatile'-qualified left operand"
  #   This shows up when compiling source code that modifies hardware registers.
  #   Given that is the point of a lot of embedded things, that's a lot of warnings.
  -Wno-volatile
)

# ====================================================
# Shared linker options
# ====================================================
target_link_options(${TARGET_OPTIONS} INTERFACE
  -Wl,--gc-sections
  -Wl,--print-memory-usage
  -mabi=aapcs
  -march=armv7-a
  -mfloat-abi=hard
  -mfpu=vfpv3
  -mtune=cortex-a8
  -specs=nano.specs
)

# ====================================================
# Shared definitions
# ====================================================
#target_compile_definitions(${TARGET_OPTIONS} INTERFACE)

# ====================================================
# Export the target settings so other libs can build
# ====================================================
export(TARGETS ${TARGET_OPTIONS} FILE "${PROJECT_BINARY_DIR}/DeviceTarget/${TARGET_OPTIONS}.cmake")
