//
//  KL.h
//

#pragma once 


namespace cellophane {
  
  
class KL {
    
public:
    
  //--------------------------------------------------------------
  // layer constants
  //--------------------------------------------------------------

  enum TouchModes {
    kNoneMode, kHoldMode, kDragMode
  };
  
  static const int kTouchDetectDurationThreshold;
  
private:
    
  KL();
  KL(const KL&);
  KL& operator=(const KL&);
  
};
  
  
}  // namespace cellophane
