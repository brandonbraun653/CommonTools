/********************************************************************************
 *  File Name:
 *    hld_adc_driver.hpp
 *
 *  Description:
 *    Thor ADC high level driver
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_HLD_ADC_HPP
#define THOR_HLD_ADC_HPP

/* C++ Includes */
#include <cstdint>
#include <cstdlib>

/* Chimera Includes */
#include <Chimera/common>
#include <Chimera/adc>
#include <Chimera/thread>

/* Thor Includes */
#include <Thor/hld/adc/hld_adc_types.hpp>

namespace Thor::ADC
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  Chimera::Status_t initialize();
  Chimera::Status_t reset();
  Driver_rPtr getDriver( const Chimera::ADC::Channel ch );
  Driver_sPtr getDriverShared( const Chimera::ADC::Channel ch );


  /*-------------------------------------------------------------------------------
  Classes
  -------------------------------------------------------------------------------*/
  /**
   *  ADC Peripheral Driver
   *  Methods here at a minimum implement the interface specified in Chimera.
   *  Inheritance is avoided to minimize cost of virtual function lookup table.
   */
  class Driver : public Chimera::Threading::Lockable
  {
  public:
    Driver();
    ~Driver();

    /*-------------------------------------------------
    Interface: Hardware
    -------------------------------------------------*/
  private:
    Chimera::ADC::Channel mChannel;
  };
}    // namespace Thor::ADC

#endif /* THOR_HLD_ADC_HPP */
