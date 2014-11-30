//
//  Sample.mm
//

#include "Sample.h"


namespace lib_maximplus {
  

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Sample::Sample() : speed_(1.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float Sample::playOnce() {
  return playOnce(speed_);
}

float Sample::playOnce(float speed) {
  return sample_.playOnce(speed);
}

bool Sample::load(const string& file_name) {
  return sample_.load(file_name);
}

void Sample::reset() {
  sample_.reset();
}

//--------------------------------------------------------------
// getter/setters
//--------------------------------------------------------------
float Sample::getSpeed() const {
  return speed_;
}

void Sample::setSpeed(float speed) {
  speed_ = speed;
}


}  // lib_maximplus
