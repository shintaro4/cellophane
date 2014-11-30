//
//  shape_animation_helper.mm
//

#include "shape_animation_helper.h"


namespace cellophane {
  
namespace ns_shape {
    

void animate(Shape* shape, KG::Params param, const TimeDiff timestamp,
             int duration, Types type, float value) {
  if (shape) {
    float start = shape->getCurrentValue(param);
    Transition trans = lib_animation::createTransition(timestamp, duration,
                                                       type, start, value);
    shape->setTransition(param, trans);
  }
}
  
void animate(Shape* shape, KG::Params param, const TimeDiff timestamp,
             int duration, Types type, float start, float end) {
  if (shape) {
    Transition trans = lib_animation::createTransition(timestamp, duration,
                                                       type, start, end);
    shape->setTransition(param, trans);
  }
}
  
void animateLinearly(Shape* shape, KG::Params param, const TimeDiff timestamp,
                     int duration, float value) {
  animate(shape, param, timestamp, duration,
          lib_animation::kEaseInLinear, value);
}
  
void animateLinearly(Shape* shape, KG::Params param, const TimeDiff timestamp,
                     int duration, float start, float end) {
  animate(shape, param, timestamp, duration,
          lib_animation::kEaseInLinear, start, end);
}
    

}  // namespace ns_shape
  
}  // namespace cellophane
