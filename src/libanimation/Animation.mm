//
//  Animation.mm
//

#include "Animation.h"


namespace lib_animation {


// aliases
using TimeDiff = Poco::Timestamp::TimeDiff;


// helper
Transition createTransition(const TimeDiff timestamp, int duration,
                            Types type, float start, float end) {
  Transition trans = {
    .trigger = true, .timestamp = timestamp, .duration = duration,
    .type = type, .start = start, .end = end
  };
  
  return trans;
}


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Animation::Animation(int param_size) {
  initMotions(param_size);
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
const std::vector<Motion>& Animation::update(const TimeDiff current_time) {
  for (int i = 0; i < motions_.size(); ++i) {
    Transition trans = motions_[i].trans;
    motions_[i].changed = false;
    if (trans.trigger && current_time >= trans.timestamp) {
      float value = trans.end;
      const int elapsed = static_cast<int>(current_time - trans.timestamp);
      if (elapsed < trans.duration) {
        const float change = trans.end - trans.start;
        value = easing(trans.type, elapsed,
                       trans.start, change, trans.duration);
      } else {
        motions_[i].trans.trigger = false;
      }
      motions_[i].value = value;
      motions_[i].changed = true;
    }
  }
  return motions_;
}

float Animation::getTransitionEnd(int param_idx) const {
  if (param_idx >= 0 && param_idx < motions_.size()) {
    return motions_[param_idx].trans.end;
  } else {
   return 0.0f;
  }
}

bool Animation::getTransitionTrigger(int param_idx) const {
  if (param_idx >= 0 && param_idx < motions_.size()) {
    return motions_[param_idx].trans.trigger;
  } else {
    return false;
  }
}

void Animation::setTransitionTrigger(int param_idx, bool trigger) {
  if (param_idx >= 0 && param_idx < motions_.size()) {
    motions_[param_idx].trans.trigger = trigger;
  }
}

void Animation::stopTransitions() {
  for (int i = 0; i < motions_.size(); ++i) motions_[i].trans.trigger = false;
}

Transition Animation::getTransition(int param_idx) const {
  if (param_idx >= 0 && param_idx < motions_.size()) {
    return motions_[param_idx].trans;
  } else {
    return {
      .trigger = false, .timestamp = 0, .duration = 0,
      .type = kEaseInLinear, .start = 0.0f, .end = 0.0f
    };
  }
}

void Animation::setTransition(int param_idx, Transition trans) {
  if (param_idx >= 0 && param_idx < motions_.size()) {
    motions_[param_idx].trans = trans;
  }
}

void Animation::adjustTransitions(const TimeDiff timestamp, int duration) {
  // This method uses when a unit clock changed.
  for (int i = 0; i < motions_.size(); ++i) {
    motions_[i].trans.timestamp = timestamp;
    motions_[i].trans.duration = duration;
  }
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
float Animation::easing(Types type, float time, float base, float change,
                        float duration) {
  float value = easing::easeInLinear(time, base, change, duration);
  if (type == kEaseOutCubic) {
    value = easing::easeOutCubic(time, base, change, duration);
  } else if (type == kEaseInCubic) {
    value = easing::easeInCubic(time, base, change, duration);
  } else if (type == kEaseOutExpo) {
    value = easing::easeOutExpo(time, base, change, duration);
  } else if (type == kEaseInExpo) {
    value = easing::easeInExpo(time, base, change, duration);
  } else if (type == kEaseOutCirc) {
    value = easing::easeOutCirc(time, base, change, duration);
  }
  
  return value;
}

//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Animation::initMotions(int param_size) {
  // use a vector as a static array
  motions_.resize(param_size);
  
  Transition trans = {
    .trigger = false, .timestamp = 0, .duration = 0,
    .type = kEaseInLinear, .start = 0.0f, .end = 0.0f
  };
  for (int i = 0; i < motions_.size(); ++i) {
    Motion motion = {
      .trans = trans, .changed = false, .value = 0.0f
    };
    motions_[i] = motion;
  }
}


}  // namespace lib_animation
