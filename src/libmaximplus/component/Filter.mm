//
//  Filter.mm
//

#include "Filter.h"


namespace lib_maximplus {

  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Filter::Filter() : type_(kLowPass), cutoff_(0.0f), buffer_(0.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float Filter::apply(float input) {
  return apply(input, cutoff_);
}

float Filter::apply(float input, float cutoff) {
  float output = 0.0f;
  if (type_ == kLowPass) {
    output = lowPass(input, cutoff);
  } else if (type_ == kHighPass) {
    output = highPass(input, cutoff);
  }
  return output;
}

//--------------------------------------------------------------
// getter/setters
//--------------------------------------------------------------
Filter::Types Filter::getType() const {
  return type_;
}

void Filter::setType(Filter::Types type) {
  type_ = type;
}

float Filter::getCutoff() const {
  return cutoff_;
}

void Filter::setCutoff(float cutoff) {
  if (cutoff > 1.0f) cutoff = 1.0f;
  if (cutoff < 0.0f) cutoff = 0.0f;
  cutoff_ = cutoff;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
float Filter::lowPass(float input, float cutoff) {
  float output = buffer_ + cutoff * (input - buffer_);
  buffer_ = output;
  return output;
}

float Filter::highPass(float input, float cutoff) {
  float output = input - (buffer_ + cutoff * (input - buffer_));
  buffer_ = output;
  return output;
}


}  // namespace lib_maximplus
