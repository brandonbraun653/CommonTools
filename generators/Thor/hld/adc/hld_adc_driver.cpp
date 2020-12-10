/********************************************************************************
 *  File Name:
 *    hld_adc_driver.cpp
 *
 *  Description:
 *    Implements the custom driver variant of the Thor ADC interface.
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* C++ Includes */
#include <cstring>

/* Aurora Includes */
#include <Aurora/constants>

/* Chimera Includes */
#include <Chimera/common>
#include <Chimera/adc>
#include <Chimera/utility>

/* Thor Includes */
#include <Thor/cfg>
#include <Thor/adc>
#include <Thor/lld/interface/adc/adc_intf.hpp>
#include <Thor/lld/interface/adc/adc_detail.hpp>

#if defined( THOR_HLD_ADC )

namespace Thor::ADC
{
  /*-------------------------------------------------------------------------------
  Aliases
  -------------------------------------------------------------------------------*/
  namespace HLD = ::Thor::ADC;
  namespace LLD = ::Thor::LLD::ADC;

  /*-------------------------------------------------------------------------------
  Constants
  -------------------------------------------------------------------------------*/
  static constexpr size_t NUM_DRIVERS = LLD::NUM_ADC_PERIPHS;

  /*-------------------------------------------------------------------------------
  Variables
  -------------------------------------------------------------------------------*/
  static size_t s_driver_initialized;                /**< Tracks the module level initialization state */
  static HLD::Driver hld_driver[ NUM_DRIVERS ];      /**< Driver objects */
  static HLD::Driver_sPtr hld_shared[ NUM_DRIVERS ]; /**< Shared references to driver objects */


  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  Chimera::Status_t initialize()
  {
    /*------------------------------------------------
    Prevent re-initialization from occurring
    ------------------------------------------------*/
    auto result = Chimera::Status::OK;
    if ( s_driver_initialized == Chimera::DRIVER_INITIALIZED_KEY )
    {
      return result;
    }

    /*------------------------------------------------
    Initialize local memory
    ------------------------------------------------*/
    s_driver_initialized = ~Chimera::DRIVER_INITIALIZED_KEY;
    for ( size_t x = 0; x < NUM_DRIVERS; x++ )
    {
#if defined( THOR_HLD_TEST ) || defined( THOR_HLD_TEST_ADC )
      hld_shared[ x ] = HLD::Driver_sPtr( new HLD::Driver() );
#else
      hld_shared[ x ] = HLD::Driver_sPtr( &hld_driver[ x ] );
#endif
    }

    /*------------------------------------------------
    Initialize the low level driver
    ------------------------------------------------*/
    result = Thor::LLD::ADC::initialize();

    s_driver_initialized = Chimera::DRIVER_INITIALIZED_KEY;
    return result;
  }


  Chimera::Status_t reset()
  {
    /*------------------------------------------------
    Only allow clearing of local data during testing
    ------------------------------------------------*/
#if defined( THOR_HLD_TEST ) || defined( THOR_HLD_TEST_ADC )
    s_driver_initialized = ~Chimera::DRIVER_INITIALIZED_KEY;

    for ( auto x = 0; x < NUM_DRIVERS; x++ )
    {
      hld_shared[ x ].reset();
    }
#endif

    return Chimera::Status::OK;
  }


  Driver_rPtr getDriver( const Chimera::ADC::Channel ch )
  {
    if ( auto idx = LLD::getResourceIndex( ch ); idx != ::Thor::LLD::INVALID_RESOURCE_INDEX )
    {
      return &hld_driver[ idx ];
    }
    else
    {
      return nullptr;
    }
  }


  Driver_sPtr getDriverShared( const Chimera::ADC::Channel ch )
  {
    if ( auto idx = LLD::getResourceIndex( ch ); idx != ::Thor::LLD::INVALID_RESOURCE_INDEX )
    {
      return hld_shared[ idx ];
    }
    else
    {
      return nullptr;
    }
  }

  /*-------------------------------------------------------------------------------
  Driver Implementation
  -------------------------------------------------------------------------------*/
  Driver::Driver() : mChannel( Chimera::ADC::Channel::UNKNOWN )
  {
  }


  Driver::~Driver()
  {
  }

}    // namespace Thor::ADC

#endif /* THOR_HLD_ADC */
