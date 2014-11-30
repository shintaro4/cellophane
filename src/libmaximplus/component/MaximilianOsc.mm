//
//  MaximilianOsc.mm
//

#include "MaximilianOsc.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const float MaximilianOsc::kInverseSampleRate = 1.0f / kAudioSampleRate;

//--------------------------------------------------------------
// constructor/destructor
//--------------------------------------------------------------
MaximilianOsc::MaximilianOsc() : phase_(0.0f), holding_noise_(0.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float MaximilianOsc::sinewave(float frequency) {
  float output = sin(phase_ * TWO_PI);
	if (phase_ >= 1.0f) phase_ -= 1.0f;
  phase_ += kInverseSampleRate * frequency;

	return output;
}

float MaximilianOsc::sinebuf(float frequency) {
  return maxi_osc_.sinebuf(frequency);
}
  
float MaximilianOsc::sinebuf4(float frequency) {
  return maxi_osc_.sinebuf4(frequency);
}
  
float MaximilianOsc::triangle(float frequency) {
	if (phase_ >= 1.0f) phase_ -= 1.0;
  phase_ += kInverseSampleRate * frequency;
  
  float output = 0.0f;
	if (phase_ <= 0.5f) {
		output = (phase_ - 0.25f) * 4;
	} else {
		output = ((1.0f - phase_) - 0.25f) * 4;
	}

	return output;
}

float MaximilianOsc::square(float frequency) {
	if (phase_ >= 1.0f) phase_ -= 1.0f;
  phase_ += kInverseSampleRate * frequency;

  float output = 0.0f;
	if (phase_ < 0.5f) output = -1.0f;
	if (phase_ > 0.5f) output = 1.0f;
  
	return output;
}

float MaximilianOsc::saw(float frequency) {
	if (phase_ >= 1.0f) phase_ -= 2.0;
  phase_ += kInverseSampleRate * frequency;

  float output = phase_;
  
	return output;
}


float MaximilianOsc::pulse(float frequency, float duty) {
	if (duty < 0.0f) duty = 0.0f;
	if (duty > 1.0f) duty = 1.0f;
	if (phase_ >= 1.0f) phase_ -= 1.0f;
  phase_ += kInverseSampleRate * frequency;
  
  float output = 0.0f;
	if (phase_ < duty) output = -1.0f;
	if (phase_ > duty) output = 1.0f;

	return output;
}

float MaximilianOsc::noise(float frequency) {
	if (phase_ >= 1.0f) {
    holding_noise_ = ofRandomf();
    phase_ -= 1.0f;
  }
  phase_ += kInverseSampleRate * frequency;

  float output = holding_noise_;

	return output;
}


}  // namespace lib_maximplus
