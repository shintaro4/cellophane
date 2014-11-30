//
//  Amplifier.mm
//

#include "Amplifier.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Amplifier::Amplifier() : amplifier_(1.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float Amplifier::apply(float input) const {
  return amplifier_ * input;
}

//--------------------------------------------------------------
// getter/setters
//--------------------------------------------------------------
float Amplifier::getAmplifier() const {
  return amplifier_;
}

void Amplifier::setAmplifier(float amplifier) {
  if (amplifier > 1.0f) amplifier = 1.0f;
  if (amplifier < 0.0f) amplifier = 0.0f;
  amplifier_ = amplifier;
}


}  // namespace lib_maximplus
