#------------------------------------------------------------------------------
# Embedded Utilities
#------------------------------------------------------------------------------

#------------------------------------------------
# Function: add_elf2bin_dependency
# Adds functionality to create ${target}.bin from ${target}.elf
#------------------------------------------------
function(add_elf2bin_dependency target)
  add_custom_target(${target}.bin DEPENDS ${target}.elf)
  add_custom_command(TARGET ${target}.bin
    COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.elf ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.bin)
endfunction()

#------------------------------------------------
# Function: add_bin2lst_dependency
# Adds functionality to create ${target}.lst from ${target}.bin
#------------------------------------------------
function(add_bin2lst_dependency target)
  add_custom_target(${target}.lst DEPENDS ${target}.bin)
  add_custom_command(TARGET ${target}.lst
    COMMAND ${CMAKE_OBJDUMP} ARGS -D -b binary -marm ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.bin > ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target}.lst)
endfunction()