#------------------------------------------------------------------------------
# Embedded Utilities
#------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.18.0)

#------------------------------------------------------------------------------
# Function: add_elf2bin_dependency
# Adds functionality to create ${target}.bin from ${target}.elf
#------------------------------------------------------------------------------
function(add_elf2bin_dependency target)
  add_custom_target(${target}.bin DEPENDS ${target}.elf)
  add_custom_command(TARGET ${target}.bin
    COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.elf ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.bin)
endfunction()

#------------------------------------------------------------------------------
# Function: add_bin2lst_dependency
# Adds functionality to create ${target}.lst from ${target}.bin
#------------------------------------------------------------------------------
function(add_bin2lst_dependency target)
  add_custom_target(${target}.lst DEPENDS ${target}.bin)
  add_custom_command(TARGET ${target}.lst
    COMMAND ${CMAKE_OBJDUMP} ARGS -D -b binary -marm ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.bin > ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.lst)
endfunction()


#------------------------------------------------------------------------------
# Function: add_target_variants
#
# Creates rel/rel_dbg/dbg variants of a target. The generator func must accept
# a single argument that specifies the build type. Useful for targets that
# want to always build as a certain type.
#
# The promises made by this function (aka builds type <X>) is only held if the
# generator function actually respects this.
#------------------------------------------------------------------------------
function(add_target_variants target_generator_func)
  cmake_language(CALL ${target_generator_func} "")       # This build varies with CMAKE_BUILD_TYPE
  cmake_language(CALL ${target_generator_func} _rel)     # Always project release build
  cmake_language(CALL ${target_generator_func} _rel_dbg) # Always project release with debug options
  cmake_language(CALL ${target_generator_func} _dbg)     # Always project debug build
endfunction()