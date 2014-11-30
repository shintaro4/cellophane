//
//  KeyBias.mm
//

#include "KeyBias.h"


namespace lib_maximplus {
  

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
KeyBias::KeyBias() : bias_(1.0f), bias_point_(60), bias_level_(0.0f),
    bias_type_(kUpperBias) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float KeyBias::getBias() const {
  return bias_;
}

void KeyBias::setBias(int note_number) {
  bias_ = calculateBias(note_number);
}

int KeyBias::getBiasPoint() const {
  return bias_point_;
}

void KeyBias::setBiasPoint(int bias_point) {
  bias_point_ = bias_point;
}

float KeyBias::getBiasLevel() const {
  return bias_level_;
}

void KeyBias::setBiasLevel(float bias_level) {
  bias_level_ = bias_level;
}

KeyBias::Types KeyBias::getBiasType() const {
  return bias_type_;
}

void KeyBias::setBiasType(KeyBias::Types bias_type) {
  bias_type_ = bias_type;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
float KeyBias::calculateBias(int note_number) const {
  int distance = note_number - bias_point_;
  
  if ((distance < 0 && bias_type_ == kUpperBias) ||
      (distance > 0 && bias_type_ == kLowerBias)) {
    return 1.0f;
  } else {
    if (distance < 0 &&
        (bias_type_ == kLowerBias || bias_type_ == kUpperAndLowerBias)) {
      distance = -distance;
    }
    float bias = 1.0f + distance * bias_level_;
    if (bias < 0) bias = 0.0f;
    
    return bias;
  }
}


}  // namespace lib_maximplus
