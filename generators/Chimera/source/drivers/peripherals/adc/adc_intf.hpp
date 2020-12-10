/********************************************************************************
 *  File Name:
 *    adc_intf.hpp
 *
 *  Description:
 *    Models the Chimera ADC interface
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef CHIMERA_ADC_INTERFACE_HPP
#define CHIMERA_ADC_INTERFACE_HPP

/* Chimera Includes */
#include <Chimera/common>
#include <Chimera/thread>
#include <Chimera/source/drivers/peripherals/adc/adc_types.hpp>

namespace Chimera::ADC
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  namespace Backend
  {
    /**
     *  Registers the backend driver with Chimera
     *
     *  @param[in]  registry    Chimera's copy of the driver interface
     *  @return Chimera::Status_t
     */
    extern Chimera::Status_t registerDriver( DriverConfig &registry );
  }  // namespace Backend


  /*-------------------------------------------------------------------------------
  Classes
  -------------------------------------------------------------------------------*/
  class HWInterface
  {
  public:
    virtual ~HWInterface() = default;

  };


  /**
   *  Virtual class to facilitate easy mocking of the driver
   */
  class I{driver_name_upper} : virtual public HWInterface,
               virtual public Chimera::Threading::LockableInterface
  {
  public:
    virtual ~I{driver_name_upper}() = default;
  };

}  // namespace Chimera::{driver_name_upper}

#endif /* !CHIMERA_ADC_INTERFACE_HPP */
