//
//  Oscillator.mm
//

#include "Oscillator.h"


namespace lib_maximplus {

  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Oscillator::Oscillator() : type_(kSinebuf), frequency_(0.0f), duty_(0.0f),
      transpose_(1.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float Oscillator::apply() {
  return apply(frequency_, duty_);
}

float Oscillator::apply(float frequency) {
  return apply(frequency, duty_);
}

float Oscillator::apply(float frequency, float duty) {
  float output = 0.0f;
  float transposed = frequency * transpose_;
  if (type_ == kSinebuf) {
    output = maximilian_osc_.sinebuf(transposed);
  } else if (type_ == kSinebuf4) {
    output = maximilian_osc_.sinebuf4(transposed);
  } else if (type_ == kSinewave) {
    output = maximilian_osc_.sinewave(transposed);
  } else if (type_ == kTriangle) {
    output = maximilian_osc_.triangle(transposed);
  } else if (type_ == kSquare) {
    output = maximilian_osc_.square(transposed);
  } else if (type_ == kSaw) {
    output = maximilian_osc_.saw(transposed);
  } else if (type_ == kPulse) {
    output = maximilian_osc_.pulse(transposed, duty);
  } else if (type_ == kNoise) {
    output = maximilian_osc_.noise(transposed);
  } else if (type_ == kRP2A03Square1) {
    output = rp2a03_osc_.square1(transposed);
  } else if (type_ == kRP2A03Square2) {
    output = rp2a03_osc_.square2(transposed);
  } else if (type_ == kRP2A03Square3) {
    output = rp2a03_osc_.square3(transposed);
  } else if (type_ == kRP2A03Triangle) {
    output = rp2a03_osc_.triangle(transposed);
  } else if (type_ == kRP2A03Noise) {
    output = rp2a03_osc_.noise(transposed);
  }
  
  return output;
}

//--------------------------------------------------------------
// getter/setters
//--------------------------------------------------------------
Oscillator::Types Oscillator::getType() const {
  return type_;
}

void Oscillator::setType(Oscillator::Types type) {
  type_ = type;
}

float Oscillator::getFrequency() const {
  return frequency_;
}

void Oscillator::setFrequency(float frequency) {
  if (frequency < 0) frequency = 0.0f;
  frequency_ = frequency;
}

float Oscillator::getDuty() const {
  return duty_;
}

void Oscillator::setDuty(float duty) {
  if (duty > 1.0f) duty = 1.0f;
  if (duty < 0.0f) duty = 0.0f;
  duty_ = duty;
}

float Oscillator::getTranspose() const {
  return transpose_;
}

void Oscillator::setTranspose(float transpose) {
  transpose_ = transpose;
}


}  // namespace lib_maximplus
