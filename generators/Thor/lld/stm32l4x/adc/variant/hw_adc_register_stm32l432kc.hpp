/********************************************************************************
 *  File Name:
 *    hw_adc_register_stm32l432kc.hpp
 *
 *  Description:
 *    ADC register definitions for the STM32L432KC series chips.
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_LLD_ADC_REGISTER_STM32L432KC_HPP
#define THOR_LLD_ADC_REGISTER_STM32L432KC_HPP

/* STL Includes */
#include <cstddef>

/* Thor Includes */
#include <Thor/lld/common/types.hpp>

/*-------------------------------------------------------------------------------
Macros
-------------------------------------------------------------------------------*/
#define STM32_ADC1_PERIPH_AVAILABLE


namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Constants
  -------------------------------------------------------------------------------*/
  static constexpr size_t NUM_ADC_PERIPHS = 1;

  static constexpr RIndex_t ADC1_RESOURCE_INDEX = 0u;

}    // namespace Thor::LLD::ADC

#endif /* !THOR_LLD_ADC_REGISTER_STM32L432KC_HPP */
