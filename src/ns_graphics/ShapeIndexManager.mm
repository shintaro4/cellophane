//
//  ShapeIndexManager.mm
//

#include "ShapeIndexManager.h"


namespace cellophane {
  
namespace ns_graphics {
    

//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int ShapeIndexManager::kShrinkThreshold = KG::kTrackShapeSize / 2;
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
ShapeIndexManager::ShapeIndexManager()
    : index_log_(new IndexLog(KG::kTrackShapeSize)) {
  reset();
}
  
ShapeIndexManager::ShapeIndexManager(const std::deque<int>& indices,
                                     IndexLog* index_log)
  : indices_(indices), index_log_(index_log) {}
  
ShapeIndexManager::~ShapeIndexManager() {
  delete index_log_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
bool ShapeIndexManager::release(int idx) {
  bool success = false;
  mutex_.lock();
  if (std::find(indices_.begin(), indices_.end(), idx) == indices_.end()) {
    indices_.push_back(idx);
    index_log_->set(idx, -1);
    success = true;
  }
  mutex_.unlock();
  
  return success;
}

int ShapeIndexManager::allocate(const TimeDiff timestamp) {
  int idx = 0;
  mutex_.lock();
  if (indices_.empty()) {
    idx = index_log_->getIndexSafely();
  } else {
    idx = indices_.front();
    indices_.pop_front();
  }
  
  index_log_->set(idx, timestamp);
  mutex_.unlock();

  return idx;
}

int ShapeIndexManager::shrink(const TimeDiff timestamp) {
  mutex_.lock();
  int release_idx = -1;
  if (indices_.size() <= kShrinkThreshold) {
    release_idx = index_log_->getIndexByOldest();
  }
  // update timestamp
  if (release_idx >= 0) index_log_->set(release_idx, timestamp);
  mutex_.unlock();
  return release_idx;
}
  
void ShapeIndexManager::updateTimestamp(int idx) {
  mutex_.lock();
  if (std::find(indices_.begin(), indices_.end(), idx) == indices_.end()) {
    index_log_->updateTimestamp(idx);
  }
  mutex_.unlock();
}
  
void ShapeIndexManager::reset() {
  mutex_.lock();
  indices_.clear();
  index_log_->reset();
  for (int i = 0; i < index_log_->getSize(); ++i) indices_.push_back(i);
  mutex_.unlock();
}

void ShapeIndexManager::setIgnoreIndex(int ignore_idx) {
  mutex_.lock();
  index_log_->setIgnoreIndex(ignore_idx);
  mutex_.unlock();
}
  
void ShapeIndexManager::resetIgnoreIndex() {
  mutex_.lock();
  index_log_->resetIgnoreIndex();
  mutex_.unlock();
}
  
//--------------------------------------------------------------
// container setter/getter
//--------------------------------------------------------------
const std::deque<int>& ShapeIndexManager::getIndices() const {
  return indices_;
}
  
const std::vector<TimeDiff> ShapeIndexManager::getReducedTimestamps() {
  std::vector<TimeDiff> reduced;
  mutex_.lock();
  reduced = index_log_->getReducedTimestamps();
  mutex_.unlock();
  
  return reduced;
}

  
}  // namespace ns_graphics
  
}  // namespace cellophane
