//
//  KD.h
//

#pragma once

#include "k_aliases.h"


namespace cellophane {
  
  
class KD {
    
public:
    
  //--------------------------------------------------------------
  // default value constants
  //--------------------------------------------------------------

  static const int kDefaultFPS;
  static const int kDefaultCircleResolution;
  static const int kSampleRate;
  static const int kChannels;
  static const int kBufferSize;
  
  static const bool kDefaultTrackFilling;
  static const TimeDiff kDefaultCARunnerTriggerTime;
  static const int kDefaultPaletteIndex;
  
private:
  
  KD();
  KD(const KD&);
  KD& operator=(const KD&);
  
};
  
  
}  // namespace cellophane
