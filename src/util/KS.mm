//
//  KS.mm
//

#include "KS.h"


namespace cellophane {


// aliases
using EG = lib_maximplus::Envelope;

  
//--------------------------------------------------------------
// sound constants
//--------------------------------------------------------------
// Sound
const int KS::kTrackInstSize = 2;  // the size of synth for instrument
const int KS::kTrackSESize   = 3;  // the size of synth for SE
const int KS::kTrackSynthSize = kTrackInstSize + kTrackSESize;

// Params
const int KS::kParamSize = 4;

// Velocity
const float KS::kVelocityOffset = 0.5f;
const int KS::kTrackVelocitySteps = 4;
const float KS::kTrackVelocityUnit =
  (1.0f - kVelocityOffset) / kTrackVelocitySteps;
  
// Pan
const float KS::kPanRange = 0.5;
  
// Synth Presets
const int KS::kSynthPresetMap[KC::kPaletteSize][KT::kTotalTrackSize] = {
  // {track 0 (user), track 1, track 2, track 3}
  {6, 2, 5, 7},
  {0, 1, 6, 7},
  {7, 0, 1, 8},
  
};
  
  
}  // namespace cellophane
