//
//  RP2A03Osc.h
//

#pragma once

#include "ofMain.h"


namespace lib_maximplus {
  

class RP2A03Osc {
  
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  RP2A03Osc();

  float square1(float frequency);
  float square2(float frequency);
  float square3(float frequency);
  float triangle(float frequency);
  float noise(float frequency);
  
private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const float kAudioSampleRatef;
  static const float kWaveTable[4][16];

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  void setup(float frequency);
  float lookup(int idx);
 
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  float frequency_;
  float phase_;
  float phase_increment_;
  
};


}  // namespace lib_maximplus
