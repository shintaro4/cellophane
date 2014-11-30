//
//  SynthIndexManager.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {
  
namespace ns_sound {
  
  
class SynthIndexManager {
        
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  SynthIndexManager(int inst_size, int se_size);
  
  int nextInst();
  int prevInst();
  int nextSE();
  int prevSE();

private:

  //--------------------------------------------------------------
  // memthods
  //--------------------------------------------------------------

  SynthIndexManager(const SynthIndexManager&);
  SynthIndexManager& operator=(const SynthIndexManager&);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  const int inst_size_;
  const int se_size_;
  
  int inst_idx_;
  int se_idx_;
  
  ofMutex mutex_;

};
  
  
}  // namespace ns_sound
  
}  // namespace cellophane