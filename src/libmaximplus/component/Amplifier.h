//
//  Amplifier.h
//

#pragma once

#include "ofxMaxim.h"


namespace lib_maximplus {


class Amplifier {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Amplifier();
  
  float apply(float input) const;

  float getAmplifier() const;
  void  setAmplifier(float amplifier);
  
private:
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  float amplifier_;
  
};


}  // namespace lib_maximplus