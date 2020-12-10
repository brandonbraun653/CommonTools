/********************************************************************************
 *  File Name:
 *    adc_types.hpp
 *
 *  Description:
 *    Chimera ADC types
 *
 *  2020 | Brandon Braun | brandonbraun653@gmail.com
 ********************************************************************************/

#pragma once
#ifndef CHIMERA_ADC_TYPES_HPP
#define CHIMERA_ADC_TYPES_HPP

/* STL Includes */
#include <cstdint>
#include <cstring>
#include <memory>

/* Chimera Includes */
#include <Chimera/common>

namespace Chimera::ADC
{
  /*-------------------------------------------------------------------------------
  Forward Declarations
  -------------------------------------------------------------------------------*/
  class Driver;
  

  /*-------------------------------------------------------------------------------
  Aliases
  -------------------------------------------------------------------------------*/
  using Driver_sPtr = std::shared_ptr<Driver>;


  /*-------------------------------------------------------------------------------
  Constants
  -------------------------------------------------------------------------------*/


  /*-------------------------------------------------------------------------------
  Enumerations
  -------------------------------------------------------------------------------*/
  enum class Channel : uint8_t
  {
    
    NUM_OPTIONS,
    UNKNOWN
  };


  /*-------------------------------------------------------------------------------
  Structures
  -------------------------------------------------------------------------------*/
  namespace Backend
  {
    struct DriverConfig
    {
      bool isSupported; /**< A simple flag to let Chimera know if the driver is supported */

      /**
       *  Function pointer that initializes the backend driver's
       *  memory. Should really only call once for initial set up.
       */
      Chimera::Status_t ( *initialize )();

      /**
       *  Resets the backend driver hardware to default configuration
       *  settings, but does not wipe out any memory.
       */
      Chimera::Status_t ( *reset )();

      /**
       *  Factory function that creates a shared_ptr instance of the backend
       *  driver, as long as it conforms to the expected interface.
       */
      Driver_sPtr ( *getDriver )( const Channel channel );
    };
  }  // namespace Backend
}  // namespace Chimera::ADC

#endif /* !CHIMERA_ADC_TYPES_HPP */
