//
//  KC.h
//

#pragma once

#include "KT.h"


namespace cellophane {
  
  
class KC {
    
public:
  
  //--------------------------------------------------------------
  // color constants
  //--------------------------------------------------------------

  static const int kBackgroundColor;
  
  static const int kPaletteListSize = 13;
  static const int kPaletteList[kPaletteListSize][KT::kTotalTrackSize];

  static const int kPaletteSize = 3;
  static const int KPaletteMap[kPaletteSize];
  
private:
  
  KC();
  KC(const KC&);
  KC& operator=(const KC&);
  
};
  
  
}  // namespace cellophane
