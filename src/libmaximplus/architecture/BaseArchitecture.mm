//
//  BaseArchitecture.mm
//

#include "BaseArchitecture.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
BaseArchitecture::BaseArchitecture() : timestamp_(0), duration_(0),
      trigger_(false), pan_(0.5f) {}

BaseArchitecture::~BaseArchitecture() {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void BaseArchitecture::adjustTime(const TimeDiff timestamp, int duration) {}

float BaseArchitecture::play(const TimeDiff current_time) {
  if (current_time >= timestamp_ + duration_) {
    trigger_ = false;
  }
  return synthesize();
}
  
void BaseArchitecture::stop() {
  trigger_ = false;
}

//--------------------------------------------------------------
// getter/setter
//--------------------------------------------------------------
float BaseArchitecture::getPan() const {
  return pan_;
}

void BaseArchitecture::setPan(float pan) {
  pan_ = pan;
}

int BaseArchitecture::getBiasPoint() const {
  return key_bias_.getBiasPoint();
}

void BaseArchitecture::setBiasPoint(int bias_point) {
  key_bias_.setBiasPoint(bias_point);
}

float BaseArchitecture::getBiasLevel() const {
  return key_bias_.getBiasLevel();
}

void BaseArchitecture::setBiasLevel(float bias_level) {
  key_bias_.setBiasLevel(bias_level);
}

KeyBias::Types BaseArchitecture::getBiasType() const {
  return key_bias_.getBiasType();
}

void BaseArchitecture::setBiasType(KeyBias::Types bias_type) {
  key_bias_.setBiasType(bias_type);
}


}  // namespace lib_maximplus
