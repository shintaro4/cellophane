//
//  PlayerCA.h
//

#pragma once

#include "BaseCellularAutomata.h"


namespace cellophane {
  
namespace ns_composition {
    
    
class PlayerCA : public BaseCellularAutomata {
      
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
      
  explicit PlayerCA(int rule_number);
  PlayerCA(int rule_number, int cell_sequence_number);

  virtual void update();
  virtual int getLiveCellIndexInRange(int range);
  virtual float getLiveRatioInRange(int range);

  int getMaskSequenceNumber();
  void setMaskSequenceByNumber(int mask_sequence_number);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  PlayerCA(const PlayerCA&);
  PlayerCA& operator=(const PlayerCA&);

  void resetCellSequenceStrictly();
  void initMaskSequence(int mask_sequence_number);

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::deque<bool> mask_sequence_;

};
    
    
}  // namespace ns_composition
  
}  // namespace cellophane
