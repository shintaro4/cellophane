//
//  TouchBuffer.h
//

#pragma once

#include "KG.h"


namespace cellophane {
  
namespace ns_layer {
  
  
class TouchBuffer {

public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  TouchBuffer();

  void setBuffer(const ofTouchEventArgs& touch, const TimeDiff timestamp);

  bool isIgnoreEvent(const TimeDiff timestamp) const;
  bool isSameGridPoint(const ofTouchEventArgs& touch) const;
  const ofVec3f getVector(const ofTouchEventArgs& touch) const;
  ofPoint getGridPoint() const;
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  TouchBuffer(const TouchBuffer&);
  TouchBuffer& operator=(const TouchBuffer&);
  
  void updateGridPoint();
  float getTouchDistance(const ofTouchEventArgs& touch) const;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  int touch_id_;
  ofPoint source_;
  int num_touches_;
  ofPoint grid_point_;
  TimeDiff timestamp_;
  
};


}  // namespace ns_layer
  
}  // namespace cellophane
