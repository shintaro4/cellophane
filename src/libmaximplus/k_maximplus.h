//
//  k_maximplus.h
//  MaximilianLab
//
//  Created by shinta on 9/3/13.
//
//

#pragma once

#include "ofMain.h"


namespace lib_maximplus {

  
const int kAudioSampleRate = 44100;
const u_int32_t kSecondInMicroSeconds =  1000000;

const int kMicroSecondsPerSample =
  static_cast<int>(round(kSecondInMicroSeconds /
                         static_cast<float>(kAudioSampleRate)));
  
  
}  // namespace lib_maximplus