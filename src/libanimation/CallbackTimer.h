//
//  CallbackTimer.h
//

#pragma once

#include "ofMain.h"


namespace lib_animation {


template <class T>
class CallbackTimer {
  
public:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
  
  using TimeDiff = Poco::Timestamp::TimeDiff;
  
  struct Callback {
    T type;
    bool state;
    TimeDiff timestamp;
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  explicit CallbackTimer(const std::vector<T>& types) {
    initCallbacks(types);
  };

  bool trigger(T type, const TimeDiff current_time) const;
  bool getState(T type) const;
  void setState(T type, bool trigger);
  void setCallbackTimer(T type, const TimeDiff timestamp);
  void reset();
  bool isScheduling() const;
  void adjustTime(const TimeDiff timestamp, int duration);
  
private:
  
  CallbackTimer(const CallbackTimer&);
  CallbackTimer& operator=(const CallbackTimer&);
  
  int convertToIndex(T type) const;
  void initCallbacks(const std::vector<T>& types);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  std::vector<Callback> callbacks_;
  
};
  
  
//--------------------------------------------------------------
// public method implementations
//--------------------------------------------------------------
template <class T>
bool CallbackTimer<T>::trigger(T type, const TimeDiff current_time) const {
  bool trigger = false;
  int idx = convertToIndex(type);
  if (idx >= 0 && idx < callbacks_.size()) {
    trigger = (callbacks_[idx].state &&
               current_time >= callbacks_[idx].timestamp);
  }
  return trigger;
}
  
template <class T>
bool CallbackTimer<T>::getState(T type) const {
  bool state = false;
  int idx = convertToIndex(type);
  if (idx >= 0 && idx < callbacks_.size()) {
    state = callbacks_[idx].state;
  }
  return state;
}

template <class T>
void CallbackTimer<T>::setState(T type, bool state) {
  int idx = convertToIndex(type);
  if (idx >= 0 && idx < callbacks_.size()) {
    callbacks_[idx].state = state;
  }
}
 
template <class T>
void CallbackTimer<T>::setCallbackTimer(T type, const TimeDiff timestamp) {
  int idx = convertToIndex(type);
  if (idx >= 0 && idx < callbacks_.size()) {
    callbacks_[idx].timestamp = timestamp;
    callbacks_[idx].state = true;
  }
}

template <class T>
void CallbackTimer<T>::reset() {
  for (int i = 0; i < callbacks_.size(); ++i) {
    callbacks_[i].state = false;
  }
}
  
template <class T>
bool CallbackTimer<T>::isScheduling() const {
  for (int i = 0; i < callbacks_.size(); ++i) {
    if (callbacks_[i].state) return true;
  }
  return false;
}

template <class T>
void CallbackTimer<T>::adjustTime(const TimeDiff timestamp, int duration) {
  TimeDiff adjusted_time = timestamp + duration;
  for (int i = 0; i < callbacks_.size(); ++i) {
    callbacks_[i].timestamp = adjusted_time;
  }
}
  
//--------------------------------------------------------------
// private methods implementations
//--------------------------------------------------------------
template <class T>
int CallbackTimer<T>::convertToIndex(T type) const {
  int idx = -1;
  for (int i = 0; i < callbacks_.size(); ++i) {
    if (callbacks_[i].type == type) {
      idx = i;
      break;
    }
  }
  return idx;
}

template <class T>
void CallbackTimer<T>::initCallbacks(const std::vector<T>& types) {
  callbacks_.resize(types.size());
  // assert: all elements in the callback_timers_ are unique types
  for (int i = 0; i < callbacks_.size(); ++i) {
    Callback callback = {
      .type = types[i], .state = false, .timestamp = 0
    };
    callbacks_[i] = callback;
  }
}

  
}  // namespace lib_animation
