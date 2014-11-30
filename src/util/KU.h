//
//  KU.h
//

#pragma once

#include "KT.h"


namespace cellophane {
  

class KU {

public:
  
  //--------------------------------------------------------------
  // ui constants
  //--------------------------------------------------------------

  enum FocusTypes {
    kNavigationFocus, kUIFocus, kCompositionFocus
  };
  
  enum Options {
    kWindowOption, kNoneOption, kStepsOption, kColorOption, kClearOption
  };
  
  enum Modes {
    kCompositionMode, kUIMode
  };
  
  struct UIEventArgs {
    KU::Options option;
    int member_id;
    int value;
  };
  
private:

  KU();
  KU(const KU&);
  KU& operator=(const KU&);

};

  
}  // namespace cellophane
