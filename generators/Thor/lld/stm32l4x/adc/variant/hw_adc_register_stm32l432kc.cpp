/********************************************************************************
 *  File Name:
 *    hw_adc_register_stm32l432kc.cpp
 *
 *  Description:
 *    ADC register definitions for the STM32L432KC series chips.
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* Chimera Includes */
#include <Chimera/adc>

/* Driver Includes */
#include <Thor/cfg>
#include <Thor/hld/dma/hld_dma_intf.hpp>
#include <Thor/lld/interface/adc/adc_intf.hpp>
#include <Thor/lld/l4x/rcc/hw_rcc_mapping.hpp>
#include <Thor/lld/l4x/adc/hw_adc_types.hpp>
#include <Thor/lld/l4x/adc/variant/hw_adc_register_l4xxxx.hpp>

#if defined( STM32L432xx ) && defined( THOR_LLD_ADC )

namespace Thor::LLD::ADC
{
}    // namespace Thor::LLD::ADC

namespace Thor::LLD::RCC::LookupTables
{
  /*------------------------------------------------
  Lookup tables for register access on a peripheral
  by peripheral basis.
  ------------------------------------------------*/
  RegisterConfig ADC_ClockConfig[ Thor::LLD::ADC::NUM_ADC_PERIPHS ];
  RegisterConfig ADC_ResetConfig[ Thor::LLD::ADC::NUM_ADC_PERIPHS ];
  Chimera::Clock::Bus ADC_SourceClock[ Thor::LLD::ADC::NUM_ADC_PERIPHS ];

  PCC ADCLookup = { ADC_ClockConfig,
                    nullptr,
                    ADC_ResetConfig,
                    ADC_SourceClock,
                    Thor::LLD::ADC::NUM_ADC_PERIPHS,
                    Thor::LLD::ADC::getResourceIndex };

  void ADCInit()
  {
    using namespace Thor::LLD::ADC;

/*------------------------------------------------
ADC clock enable register access lookup table
------------------------------------------------*/
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    ADC_ClockConfig[ ADC1_RESOURCE_INDEX ].mask = //APB2ENR_ADC1EN;
    ADC_ClockConfig[ ADC1_RESOURCE_INDEX ].reg  = //&RCC1_PERIPH->APB2ENR;
#endif

/*------------------------------------------------
ADC reset register access lookup table
------------------------------------------------*/
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    ADC_ResetConfig[ ADC1_RESOURCE_INDEX ].mask = //APB2RSTR_ADC1RST;
    ADC_ResetConfig[ ADC1_RESOURCE_INDEX ].reg  = //&RCC1_PERIPH->APB2RSTR;
#endif

/*------------------------------------------------
ADC clocking bus source identifier
------------------------------------------------*/
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    ADC_SourceClock[ ADC1_RESOURCE_INDEX ] = //Chimera::Clock::Bus::APB2;
#endif
  };

}    // namespace Thor::LLD::RCC::LookupTables

#endif /* STM32L432xx && THOR_LLD_ADC */
