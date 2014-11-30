//
//  PlayerCA.mm
//

#include "PlayerCA.h"
#include "ca_helper.h"


namespace cellophane {
  
namespace ns_composition {
    
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
PlayerCA::PlayerCA(int rule_number) : BaseCellularAutomata(rule_number) {
  initMaskSequence(BaseCellularAutomata::kMaxCellSequenceNumber);
}
    
PlayerCA::PlayerCA(int rule_number, int cell_sequence_number)
    : BaseCellularAutomata(rule_number, cell_sequence_number) {
  initMaskSequence(BaseCellularAutomata::kMaxCellSequenceNumber);
}

//--------------------------------------------------------------
// public methiods
//--------------------------------------------------------------
void PlayerCA::update() {
  mutex_.lock();
  if (repeat_times_ >= kMaxCellSequenceRepeatTimes) {
    repeat_times_ = 0;
    resetCellSequenceStrictly();
  } else {
    std::deque<bool> next_sequence = ns_composition::next(rule_sequence_,
                                                          cell_sequence_);
    if (ns_composition::equal(next_sequence, cell_sequence_) ||
        ns_composition::isAllDead(next_sequence, mask_sequence_)) {
      ++repeat_times_;
    } else {
      repeat_times_ = 0;
      cell_sequence_ = next_sequence;
    }
  }
  mutex_.unlock();
}
  
int PlayerCA::getLiveCellIndexInRange(int range) {
  if (range <= 0 || range > cell_sequence_.size()) return -1;
  
  mutex_.lock();
  int cell_idx = -1;
  const std::vector<int> cell_indices =
      ns_composition::collectMaskedLiveIndices(cell_sequence_, mask_sequence_,
                                               range);
  if (!cell_indices.empty()) {
    const int idx = static_cast<int>(ofRandom(cell_indices.size()));
    cell_idx = cell_indices[idx];
  }
  mutex_.unlock();
  
  return cell_idx;
}

float PlayerCA::getLiveRatioInRange(int range) {
  if (range <= 0 || range > cell_sequence_.size()) return 0.0f;
  
  mutex_.lock();
  const std::vector<int> cell_indices =
      ns_composition::collectMaskedLiveIndices(cell_sequence_, mask_sequence_,
                                               range);
  const std::vector<int> mask_indices =
      ns_composition::collectLiveIndices(mask_sequence_, range);
  mutex_.unlock();
  
  const int mask_cell_size = mask_indices.size();
  if (mask_cell_size > 0) {
    return cell_indices.size() / static_cast<float>(mask_cell_size);
  } else {
    return 0.0f;
  }
}
  
//--------------------------------------------------------------
// getter/setter with mutex
//--------------------------------------------------------------
int PlayerCA::getMaskSequenceNumber() {
  mutex_.lock();
  const int number = ns_composition::convertToNumber(mask_sequence_);
  mutex_.unlock();
  return number;
}
  
void PlayerCA::setMaskSequenceByNumber(int mask_sequence_number) {
  // mask sequence should be live
  if (mask_sequence_number <= 0 ||
      mask_sequence_number > kMaxCellSequenceNumber) return;
  
  mutex_.lock();
  ns_composition::convertToSequence(mask_sequence_number, mask_sequence_);
  mutex_.unlock();
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void PlayerCA::resetCellSequenceStrictly() {
  const int seq_number = ns_composition::convertToNumber(cell_sequence_);
  resetCellSequence(seq_number);
  while (ns_composition::isAllDead(cell_sequence_, mask_sequence_)) {
    resetCellSequence(seq_number);
  }
}
  
//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void PlayerCA::initMaskSequence(int mask_sequence_number) {
  mask_sequence_ = std::deque<bool>(kCellSequenceSize, false);
  setMaskSequenceByNumber(mask_sequence_number);
}

    
}  // namespace ns_composition
  
}  // namespace cellophane
