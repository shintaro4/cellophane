//
//  TouchBuffer.mm
//

#include "Environment.h"
#include "TouchBuffer.h"
#include "KL.h"
#include "direction_helper.h"


namespace cellophane {

namespace ns_layer {
    
  
// aliases
using Env = cellophane::Environment;

  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
TouchBuffer::TouchBuffer() : touch_id_(0), source_(ofPoint()),num_touches_(0),
      grid_point_(ofPoint()), timestamp_(0) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void TouchBuffer::setBuffer(const ofTouchEventArgs& touch,
                            const TimeDiff timestamp) {
  touch_id_ = touch.id;
  source_.x = touch.x;
  source_.y = touch.y;
  num_touches_ = touch.numTouches;
  updateGridPoint();
  timestamp_ = timestamp;
}

bool TouchBuffer::isIgnoreEvent(const TimeDiff timestamp) const {
  return (timestamp - timestamp_ < KL::kTouchDetectDurationThreshold);
}
  
bool TouchBuffer::isSameGridPoint(const ofTouchEventArgs& touch) const {
  return (Env::getInstance().convertToGridValue(touch.x) == grid_point_.x &&
          Env::getInstance().convertToGridValue(touch.y) == grid_point_.y);
}
  
const ofVec3f TouchBuffer::getVector(const ofTouchEventArgs& touch) const {
  return ofVec3f(touch.x - source_.x, touch.y - source_.y);
}
  
ofPoint TouchBuffer::getGridPoint() const {
  return grid_point_;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void TouchBuffer::updateGridPoint() {
  grid_point_.x = Env::getInstance().convertToGridValue(source_.x);
  grid_point_.y = Env::getInstance().convertToGridValue(source_.y);
}
  
float TouchBuffer::getTouchDistance(const ofTouchEventArgs& touch) const {
  const ofVec3f distination(touch.x, touch.y);
  return distination.distance(source_);
}
 
  
}  // namespace ns_layer

}  // namespace cellophane
