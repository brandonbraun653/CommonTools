/********************************************************************************
 *  File Name:
 *    adc_types.hpp
 *
 *  Description:
 *    Common LLD ADC Types
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef THOR_LLD_ADC_COMMON_TYPES_HPP
#define THOR_LLD_ADC_COMMON_TYPES_HPP

/* C++ Includes */
#include <cstdint>

/* Chimera Includes */
#include <Chimera/common>

namespace Thor::LLD::ADC
{
  /*-------------------------------------------------------------------------------
  Forward Declarations
  -------------------------------------------------------------------------------*/
  class Driver;
  struct RegisterMap;

  /*-------------------------------------------------------------------------------
  Aliases
  -------------------------------------------------------------------------------*/
  using Driver_rPtr = Driver *;

  /*-------------------------------------------------------------------------------
  Structures
  -------------------------------------------------------------------------------*/
  
}    // namespace Thor::LLD::ADC

#endif /* !THOR_LLD_ADC_COMMON_TYPES_HPP */
