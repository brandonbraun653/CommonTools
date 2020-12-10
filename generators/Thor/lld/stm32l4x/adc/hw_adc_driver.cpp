/********************************************************************************
 *  File Name:
 *    hw_adc_driver.cpp
 *
 *  Description:
 *    Implements the LLD interface to the ADC hardware.
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* STL Includes */
#include <cstring>
#include <limits>

/* Chimera Includes */
#include <Chimera/algorithm>
#include <Chimera/common>
#include <Chimera/utility>

/* Driver Includes */
#include <Thor/cfg>
#include <Thor/hld/interrupt/hld_interrupt_definitions.hpp>
#include <Thor/lld/interface/adc/adc_prv_data.hpp>
#include <Thor/lld/interface/adc/adc_intf.hpp>
#include <Thor/lld/stm32l4x/adc/hw_adc_prj.hpp>
#include <Thor/lld/stm32l4x/adc/hw_adc_types.hpp>
#include <Thor/lld/stm32l4x/rcc/hw_rcc_driver.hpp>

#if defined( TARGET_STM32L4 ) && defined( THOR_LLD_ADC )

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Variables
  -------------------------------------------------------------------------------*/
  static Driver s_adc_drivers[ NUM_ADC_PERIPHS ];

  /*-------------------------------------------------------------------------------
  Private Functions
  -------------------------------------------------------------------------------*/

  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  Chimera::Status_t initialize()
  {
    /*-------------------------------------------------
    Attach all the expected peripherals to the drivers
    -------------------------------------------------*/
    if ( attachDriverInstances( s_adc_drivers, ARRAY_COUNT( s_adc_drivers ) ) )
    {
      return Chimera::Status::OK;
    }
    else
    {
      return Chimera::Status::FAIL;
    }
  }


  Driver_rPtr getDriver( const Chimera::ADC::Channel channel )
  {
    if ( auto idx = getResourceIndex( channel ); idx != INVALID_RESOURCE_INDEX )
    {
      return &s_adc_drivers[ idx ];
    }
    else
    {
      return nullptr;
    }
  }


  /*-------------------------------------------------------------------------------
  Low Level Driver Implementation
  -------------------------------------------------------------------------------*/
  Driver::Driver()
  {
  }

  Driver::~Driver()
  {
  }


  Chimera::Status_t Driver::attach( RegisterMap *const peripheral )
  {
    /*------------------------------------------------
    Get peripheral descriptor settings
    ------------------------------------------------*/
    mPeriph       = peripheral;
    resourceIndex = getResourceIndex( reinterpret_cast<std::uintptr_t>( peripheral ) );

    /*------------------------------------------------
    Handle the ISR configuration
    ------------------------------------------------*/
    Thor::LLD::IT::disableIRQ( Resource::IRQSignals[ resourceIndex ] );
    Thor::LLD::IT::clearPendingIRQ( Resource::IRQSignals[ resourceIndex ] );
    Thor::LLD::IT::setPriority( Resource::IRQSignals[ resourceIndex ], Thor::Interrupt::ADC_IT_PREEMPT_PRIORITY, 0u );

    return Chimera::Status::OK;
  }


  Chimera::Status_t Driver::reset()
  {
    return Chimera::Status::OK;
  }


  void Driver::clockEnable()
  {
    auto rcc = Thor::LLD::RCC::getPeripheralClock();
    rcc->enableClock( Chimera::Peripheral::Type::PERIPH_ADC, resourceIndex );
  }


  void Driver::clockDisable()
  {
    auto rcc = Thor::LLD::RCC::getPeripheralClock();
    rcc->disableClock( Chimera::Peripheral::Type::PERIPH_ADC, resourceIndex );
  }


  inline void Driver::enterCriticalSection()
  {
    Thor::LLD::IT::disableIRQ( Resource::IRQSignals[ resourceIndex ] );
  }


  inline void Driver::exitCriticalSection()
  {
    Thor::LLD::IT::enableIRQ( Resource::IRQSignals[ resourceIndex ] );
  }


  void Driver::IRQHandler()
  {

  }
}    // namespace Thor::LLD::ADC


#if defined( STM32_ADC1_PERIPH_AVAILABLE )
void ADC1_IRQHandler()
{
  using namespace Thor::LLD::ADC;
  s_adc_drivers[ ADC1_RESOURCE_INDEX ].IRQHandler();
}
#endif

#endif /* TARGET_STM32L4 && THOR_DRIVER_ADC */
