//
//  UserCA.mm
//

#include "UserCA.h"
#include "ca_helper.h"


namespace cellophane {
  
namespace ns_composition {
    
    
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UserCA::UserCA(int rule_number) : BaseCellularAutomata(rule_number) {}
  
UserCA::UserCA(int rule_number, int cell_sequence_number)
    : BaseCellularAutomata(rule_number, cell_sequence_number) {}


//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UserCA::update() {
  mutex_.lock();
  std::deque<bool> next_sequence = ns_composition::next(rule_sequence_,
                                                        cell_sequence_);
  const int seq_number = ns_composition::convertToNumber(cell_sequence_);
  if (ns_composition::equal(next_sequence, cell_sequence_)) {
    if (++repeat_times_ >= kMaxCellSequenceRepeatTimes) {
      repeat_times_ = 0;
      resetCellSequence(seq_number);
    }
  } else {
    repeat_times_ = 0;
    cell_sequence_ = next_sequence;
  }
  
  // user ca shouldn't be dead
  if (ns_composition::isAllDead(cell_sequence_)) resetCellSequence(seq_number);

  mutex_.unlock();
}
  

}  // namespace ns_composition
  
}  // namespace cellophane
