/********************************************************************************
 *  File Name:
 *    hld_adc_chimera.cpp
 *
 *  Description:
 *    Implementation of Chimera ADC driver hooks
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

/* Chimera Includes */
#include <Chimera/common>
#include <Chimera/adc>

/* Thor Includes */
#include <Thor/cfg>
#include <Thor/adc>
#include <Thor/lld/common/types.hpp>
#include <Thor/lld/interface/adc/adc_intf.hpp>
#include <Thor/lld/interface/adc/adc_detail.hpp>
#include <Thor/lld/interface/adc/adc_prv_data.hpp>

/*-------------------------------------------------------------------------------
Aliases
-------------------------------------------------------------------------------*/
namespace HLD = ::Thor::ADC;
namespace LLD = ::Thor::LLD::ADC;

/*-------------------------------------------------------------------------------
Constants
-------------------------------------------------------------------------------*/
static constexpr size_t NUM_DRIVERS = ::LLD::NUM_ADC_PERIPHS;

/*-------------------------------------------------------------------------------
Variables
-------------------------------------------------------------------------------*/
static Chimera::ADC::Driver s_raw_driver[ NUM_DRIVERS ];
static Chimera::ADC::Driver_sPtr s_shared_driver[ NUM_DRIVERS ];


namespace Chimera::ADC::Backend
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  Chimera::Status_t initialize()
  {
    for ( size_t x = 0; x < NUM_DRIVERS; x++ )
    {
      s_shared_driver[ x ] = Chimera::ADC::Driver_sPtr( &s_raw_driver[ x ] );
    }

    return Thor::ADC::initialize();
  }


  Chimera::Status_t reset()
  {
    return Thor::ADC::reset();
  }


  Chimera::ADC::Driver_sPtr getDriver( const Channel ch )
  {
    auto idx = ::LLD::getResourceIndex( ch );
    return s_shared_driver[ idx ];
  }


  Chimera::Status_t registerDriver( Chimera::ADC::Backend::DriverConfig &registry )
  {
#if defined( THOR_HLD_ADC )
    registry.isSupported = true;
    registry.getDriver   = getDriver;
    registry.initialize  = initialize;
    registry.reset       = reset;
    return Chimera::Status::OK;
#else
    memset( &registry, 0, sizeof( Chimera::ADC::Backend::DriverConfig ) );
    registry.isSupported = false;
    return Chimera::Status::NOT_SUPPORTED;
#endif    // THOR_HLD_ADC
  }
}    // namespace Chimera::ADC::Backend


namespace Chimera::ADC
{
  /*-------------------------------------------------------------------------------
  Driver Implementation
  -------------------------------------------------------------------------------*/
  Driver::Driver() : mDriver( nullptr )
  {
  }


  Driver::~Driver()
  {
  }


  /*-------------------------------------------------
  Interface: Hardware
  -------------------------------------------------*/


  /*-------------------------------------------------
  Interface: Lockable
  -------------------------------------------------*/
  void Driver::lock()
  {
    static_cast<::HLD::Driver_rPtr>( mDriver )->lock();
  }


  void Driver::lockFromISR()
  {
    static_cast<::HLD::Driver_rPtr>( mDriver )->lockFromISR();
  }


  bool Driver::try_lock_for( const size_t timeout )
  {
    return static_cast<::HLD::Driver_rPtr>( mDriver )->try_lock_for( timeout );
  }


  void Driver::unlock()
  {
    static_cast<::HLD::Driver_rPtr>( mDriver )->unlock();
  }


  void Driver::unlockFromISR()
  {
    static_cast<::HLD::Driver_rPtr>( mDriver )->unlockFromISR();
  }
}    // namespace Chimera::ADC
