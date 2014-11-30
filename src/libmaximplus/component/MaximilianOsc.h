//
//  MaximilianOsc.h
//

#pragma once

#include "ofMain.h"
#include "ofxMaxim.h"

#include "k_maximplus.h"


namespace lib_maximplus {
  

class MaximilianOsc {

public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  MaximilianOsc();

  float sinebuf(float frequency);
  float sinebuf4(float frequency);
  float sinewave(float frequency);
  float triangle(float frequency);
  float square(float frequency);
	float saw(float frequency);
	float pulse(float frequency, float duty);
  float noise(float frequency);
  
private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const float kInverseSampleRate;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

	float phase_;
  float holding_noise_;
  
  ofxMaxiOsc maxi_osc_;
  
};


}  // namespace lib_maximplus