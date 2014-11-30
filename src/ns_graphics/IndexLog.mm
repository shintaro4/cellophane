//
//  IndexLog.mm
//

#include "IndexLog.h"
#include "Timekeeper.h"


namespace cellophane {
  
namespace ns_graphics {
    

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
IndexLog::IndexLog(int size) {
  // use a vector as a static array
  timestamps_.resize(size, -1);
}

IndexLog::IndexLog(const std::vector<TimeDiff>& timestamps)
    : ignore_idx_(-1), timestamps_(timestamps) {}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void IndexLog::reset() {
  resetIgnoreIndex();
  for (int i = 0; i < timestamps_.size(); ++i) timestamps_[i] = -1;
}

void IndexLog::set(int idx, const TimeDiff timestamp) {
  if (idx < 0 || idx >= timestamps_.size()) return;
  timestamps_[idx] = timestamp;
}

void IndexLog::updateTimestamp(int idx) {
  if (idx < 0 || idx >= timestamps_.size() ||
      timestamps_[idx] == -1) return;
  timestamps_[idx] = Timekeeper::getInstance().getElapsed();
}
  
int IndexLog::getIndexByOldest() const {
  int idx = -1;
  TimeDiff oldest = -1;
  for (int i = 0; i < timestamps_.size(); ++i) {
    if (i == ignore_idx_) continue;
    
    if (timestamps_[i] >= 0) {
      if (oldest < 0 || timestamps_[i] < oldest) {
        idx = i;
        oldest = timestamps_[i];
      }
    }
  }
  return idx;
}
  
int IndexLog::getIndexSafely() const {
  const int idx = getIndexByOldest();
  return (idx != -1) ? idx : getIndexByRandom();
}
  
void IndexLog::resetIgnoreIndex() {
  ignore_idx_ = -1;
}

void IndexLog::setIgnoreIndex(int ignore_idx) {
  if (ignore_idx < 0 || ignore_idx >= timestamps_.size()) return;
  ignore_idx_ = ignore_idx;
}
  
int IndexLog::getSize() const {
  return timestamps_.size();
}
  
const std::vector<TimeDiff> IndexLog::getTimestamps() const {
  return timestamps_;
}

const std::vector<TimeDiff> IndexLog::getReducedTimestamps() const {
  std::vector<TimeDiff> reduced;
  reduced.resize(timestamps_.size(), -1);
  
  for (int i = 0; i < timestamps_.size(); ++i) {
    if (timestamps_[i] >= 0) {
      int order = 1;
      for (int j = 0; j < timestamps_.size(); ++j) {
        if (timestamps_[j] >= 0 && timestamps_[j] < timestamps_[i]) ++order;
      }
      reduced[i] = order;
    }
  }
  
  return reduced;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
int IndexLog::getIndexByRandom() const {
  int idx = static_cast<int>(ofRandom(timestamps_.size()));
  while (idx == ignore_idx_) {
    idx = static_cast<int>(ofRandom(timestamps_.size()));
  }
  return idx;
}
  
  
}  // namespace ns_graphics

}  // namespace cellophane