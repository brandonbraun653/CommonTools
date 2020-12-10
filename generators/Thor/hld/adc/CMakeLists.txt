# ====================================================
# Common
# ====================================================
set(LINK_LIBS
  aurora_inc        # Aurora public headers
  Boost::boost      # Boost public headers
  thor_inc          # Thor public headers
  chimera_inc       # Chimera public headers
  lld_common_inc   # 3rd Party headers
  thor_hld_build_options
)

# ====================================================
# Interface Library
# ====================================================
set(HLD thor_hld_adc)
add_library(${HLD} STATIC
  hld_adc_chimera.cpp
  hld_adc_driver.cpp
)
target_link_libraries(${HLD} PRIVATE ${LINK_LIBS})
export(TARGETS ${HLD} FILE "${PROJECT_BINARY_DIR}/Thor/hld/${HLD}.cmake")
