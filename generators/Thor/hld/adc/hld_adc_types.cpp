/********************************************************************************
 *  File Name:
 *    hld_adc_types.cpp
 *
 *  Description:
 *    Thor ADC types
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_HLD_ADC_TYPES_HPP
#define THOR_HLD_ADC_TYPES_HPP

/* C++ Includes */
#include <memory>

namespace Thor::ADC
{
  /*-------------------------------------------------------------------------------
  Forward Declarations
  -------------------------------------------------------------------------------*/
  class Driver;


  /*-------------------------------------------------------------------------------
  Aliases
  -------------------------------------------------------------------------------*/
  using Driver_rPtr = Driver *;
  using Driver_sPtr = std::shared_ptr<Driver>;
}    // namespace Thor::ADC

#endif /* !THOR_HLD_ADC_TYPES_HPP */
