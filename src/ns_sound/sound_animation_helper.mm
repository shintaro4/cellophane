//
//  sound_animation_helper.mm
//

#include "sound_animation_helper.h"

namespace cellophane {
  
namespace ns_sound {

  
void animate(Synth* synth, KS::Params param, const TimeDiff timestamp,
             int duration, Types type, float value) {
  if (synth) {
    float start = synth->getCurrentValue(param);
    Transition trans = lib_animation::createTransition(timestamp, duration,
                                                       type, start, value);
    synth->setTransition(param, trans);
  }
}
  
void animate(Synth* synth, KS::Params param, const TimeDiff timestamp,
             int duration, Types type, float start, float end) {
  if (synth) {
    Transition trans = lib_animation::createTransition(timestamp, duration,
                                                       type, start, end);
    synth->setTransition(param, trans);
  }
}

void animateLinearly(Synth* synth, KS::Params param, const TimeDiff timestamp,
                     int duration, float value) {
  animate(synth, param, timestamp, duration,
          lib_animation::kEaseInLinear, value);
}

void animateLinearly(Synth* synth, KS::Params param, const TimeDiff timestamp,
                     int duration, float start, float end) {
  animate(synth, param, timestamp, duration,
          lib_animation::kEaseInLinear, start, end);
}


}  // namespace ns_sound

}  // namespace cellophane
