//
//  RP2A03Osc.mm
//

#include "RP2A03Osc.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const float RP2A03Osc::kAudioSampleRatef = 44100.0;

// Wave Table
//  波形メモリ音源
//  http://ja.wikipedia.org/wiki/%E6%B3%A2%E5%BD%A2%E3%83%A1%E3%83%A2%E3%83%AA%E9%9F%B3%E6%BA%90
//  Wavetable Synthesis
//  http://en.wikipedia.org/wiki/Wavetable_synthesis
//
const float RP2A03Osc::kWaveTable[4][16] = {
  // square(duty=12.5%)
  {1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0},
  
  // square(duty=25.0%)
  {1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0},
  
  // square(duty=50.0%)
  {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0},
  
  // triangle
  {0.0, 0.25, 0.5, 0.75, 1.0, 0.75, 0.5, 0.25,
    0.0, -0.25, -0.5, -0.75, -1.0, -0.75, -0.5, -0.25}

};

//--------------------------------------------------------------
// constructor/destructor
//--------------------------------------------------------------
RP2A03Osc::RP2A03Osc() : frequency_(0.0f), phase_(0.0f),
    phase_increment_(0.0f) {
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float RP2A03Osc::square1(float frequency) {
  setup(frequency);
  return lookup(0);
}

float RP2A03Osc::square2(float frequency) {
  setup(frequency);
  return lookup(1);
}

float RP2A03Osc::square3(float frequency) {
  setup(frequency);
  return lookup(2);
}

float RP2A03Osc::triangle(float frequency) {
  setup(frequency);
  return lookup(3);
}

float RP2A03Osc::noise(float frequency) {
  setup(frequency);

  float noise = 0.0f;
  while (phase_ >= 0.25f) {
    phase_ -= 0.25f;
    noise = (ofRandomuf() >= 0.5f) ? 0.25f : -0.25f;
  }
  return noise;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void RP2A03Osc::setup(float frequency) {
  if (frequency_ != frequency) {
    frequency_ = frequency;
    phase_ = 0.0f;
    phase_increment_ = frequency / kAudioSampleRatef;
  }
  phase_ += phase_increment_;
}

float RP2A03Osc::lookup(int idx) {
  while (phase_ >= 1.0f) phase_ -= 1.0f;
  return kWaveTable[idx][static_cast<int>(phase_ * 16)];
}


}  // namespace lib_maximplus
