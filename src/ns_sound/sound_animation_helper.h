//
//  sound_animation_helper.h
//

#pragma once

#include "KS.h"
#include "Animation.h"
#include "SimpleSynth.h"


namespace cellophane {
  
namespace ns_sound {

  
// aliases
using Types = lib_animation::Types;
using Transition = lib_animation::Transition;
using Synth = cellophane::ns_sound::SimpleSynth;
  

void animate(Synth* synth, KS::Params param,
             const TimeDiff timestamp, int duration, Types type,
             float value);
void animate(Synth* synth, KS::Params param,
             const TimeDiff timestamp, int duration, Types type,
             float start, float end);

void animateLinearly(Synth* synth, KS::Params param,
                     const TimeDiff timestamp, int duration,
                     float value);
void animateLinearly(Synth* synth, KS::Params param,
                     const TimeDiff timestamp, int duration,
                     float start, float end);


}  // namespace ns_sound
  
}  // namespace cellophane
