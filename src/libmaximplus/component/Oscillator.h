//
//  Oscillator.h
//

#pragma once

#include "MaximilianOsc.h"
#include "RP2A03Osc.h"


namespace lib_maximplus {
  

class Oscillator {
  
public:
  
  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  enum Types {
    kSinebuf, kSinebuf4, kSinewave, kTriangle, kSquare, kSaw, kPulse, kNoise,
    kRP2A03Square1, kRP2A03Square2, kRP2A03Square3, kRP2A03Triangle,
    kRP2A03Noise
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Oscillator();

  float apply();
  float apply(float frequency);
  float apply(float frequency, float duty);

  Types getType() const;
  void  setType(Types type);
  float getFrequency() const;
  void  setFrequency(float frequency);
  float getDuty() const;
  void  setDuty(float duty);
  float getTranspose() const;
  void setTranspose(float transpose);
  
private:

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  MaximilianOsc maximilian_osc_;
  RP2A03Osc rp2a03_osc_;
  Types type_;
  float frequency_;
  float duty_;
  float transpose_;
  
};


}  // namespace lib_maximplus
