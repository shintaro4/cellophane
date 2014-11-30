//
//  sound_helper.mm
//

#include "sound_helper.h"
#include "Timekeeper.h"


namespace cellophane {
  
namespace ns_sound {


const std::pair<int, int> getPresetBaseKeyRange(int preset_number) {
  if (preset_number < 0 || preset_number >= Synth::kPresetSize) {
    preset_number = 0;
  }
  return std::make_pair(Synth::kPresetBaseKeyRanges[preset_number][0],
                        Synth::kPresetBaseKeyRanges[preset_number][1]);
}

int createDurationByCA(BaseCA* ca) {
  const int step_time = Timekeeper::getInstance().getStepTime();
  const int min_duration = step_time * 2;
  const int max_duration = step_time * 8;
  const float ratio = ca->getLiveRatio();
  return static_cast<int>(ofMap(ratio, 0.0f, 1.0f,
                                min_duration, max_duration));
}

float createVelocity(EGTypes eg_type) {
  const int range = KS::kTrackVelocitySteps + 1;
  const int step = static_cast<int>(ofRandom(range));
  return createVelocity(eg_type, step);
}

float createVelocityByCA(EGTypes eg_type, BaseCA* ca)  {
  const float ratio = ca->getLiveRatioWithRandomRange();
  const int step = static_cast<int>(ratio * KS::kTrackVelocitySteps);
  return createVelocity(eg_type, step);
}

float createVelocity(EGTypes eg_type, int step) {
  return KS::kVelocityOffset + KS::kTrackVelocityUnit * step;
}
  
float createPan(float x) {
  float pan = x / ofGetWidth();
  if (pan < 0.0f) {
    pan = 0.0f;
  } else if (pan > 1.0f) {
    pan = 1.0f;
  }
  const float base = (1.0f - KS::kPanRange) * 0.5f;
  
  return base + pan * KS::kPanRange;
}

const Sound::SynthArgs
createUserArgs(int note_number, EGTypes eg_type, float x, BaseCA* ca) {
  const Sound::SynthArgs args = {
    .duration = ns_sound::createDurationByCA(ca),
    .note_number = note_number,
    .velocity = ns_sound::createVelocityByCA(eg_type, ca),
    .eg_type = eg_type,
    .pan = ns_sound::createPan(x)
  };
  return args;
}
  
const Sound::SynthArgs
createPlayerArgs(int duration, int note_number, EGTypes eg_type, float x,
                 BaseCA* ca) {
  const Sound::SynthArgs args = {
    .duration = duration,
    .note_number = note_number,
    .velocity = ns_sound::createVelocityByCA(eg_type, ca),
    .eg_type = eg_type,
    .pan = ns_sound::createPan(x)
  };
  return args;
}
  
const Sound::SynthArgs
createSEArgs(int duration, int note_number, EGTypes eg_type, float x) {
  const Sound::SynthArgs args = {
    .duration = duration,
    .note_number = note_number,
    .velocity = ns_sound::createVelocity(eg_type),
    .eg_type = eg_type,
    .pan = ns_sound::createPan(x)
  };
  return args;
}

  
}  // namespace ns_sound
  
}  // namespace cellophane
