option(LIB_FREERTOS "Enable/disable FreeRTOS support" OFF)


if(LIB_FREERTOS)
  # ====================================================
  # Heap Selections
  # ====================================================
  set(FREERTOS_HEAP "heap4" CACHE STRING "Selects the FreeRTOS heap")
  set_property(CACHE FREERTOS_HEAP PROPERTY STRINGS
    heap1
    heap2
    heap3
    heap4
    heap5
  )

  # Validate the heap selection
  get_property(allowed_heaps CACHE FREERTOS_HEAP PROPERTY STRINGS)
  if(NOT ${FREERTOS_HEAP} IN_LIST allowed_heaps)
    message(FATAL_ERROR "Unknown FreeRTOS Heap: ${FREERTOS_HEAP}")
  endif()

  # ====================================================
  # Port Selections
  # ====================================================
  set(FREERTOS_PORT "Posix" CACHE STRING "Selects the FreeRTOS port")
  set_property(CACHE FREERTOS_PORT PROPERTY STRINGS
    CortexM4F
    CortexM7
    Windows
    Posix
  )

  # Validate the port selection
  get_property(allowed_ports CACHE FREERTOS_PORT PROPERTY STRINGS)
  if(NOT ${FREERTOS_PORT} IN_LIST allowed_ports)
    message(FATAL_ERROR "Unknown FreeRTOS Port: ${FREERTOS_PORT}")
  endif()
endif()