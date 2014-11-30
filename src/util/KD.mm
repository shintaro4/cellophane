//
//  KD.mm
//

#include "KD.h"


namespace cellophane {
  
  
//--------------------------------------------------------------
// default value constants
//--------------------------------------------------------------
const int KD::kDefaultFPS =    60;
const int KD::kDefaultCircleResolution = 32;
const int KD::kSampleRate = 44100;
const int KD::kChannels   =     2;
const int KD::kBufferSize =  1024;

const bool KD::kDefaultTrackFilling = true;
const TimeDiff KD::kDefaultCARunnerTriggerTime = 0;
const int KD::kDefaultPaletteIndex = 0;

  
}  // namespace cellophane