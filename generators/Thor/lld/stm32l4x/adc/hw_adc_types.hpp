/********************************************************************************
 *  File Name:
 *    hw_adc_types.hpp
 *
 *  Description:
 *    LLD types for the ADC Peripheral
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_HW_ADC_TYPES_HPP
#define THOR_HW_ADC_TYPES_HPP

/* C++ Includes */
#include <cstdint>

/* Driver Includes */
#include <Thor/lld/stm32l4x/adc/hw_adc_prj.hpp>

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Enumerations
  -------------------------------------------------------------------------------*/


  /*-------------------------------------------------------------------------------
  Structures
  -------------------------------------------------------------------------------*/
  struct RegisterMap
  {
    volatile uint32_t x;
  };

}    // namespace Thor::LLD::ADC

#endif /* !THOR_HW_ADC_TYPES_HPP*/
