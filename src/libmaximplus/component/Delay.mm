//
//  Delay.mm
//

#include "Delay.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int Delay::kMaxDelayTime = 88200; //  = 44100 * 2

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Delay::Delay() : time_(0), feedback_(0.0f), level_(1.0f), phase_(0) {
  delay_line_ = std::vector<float>(kMaxDelayTime, 0.0f);
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float Delay::apply(float input) {
  return apply(input, time_, feedback_);
}

float Delay::apply(float input, int time) {
  return apply(input, time, feedback_);
}

float Delay::apply(float input, int time, float feedback) {
  if (time == 0) return input;
  
	if (phase_ >= time || phase_ > delay_line_.size()) phase_ = 0;
  if (feedback > 1.0f) feedback = 1.0f;
  if (feedback < 0.0f) feedback = 0.0f;

  float delay_out = delay_line_[phase_] * level_;
  delay_line_[phase_] = delay_line_[phase_] * feedback + input;
	++phase_;

	return input + delay_out;
}

//--------------------------------------------------------------
// getter/setters
//--------------------------------------------------------------
int Delay::getTime() const {
  return time_;
}

void Delay::setTime(int time) {
  if (time > kMaxDelayTime) time = kMaxDelayTime;
  if (time < 0) time = 0;
  time_ = time;
}

float Delay::getFeedback() const {
  return feedback_;
}

void Delay::setFeedback(float feedback) {
  if (feedback > 1.0f) feedback = 1.0f;
  if (feedback < 0.0f) feedback = 0.0f;
  feedback_ = feedback;
}

float Delay::getLevel() const {
  return level_;
}
  
void Delay::setLevel(float level) {
  if (level > 1.0f) level = 1.0f;
  if (level < 0.0f) level = 0.0f;
  level_ = level;
}
  
void Delay::clearDelayLine() {
  std::fill(delay_line_.begin(), delay_line_.end(), 0.0f);
}
  

}  // namespace lib_maximplus
