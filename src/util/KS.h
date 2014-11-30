//
//  KS.h
//

#pragma once

#include "k_aliases.h"
#include "Envelope.h"
#include "KT.h"
#include "KC.h"


namespace cellophane {

  
// aliases
using EGTypes = lib_maximplus::Envelope::Types;
  
  
class KS {

public:

  //--------------------------------------------------------------
  // sound constants
  //--------------------------------------------------------------

  enum CallbackTypes {
    kAssignCallback
  };

  enum Params {
    kVCAAmplifierParam, kLFOFrequencyParam
  };

  // Sound
  static const int kTrackInstSize;
  static const int kTrackSESize;
  static const int kTrackSynthSize;
  
  // Params
  static const int kParamSize;

  // Velocity
  static const float kVelocityOffset;
  static const int kTrackVelocitySteps;
  static const float kTrackVelocityUnit;
  
  // Pan
  static const float kPanRange;

  // Synth Presets
  static const int kSynthPresetMap[KC::kPaletteSize][KT::kTotalTrackSize];
  
private:
  
  KS();
  KS(const KS&);
  KS& operator=(const KS&);
  
};

  
}  // namespace cellophane
