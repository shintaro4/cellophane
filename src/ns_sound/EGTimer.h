//
//  EGTimer.h
//

#pragma once

#include "k_aliases.h"
#include "Envelope.h"


namespace cellophane {
  
namespace ns_sound {
    

// aliases
using EG = lib_maximplus::Envelope;

  
class EGTimer {

public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  EGTimer();
  
  bool trigger(const TimeDiff current_time) const;
  void setTimer(const TimeDiff timestamp, int duration,
                float velocity, EG::Types eg_type);
  void setEG(EG& eg);
  bool getState() const;
  void reset();
  
private:
  
  EGTimer(const EGTimer&);
  EGTimer& operator=(const EGTimer&);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  bool state_;
  TimeDiff timestamp_;
  int duration_;
  float velocity_;
  EG::Types eg_type_;
  
};

  
}  // namespace ns_sound
  
}  // namespace cellophane
