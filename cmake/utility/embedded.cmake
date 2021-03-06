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
  cmake_language(CALL ${target_generator_func} _rel)     # Always project's settings for release build
  cmake_language(CALL ${target_generator_func} _rel_dbg) # Always project's settings for release with debug options
  cmake_language(CALL ${target_generator_func} _dbg)     # Always project's settings for debug build
endfunction()


#------------------------------------------------------------------------------
# FUNCTION: gen_intf_lib
#
#   Generates an interface library. Originaly created to allow larger projects
#   to expose a target that includes all definitions and header file paths
#   needed for a consuming project to integrate with. This way it's a bit
#   easier to manage the dependencies of a project.
#
# INTERFACE:
#   TARGET
#       This is the name you want to reference the generated library by
#
#   INTF_INCLUDES
#       Include paths needed to integrate with the module
#
#   INTF_DEFINES
#       Preprocessor definitions needed to compile the module
#
#   INTF_LIBRARIES
#       A list of all library targets to link against
#
#   EXPORT_DIR
#       Root directory of where to place the resulting generated <xyz>.cmake
#       files. This is so other targets in the project can actually reference
#       the targets generated by this function.
#
#------------------------------------------------------------------------------
function(gen_intf_lib)
  #----------------------------------------------------------
  # Parse the input arguments
  #----------------------------------------------------------
  set(options "")
  set(oneValueArgs TARGET EXPORT_DIR)
  set(multiValueArgs INTF_INCLUDES INTF_DEFINES INTF_LIBRARIES)
  cmake_parse_arguments(GEN_INTF_LIB "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #----------------------------------------------------------
  # Build the library
  #----------------------------------------------------------
  add_library(${GEN_INTF_LIB_TARGET} INTERFACE)

  if(GEN_INTF_LIB_INTF_INCLUDES)
    target_include_directories(${GEN_INTF_LIB_TARGET} INTERFACE ${GEN_INTF_LIB_INTF_INCLUDES})
  endif()

  if(GEN_INTF_LIB_INTF_DEFINES)
    target_compile_definitions(${GEN_INTF_LIB_TARGET} INTERFACE ${GEN_INTF_LIB_INTF_DEFINES})
  endif()

  if(GEN_INTF_LIB_INTF_LIBRARIES)
    target_link_libraries(${GEN_INTF_LIB_TARGET} INTERFACE ${GEN_INTF_LIB_INTF_LIBRARIES})
  endif()

  # Export so other targets can use this
  export(TARGETS ${GEN_INTF_LIB_TARGET} FILE "${GEN_INTF_LIB_EXPORT_DIR}/${GEN_INTF_LIB_TARGET}.cmake")
endfunction()


#------------------------------------------------------------------------------
# FUNCTION: gen_static_lib_variants
#
#   Creates a static library for a set of source files. Additionally generates
#   named build variants of each lib to allow project to easily select what it
#   needs.
#
# INTERFACE:
#   TARGET
#       This is simply the name you want to reference the generated static
#       library target by.
#
#   SOURCES
#       Source files to be compiled into the library
#
#   PRV_INCLUDES
#       Private include paths needed to build the module.
#
#   PRV_DEFINES
#       Preprocessor definitions needed to compile the module. Flagged as
#       private to prevent propagation to upstream dependencies.
#
#   PRV_LIBRARIES
#       A list of all library targets to link against. This is a great way
#       to inject dependencies on other interface libraries for things like
#       header file include paths, compiler settings, etc. Flagged as private
#       to prevent propagation to upstream dependencies.
#
#   EXPORT_DIR
#       Root directory of where to place the resulting generated <xyz>.cmake
#       files. This is so other targets in the project can actually reference
#       the targets generated by this function.
#
#------------------------------------------------------------------------------
function(gen_static_lib_variants)
  #----------------------------------------------------------
  # Parse the input arguments
  #----------------------------------------------------------
  set(options "")
  set(oneValueArgs TARGET EXPORT_DIR)
  set(multiValueArgs SOURCES PRV_DEFINES PRV_LIBRARIES)
  cmake_parse_arguments(GEN_STATIC_LIB_VARIANTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #----------------------------------------------------------
  # Generator function to build a static library
  #----------------------------------------------------------
  function(build_${GEN_STATIC_LIB_VARIANTS_TARGET} VARIANT)
    #----------------------------------------------------------
    # The name your project should reference
    #----------------------------------------------------------
    set(lib_var_name "${GEN_STATIC_LIB_VARIANTS_TARGET}${VARIANT}")
    message("Generating target: ${lib_var_name}")

    #----------------------------------------------------------
    # Create the interface library with the desired properties
    #----------------------------------------------------------
    add_library(${lib_var_name} STATIC ${GEN_STATIC_LIB_VARIANTS_SOURCES})

    # Include Paths
    if(GEN_STATIC_LIB_VARIANTS_PRV_INCLUDES)
      target_include_directories(${lib_var_name} PRIVATE ${GEN_STATIC_LIB_VARIANTS_PRV_INCLUDES})
    endif()

    # Compiler preprocessor definitions
    if(GEN_STATIC_LIB_VARIANTS_PRV_DEFINES)
      target_compile_definitions(${lib_var_name} PRIVATE ${GEN_STATIC_LIB_VARIANTS_PRV_DEFINES})
    endif()

    # Link Libraries
    if(GEN_STATIC_LIB_VARIANTS_PRV_LIBRARIES)
      target_link_libraries(${lib_var_name} PRIVATE ${GEN_STATIC_LIB_VARIANTS_PRV_LIBRARIES})
    endif()

    # Always link against these, which defines critical target device compiler options such as the
    # ARM core variant, build flags, FPU support, etc. Every source file in the project MUST be
    # compiled with these in order to build/link properly.
    #
    # See the target device definitions in the CommonTool/cmake/device folders.
    target_link_libraries(${lib_var_name} PRIVATE prj_device_target prj_build_target${VARIANT})

    # Export so other targets can use this
    export(TARGETS ${lib_var_name} FILE "${GEN_STATIC_LIB_VARIANTS_EXPORT_DIR}/${lib_var_name}.cmake")
  endfunction() # build_${GEN_STATIC_LIB_VARIANTS_TARGET}

  #----------------------------------------------------------
  # Invoke generator function with the desired variant types
  #----------------------------------------------------------
  add_target_variants(build_${GEN_STATIC_LIB_VARIANTS_TARGET})
endfunction() #gen_static_lib_variants


#------------------------------------------------------------------------------
# FUNCTION: gen_intf_lib_variants
#
#   Creates an interface library that is used to collect a group of other libs
#   into a single target for referencing in a project. Additionally generates
#   named build variants of each lib to allow projects to easily select what
#   it needs.
#
# INTERFACE:
#   TARGET
#       This is simply the name you want to reference the generated interface
#       library target by.
#
#   LIBRARIES
#       A list of all library targets in the resulting collection
#
#   EXPORT_DIR
#       Root directory of where to place the resulting generated <xyz>.cmake
#       files. This is so other targets in the project can actually reference
#       the targets generated by this function.
#
# REQUIREMENTS:
#   All librarys in the LIBS argument must have generated named variants as
#   well, or else the function won't know what to reference.
#------------------------------------------------------------------------------
function(gen_intf_lib_variants)
  #----------------------------------------------------------
  # Parse the input arguments
  #----------------------------------------------------------
  set(options "")
  set(oneValueArgs TARGET EXPORT_DIR)
  set(multiValueArgs LIBRARIES)
  cmake_parse_arguments(GEN_INTF_LIB_VARIANTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #----------------------------------------------------------
  # Generator function to build an interface library
  #----------------------------------------------------------
  function(build_${GEN_INTF_LIB_VARIANTS_TARGET} VARIANT)
    #----------------------------------------------------------
    # The name your project should reference
    #----------------------------------------------------------
    set(lib_var_name "${GEN_INTF_LIB_VARIANTS_TARGET}${VARIANT}")
    message("Generating target: ${lib_var_name}")

    #----------------------------------------------------------
    # Add the variant flag to each library target
    #----------------------------------------------------------
    set(renamed_libs${VARIANT} "")
    foreach(library ${GEN_INTF_LIB_VARIANTS_LIBRARIES})
      list(APPEND renamed_libs${VARIANT} ${library}${VARIANT})
    endforeach()

    #----------------------------------------------------------
    # Create the interface library with the desired properties
    #----------------------------------------------------------
    add_library(${lib_var_name} INTERFACE)
    target_link_libraries(${lib_var_name} INTERFACE "${renamed_libs${VARIANT}}")
    export(TARGETS ${lib_var_name} FILE "${GEN_INTF_LIB_VARIANTS_EXPORT_DIR}/${lib_var_name}.cmake")
  endfunction()

  #----------------------------------------------------------
  # Invoke generator function with the desired variant types
  #----------------------------------------------------------
  add_target_variants(build_${GEN_INTF_LIB_VARIANTS_TARGET})
endfunction() #gen_intf_lib_variants
