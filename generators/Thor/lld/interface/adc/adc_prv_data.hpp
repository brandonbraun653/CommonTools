/********************************************************************************
 *  File Name:
 *    adc_prv_data.hpp
 *
 *  Description:
 *    Declaration of data that must be defined by the LLD implementation or is
*    shared among all possible drivers.
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_LLD_ADC_DATA
#define THOR_LLD_ADC_DATA

/* STL Includes */
#include <cstddef>

/* Chimera Includes */
#include <Chimera/adc>

/* Thor Includes */
#include <Thor/lld/common/macros.hpp>
#include <Thor/lld/common/types.hpp>
#include <Thor/lld/interface/adc/adc_detail.hpp>
#include <Thor/lld/interface/interrupt/interrupt_detail.hpp>

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Constants
  -------------------------------------------------------------------------------*/
  static constexpr size_t DRIVER_MAX_PERIPHS = static_cast<size_t>( Chimera::ADC::Channel::NUM_OPTIONS );

  /*-------------------------------------------------------------------------------
  Project Defined Constants
  -------------------------------------------------------------------------------*/


  /*-------------------------------------------------------------------------------
  Peripheral Instances:
    Memory mapped structures that allow direct access to peripheral registers
  -------------------------------------------------------------------------------*/
#if defined( STM32_ADC1_PERIPH_AVAILABLE )
  extern RegisterMap *ADC1_PERIPH;
#endif


  /*-------------------------------------------------------------------------------
  Configuration Maps:
    These convert high level configuration options into low level register config
    options. The idea is to allow the user to specify some general options, then
    convert that over to what the peripheral understands during config/init steps.
  -------------------------------------------------------------------------------*/
  namespace ConfigMap
  {
  }    // namespace ConfigMap


  /*-------------------------------------------------------------------------------
  Peripheral Resources
  -------------------------------------------------------------------------------*/
  namespace Resource
  {
  }    // namespace ResourceMap
}    // namespace Thor::LLD::ADC

#endif /* !THOR_LLD_ADC_DATA */
