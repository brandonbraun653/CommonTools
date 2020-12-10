/********************************************************************************
 *  File Name:
 *    adc_intf.cpp
 *
 *  Description:
 *    LLD interface functions that are processor independent
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* Chimera Includes */
#include <Chimera/common>

/* Thor Includes */
#include <Thor/lld/common/types.hpp>
#include <Thor/lld/interface/adc/adc_detail.hpp>
#include <Thor/lld/interface/adc/adc_prv_data.hpp>
#include <Thor/lld/interface/adc/adc_types.hpp>
#include <Thor/lld/interface/adc/adc_intf.hpp>

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  bool isSupported( const Chimera::ADC::Channel channel )
  {
    switch ( channel )
    {
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
      case Chimera::ADC::Channel::ADC0:
        return true;
        break;
#endif

      default:
        return false;
        break;
    };
  }


  RIndex_t getResourceIndex( const Chimera::ADC::Channel channel )
  {
    switch ( channel )
    {
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
      case Chimera::ADC::Channel::ADC0:
        return ADC1_RESOURCE_INDEX;
        break;
#endif

      default:
        return INVALID_RESOURCE_INDEX;
        break;
    };
  }


  RIndex_t getResourceIndex( const std::uintptr_t address )
  {
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    if ( address == reinterpret_cast<std::uintptr_t>( ADC1_PERIPH ) )
    {
      return ADC1_RESOURCE_INDEX;
    }
#endif

    return INVALID_RESOURCE_INDEX;
  }


  Chimera::ADC::Channel getChannel( const std::uintptr_t address )
  {
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    if ( address == reinterpret_cast<std::uintptr_t>( ADC1_PERIPH ) )
    {
      return Chimera::ADC::Channel::ADC0;
    }
#endif

    return Chimera::ADC::Channel::UNKNOWN;
  }


  bool attachDriverInstances( Driver *const driverList, const size_t numDrivers )
  {
    /*-------------------------------------------------
    Reject bad inputs
    -------------------------------------------------*/
    if ( !driverList || !numDrivers || ( numDrivers != NUM_ADC_PERIPHS ) )
    {
      return false;
    }

    /*-------------------------------------------------
    Attach the drivers. The architecture of the LLD
    ensures the ordering and number is correct.
    -------------------------------------------------*/
    Chimera::Status_t result = Chimera::Status::OK;

#if defined( STM32_ADC1_PERIPH_AVAILABLE )
    result |= driverList[ ADC1_RESOURCE_INDEX ].attach( ADC1_PERIPH );
#endif

    return result == Chimera::Status::OK;
  }
}    // namespace Thor::LLD::ADC
