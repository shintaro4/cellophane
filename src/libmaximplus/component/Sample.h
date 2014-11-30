//
//  Sample.h
//

#pragma once

#include "ofxMaxim.h"


namespace lib_maximplus {
  

class Sample {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Sample();
  
  float playOnce();
  float playOnce(float speed);
  bool load(const string& file_name);
  void reset();

  float getSpeed() const;
  void  setSpeed(float speed);
  
private:
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  maxiSample sample_;
  float speed_;
  
};


}  // namespace lib_maximplus
