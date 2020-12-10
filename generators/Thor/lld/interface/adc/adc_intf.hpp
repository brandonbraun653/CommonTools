/********************************************************************************
 *  File Name:
 *    adc_intf.hpp
 *
 *  Description:
 *    STM32 LLD ADC Interface Spec
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_LLD_ADC_DRIVER_INTERFACE_HPP
#define THOR_LLD_ADC_DRIVER_INTERFACE_HPP

/* Chimera Includes */
#include <Chimera/common>
#include <Chimera/adc>
#include <Chimera/thread>

/* Thor Includes */
#include <Thor/lld/common/interrupts/adc_interrupt_vectors.hpp>
#include <Thor/lld/common/types.hpp>
#include <Thor/lld/interface/adc/adc_types.hpp>
#include <Thor/lld/stm32l4x/interrupt/hw_interrupt_prj.hpp>

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Public Functions
  -------------------------------------------------------------------------------*/
  /**
   *  Initializes the low level driver
   */
  Chimera::Status_t initialize();

  /**
   *  Gets a shared pointer to the ADC driver for a particular channel
   *
   *  @param[in] channel        The ADC channel to grab (1 indexed)
   *  @return IDriver_sPtr      Instance of the ADC driver for the requested channel
   */
  Driver_rPtr getDriver( const Chimera::ADC::Channel channel );


  /*-------------------------------------------------------------------------------
  Public Functions (Implemented at the interface layer)
  -------------------------------------------------------------------------------*/
  /**
   *  Checks if the given hardware channel is supported on this device.
   *
   *  @param[in]  channel       The channel number to be checked
   *  @return bool
   */
  bool isSupported( const Chimera::ADC::Channel channel );

  /**
   *  Get's the resource index associated with a particular channel. If not
   *  supported, will return INVALID_RESOURCE_INDEX
   *
   *  @param[in]  channel       The channel number to be checked
   *  @return RIndex_t
   */
  RIndex_t getResourceIndex( const Chimera::ADC::Channel channel );

  /**
   *  Looks up a resource index based on a raw peripheral instance
   *
   *  @param[in]  address       The peripheral address
   *  @return RIndex_t
   */
  RIndex_t getResourceIndex( const std::uintptr_t address );

  /**
   *  Gets the ADC channel associated with a peripheral address
   *
   *  @param[in]  address       Memory address the peripheral is mapped to
   *  @return Chimera::ADC::Channel
   */
  Chimera::ADC::Channel getChannel( const std::uintptr_t address );

  /**
   *  Initializes the ADC drivers by attaching the appropriate peripheral
   *
   *  @param[in]  driverList    List of driver objects to be initialized
   *  @param[in]  numDrivers    How many drivers are in driverList
   *  @return bool
   */
  bool attachDriverInstances( Driver *const driverList, const size_t numDrivers );


  /*-------------------------------------------------------------------------------
  Classes
  -------------------------------------------------------------------------------*/
  /*-------------------------------------------------
  Virtual class that defines the expected interface.
  Useful for mocking purposes.
  -------------------------------------------------*/
  class IDriver
  {
  public:
    virtual ~IDriver() = default;

    /**
     *  Attaches a peripheral instance to the interaction model
     *
     *  @param[in]  peripheral    Memory mapped struct of the desired ADC peripheral
     *  @return void
     */
    virtual Chimera::Status_t attach( RegisterMap *const peripheral ) = 0;

    /**
     *  Initializes the peripheral with the desired settings
     *
     *  @param[in]  cfg           Configuration info
     *  @return Chimera::Status_t
     */
    virtual Chimera::Status_t initialize( const Chimera::ADC::PeriphConfig &cfg ) = 0;

    /**
     *  Resets the hardware registers back to boot-up values
     *
     *  @return Chimera::Status_t
     */
    virtual Chimera::Status_t reset() = 0;

    /**
     *  Reset the peripheral using the RCC driver. Despite the name, this
     *  only affects the ADC peripheral, not the RCC clock configuration.
     *
     *  @return void
     */
    virtual void clockReset() = 0;

    /**
     *  Enables the peripheral clock
     *
     *  @return void
     */
    virtual void clockEnable() = 0;

    /**
     *  Disables the peripheral clock
     *
     *  @return void
     */
    virtual void clockDisable() = 0;
  };


  /*-------------------------------------------------
  Concrete driver declaration. Implements the interface
  of the virtual class, but doesn't inherit due to the
  memory penalties. Definition is done project side.
  -------------------------------------------------*/
  class Driver
  {
  public:
    Driver();
    ~Driver();

    Chimera::Status_t attach( RegisterMap *const peripheral );
    Chimera::Status_t initialize( const Chimera::ADC::PeriphConfig &cfg );
    Chimera::Status_t reset();
    void clockReset();
    void clockEnable();
    void clockDisable();

  protected:
    void enterCriticalSection();
    void exitCriticalSection();
    void IRQHandler();

  private:
    RegisterMap *mPeriph;
    size_t mResourceIndex;
    Chimera::ADC::PeriphConfig mCfg;
  };

}    // namespace Thor::LLD::ADC

#endif /* THOR_LLD_ADC_DRIVER_INTERFACE_HPP */
