//
//  shape_animation_helper.h
//

#include "Environment.h"
#include "KG.h"
#include "Animation.h"
#include "Shape.h"


namespace cellophane {
  
namespace ns_shape {

  
// aliases
using Types = lib_animation::Types;
using Transition = lib_animation::Transition;
using Shape = ns_shape::Shape;
  
  
void animate(Shape* shape, KG::Params param, const TimeDiff timestamp,
             int duration, Types type, float value);
void animate(Shape* shape, KG::Params param, const TimeDiff timestamp,
             int duration, Types type, float start, float end);
void animateLinearly(Shape* shape, KG::Params param, const TimeDiff timestamp,
                     int duration, float value);
void animateLinearly(Shape* shape, KG::Params param, const TimeDiff timestamp,
                     int duration, float start, float end);
  

}  // namespace ns_shape
  
}  // namespace cellophane
