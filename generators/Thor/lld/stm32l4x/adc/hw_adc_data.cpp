/********************************************************************************
 *  File Name:
 *    hw_adc_data.cpp
 *
 *  Description:
 *    Provides implementation details for private ADC driver data
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* STL Includes */
#include <limits>

/* Chimera Includes */
#include <Chimera/adc>

/* Driver Includes */
#include <Thor/cfg>
#include <Thor/lld/interface/adc/adc_prv_data.hpp>

#if defined( TARGET_STM32L4 ) && defined( THOR_LLD_ADC )

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Peripheral Memory Maps
  -------------------------------------------------------------------------------*/
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
  RegisterMap *ADC1_PERIPH = reinterpret_cast<RegisterMap *>( ADC1_BASE_ADDR );
#endif

  /*-------------------------------------------------------------------------------
  Configuration Maps
  -------------------------------------------------------------------------------*/
  namespace ConfigMap
  { /* clang-format off */
  } /* clang-format on */


  /*-------------------------------------------------------------------------------
  Peripheral Resources
  -------------------------------------------------------------------------------*/
  namespace Resource
  { /* clang-format off */
    LLD_CONST IRQn_Type IRQSignals[ NUM_ADC_PERIPHS ] = {
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
      ADC1_IRQn,
#endif
    };
  } /* clang-format on */
}  // namespace Thor::LLD::ADC

#endif /* TARGET_STM32L4 && THOR_LLD_ADC */
