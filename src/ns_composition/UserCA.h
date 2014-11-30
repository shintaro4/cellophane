//
//  UserCA.h
//

#pragma once

#include "BaseCellularAutomata.h"


namespace cellophane {
  
namespace ns_composition {
    
  
class UserCA : public BaseCellularAutomata {
      
public:
      
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
      
  explicit UserCA(int rule_number);
  UserCA(int rule_number, int cell_sequence_number);
  
  virtual void update();
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  UserCA(const UserCA&);
  UserCA& operator=(const UserCA&);

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
};
    
    
}  // namespace ns_composition
  
}  // namespace cellophane
