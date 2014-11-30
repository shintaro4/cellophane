//
//  Animation.h
//

#pragma once

#include "ofMain.h"
#include "Easing.h"


namespace lib_animation {

  
//--------------------------------------------------------------
// types
//--------------------------------------------------------------
enum Types {
  kEaseInLinear, kEaseOutCubic, kEaseInCubic, kEaseOutExpo, kEaseInExpo,
  kEaseOutCirc
};

struct Transition {
  bool trigger;
  Poco::Timestamp::TimeDiff timestamp;
  int duration;
  Types type;
  float start;
  float end;
};
  
struct Motion {
  Transition trans;
  bool changed;
  float value;
};


//--------------------------------------------------------------
// helpers
//--------------------------------------------------------------
Transition createTransition(const Poco::Timestamp::TimeDiff timestamp,
                            int duration, Types type, float start, float end);
  
  
class Animation {
  
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  explicit Animation(int param_size);

  const std::vector<Motion>& update(const Poco::Timestamp::TimeDiff
                                    current_time);

  float getTransitionEnd(int param_idx) const;
  bool getTransitionTrigger(int param_idx) const;
  void setTransitionTrigger(int param_idx, bool trigger);
  void stopTransitions();
  
  Transition getTransition(int param_idx) const;
  void setTransition(int param_idx, Transition trans);
  void adjustTransitions(const Poco::Timestamp::TimeDiff timestamp,
                         int duration);
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Animation(const Animation&);
  Animation& operator=(const Animation&);
  
  float easing(Types type, float time, float base, float change,
               float duration);

  void initMotions(int param_size);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::vector<Motion> motions_;
  
};


}  // namespace lib_animation
