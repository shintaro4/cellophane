//
//  Shape.h
//

#pragma once

#include "BaseShape.h"
#include "CallbackTimer.h"


namespace cellophane {
  
namespace ns_shape {

  
// aliases
using CallbackTimer = lib_animation::CallbackTimer<KG::CallbackTypes>;

  
class Shape : public BaseShape {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Shape();
  Shape(bool state, const ShapeArgs& args, float layer_alpha);
  ~Shape();
  
  virtual void reset();
  virtual bool inside(const ofTouchEventArgs& touch) const;
  virtual void adjustTime(const TimeDiff timestamp, int duration);
  bool isCenter(const ofPoint& center) const;
  
  void set(const ShapeArgs& args);

  void resetVertices();

  bool triggerCallback(KG::CallbackTypes type,
                       const TimeDiff current_time) const;
  bool getCallbackState(KG::CallbackTypes type) const;
  void setCallbackState(KG::CallbackTypes type, bool trigger);
  void setCallback(KG::CallbackTypes type, const TimeDiff timestamp);
  bool isCallbackScheduling() const;

private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Shape(const Shape&);
  Shape& operator=(const Shape&);
  
  std::vector<ofPoint> collectVertices() const;
  
  bool recognizeByCross2D(const ofTouchEventArgs& touch) const;
  bool recognizeByDistance(const ofTouchEventArgs& touch) const;
  
  void initCallbackTimer();
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  std::vector<ofPoint> vertices_;
  CallbackTimer* callback_timer_;
  
};

  
}  // namespace ns_shape

}  // namespace cellophane
