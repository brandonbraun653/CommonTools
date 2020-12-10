/********************************************************************************
 *  File Name:
 *    adc_user.hpp
 *
 *  Description:
 *    Implements an interface to create a Chimera ADC peripheral
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef CHIMERA_ADC_HPP
#define CHIMERA_ADC_HPP

/* STL Includes */
#include <memory>

/* Chimera Includes */
#include <Chimera/source/drivers/peripherals/adc/adc_intf.hpp>
#include <Chimera/source/drivers/peripherals/adc/adc_types.hpp>

namespace Chimera::ADC
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  Chimera::Status_t initialize();
  Chimera::Status_t reset();
  Driver_sPtr getDriver( const Channel channel );


  /*-------------------------------------------------------------------------------
  Classes
  -------------------------------------------------------------------------------*/
  /**
   *  Concrete class declaration that promises to implement the virtual one, to
   *  avoid paying the memory penalty of a v-table lookup. Implemented project side
   *  using the Bridge pattern.
   */
  class Driver
  {
  public:
    Driver();
    ~Driver();

    /*-------------------------------------------------
    Interface: Hardware
    -------------------------------------------------*/

    /*-------------------------------------------------
    Interface: Lockable
    -------------------------------------------------*/
    void lock();
    void lockFromISR();
    bool try_lock_for( const size_t timeout );
    void unlock();
    void unlockFromISR();

  private:
    void * mDriver; /**< Instance of the implementer's ADC driver */
  };
}  // namespace Chimera::ADC

#endif  /* !CHIMERA_ADC_HPP */
