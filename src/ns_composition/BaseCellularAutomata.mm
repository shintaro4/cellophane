//
//  BaseCellularAutomata.mm
//

#include "BaseCellularAutomata.h"
#include "ca_helper.h"
#include "KM.h"


namespace cellophane {
  
namespace ns_composition {
    
    
//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int BaseCellularAutomata::kRuleSequenceSize =  8;
const int BaseCellularAutomata::kMaxRuleNumber = 255;
const int BaseCellularAutomata::kCellSequenceSize = KM::kScaleDegreeSize;
const int BaseCellularAutomata::kMaxCellSequenceNumber =
    static_cast<int>(powf(2, kCellSequenceSize)) - 1;
const int BaseCellularAutomata::kDefaultCellSequenceNumber = 1;
const int BaseCellularAutomata::kMaxCellSequenceRepeatTimes = 4;
    
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
BaseCellularAutomata::BaseCellularAutomata(int rule_number) : repeat_times_(0) {
  initRuleSequence(rule_number);
  const int cell_sequence_number =
      static_cast<int>(ofRandom(kMaxCellSequenceNumber + 1));
  initCellSequence(cell_sequence_number);
}
    
BaseCellularAutomata::BaseCellularAutomata(int rule_number,
                                           int cell_sequence_number)
    : repeat_times_(0) {
  initRuleSequence(rule_number);
  initCellSequence(cell_sequence_number);
}
    
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void BaseCellularAutomata::reverse() {
  mutex_.lock();
  std::reverse(cell_sequence_.begin(), cell_sequence_.end());
  mutex_.unlock();
}
  
void BaseCellularAutomata::shuffle() {
  mutex_.lock();
  std::random_shuffle(cell_sequence_.begin(), cell_sequence_.end());
  mutex_.unlock();
}
  
void BaseCellularAutomata::rotate(int degree) {
  mutex_.lock();
  while (degree < 0) degree += cell_sequence_.size();
  while (degree >= cell_sequence_.size()) degree -= cell_sequence_.size();
  std::rotate(cell_sequence_.begin(), cell_sequence_.begin() + degree,
              cell_sequence_.end());
  mutex_.unlock();
}
  
void BaseCellularAutomata::invert() {
  mutex_.lock();
  for (int i = 0; i < cell_sequence_.size(); ++i) {
    cell_sequence_[i] = !cell_sequence_[i];
  }
  mutex_.unlock();
}
  
//--------------------------------------------------------------
// live cell converter
//--------------------------------------------------------------
int BaseCellularAutomata::getLiveCellIndex() {
  return getLiveCellIndexInRange(cell_sequence_.size());
}
  
int BaseCellularAutomata::getLiveCellIndexInRange(int range) {
  if (range <= 0 || range > cell_sequence_.size()) return -1;
  
  mutex_.lock();
  int cell_idx = -1;
  const std::vector<int> cell_indices =
      ns_composition::collectLiveIndices(cell_sequence_, range);
  if (!cell_indices.empty()) {
    const int idx = static_cast<int>(ofRandom(cell_indices.size()));
    cell_idx = cell_indices[idx];
  }
  mutex_.unlock();
  
  return cell_idx;
}
  
float BaseCellularAutomata::getLiveRatio() {
  return getLiveRatioInRange(cell_sequence_.size());
}
  
float BaseCellularAutomata::getLiveRatioInRange(int range) {
  if (range <= 0 || range > cell_sequence_.size()) return 0.0f;
  
  mutex_.lock();
  const std::vector<int> cell_indices =
      ns_composition::collectLiveIndices(cell_sequence_, range);
  mutex_.unlock();
  
  return cell_indices.size() / static_cast<float>(range);
}
  
float BaseCellularAutomata::getLiveRatioWithRandomRange() {
  const int range = static_cast<int>(ofRandom(1, cell_sequence_.size() + 1));
  return getLiveRatioInRange(range);
}
  
//--------------------------------------------------------------
// getter/setter with mutex
//--------------------------------------------------------------
int BaseCellularAutomata::getRuleNumber() {
  mutex_.lock();
  const int number = ns_composition::convertToNumber(rule_sequence_);
  mutex_.unlock();
  return number;
}
  
void BaseCellularAutomata::setRuleByNumber(int rule_number) {
  if (rule_number < 0 || rule_number > kMaxRuleNumber) return;
  
  mutex_.lock();
  ns_composition::convertToSequence(rule_number, rule_sequence_);
  mutex_.unlock();
}
  
int BaseCellularAutomata::getCellSequenceNumber() {
  mutex_.lock();
  const int number = ns_composition::convertToNumber(cell_sequence_);
  mutex_.unlock();
  return number;
}
  
void BaseCellularAutomata::setCellSequenceByNumber(int cell_sequence_number) {
  if (cell_sequence_number < 0 ||
      cell_sequence_number > kMaxCellSequenceNumber) return;
  
  mutex_.lock();
  repeat_times_ = 0;
  ns_composition::convertToSequence(cell_sequence_number, cell_sequence_);
  mutex_.unlock();
}

int BaseCellularAutomata::getRepeatTimes() const {
  return repeat_times_;
}
  
//--------------------------------------------------------------
// protected methods
//--------------------------------------------------------------
void BaseCellularAutomata::resetRuleSequence(int ignore_number) {
  // not allowed dead sequence
  int number = static_cast<int>(ofRandom(1, kMaxRuleNumber + 1));
  while (number == ignore_number) {
    number = static_cast<int>(ofRandom(1, kMaxRuleNumber + 1));
  }
  ns_composition::convertToSequence(number, rule_sequence_);
}
  
void BaseCellularAutomata::resetCellSequence(int ignore_number) {
  // not allowed dead sequence
  int number = static_cast<int>(ofRandom(1, kMaxCellSequenceNumber + 1));
  while (number == ignore_number) {
    number = static_cast<int>(ofRandom(1, kMaxCellSequenceNumber + 1));
  }
  ns_composition::convertToSequence(number, cell_sequence_);
}
  
//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void BaseCellularAutomata::initRuleSequence(int rule_number) {
  rule_sequence_ = std::deque<bool>(kRuleSequenceSize, false);
  setRuleByNumber(rule_number);
}
  
void BaseCellularAutomata::initCellSequence(int cell_sequence_number) {
  cell_sequence_ = std::deque<bool>(kCellSequenceSize, false);
  setCellSequenceByNumber(cell_sequence_number);
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
