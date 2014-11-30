//
//  EGTimer.mm
//

#include "EGTimer.h"


namespace cellophane {
  
namespace ns_sound {
    

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
EGTimer::EGTimer() : state_(false), timestamp_(0), duration_(0),
    velocity_(0.0f), eg_type_(EG::kAR_aR) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
bool EGTimer::trigger(const TimeDiff current_time) const {
  return (state_ && current_time >= timestamp_);
}
  
void EGTimer::setTimer(const TimeDiff timestamp, int duration,
                       float velocity, EG::Types eg_type) {
  timestamp_ = timestamp;
  duration_ = duration;
  velocity_ = velocity;
  eg_type_ = eg_type;
  state_ = true;
}

void EGTimer::setEG(EG& eg) {
  eg.setEnvelope(duration_, velocity_, eg_type_, 1.0f);
}
  
bool EGTimer::getState() const {
  return state_;
}

void EGTimer::reset() {
  state_ = false;
}
  
  
}  // namespace ns_sound
  
}  // namespace cellophane
