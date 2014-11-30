//
//  Delay.h
//

#pragma once

#include "ofMain.h"


namespace lib_maximplus {


class Delay {
  
public:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kMaxDelayTime;
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Delay();
  
  float apply(float input);
  float apply(float input, int time);
  float apply(float input, int time, float feedback);

  int   getTime() const;
  void  setTime(int time);
  float getFeedback() const;
  void  setFeedback(float feedback);
  float getLevel() const;
  void  setLevel(float level);
  void  clearDelayLine();
  
private:

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  int time_;
  float feedback_;
  float level_;
  int phase_;
  std::vector<float> delay_line_;
  
};
  

}  // namespace lib_maximplus
