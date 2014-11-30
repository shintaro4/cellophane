//
//  KM.h
//

#pragma once

#include "Envelope.h"
#include "KT.h"
#include "KC.h"


namespace cellophane {
  
  
class KM {
    
public:
    
  //--------------------------------------------------------------
  // musical constants
  //--------------------------------------------------------------

  static const int kScaleListSize = 18;
  static const int kScaleDegreeSize = 12;
  static const int kScaleList[kScaleListSize][kScaleDegreeSize];
  
  static const int kScaleSetSize = 6;
  static const int kScaleSet[kScaleSetSize][2];
  
  static const int kStepsListSize = 6;
  static const int kStepsListItemSize = 9;
  static const int kStepsList[kStepsListSize][kStepsListItemSize];
  
  static const int kHoldingStepsSize = 16;
  static const int kHoldingSteps[kHoldingStepsSize];
  
  static const int kScaleMap[KC::kPaletteSize];
  static const int kStepsMap[KC::kPaletteSize][KT::kTotalTrackSize];
  static const int kHoldingStepsMap[KC::kPaletteSize][KT::kTotalTrackSize];
  
private:

  KM();
  KM(const KM&);
  KM& operator=(const KM&);

};

  
}  // namespace cellophane