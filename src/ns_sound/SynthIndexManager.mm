//
//  SynthIndexManager.mm
//

#include "SynthIndexManager.h"


namespace cellophane {
  
namespace ns_sound {
    

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
SynthIndexManager::SynthIndexManager(int inst_size, int se_size)
    : inst_size_(inst_size), se_size_(se_size), inst_idx_(0), se_idx_(0) {}
    
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
int SynthIndexManager::nextInst() {
  mutex_.lock();
  int idx = inst_idx_;
  inst_idx_ = (++inst_idx_ % inst_size_);
  mutex_.unlock();
  return idx;
}
  
int SynthIndexManager::prevInst() {
  mutex_.lock();
  int idx = (inst_idx_ > 0) ? inst_idx_ - 1 : inst_size_ - 1;
  mutex_.unlock();
  return idx;
}
  
int SynthIndexManager::nextSE() {
  mutex_.lock();
  int idx = se_idx_;
  se_idx_ = (++se_idx_ % se_size_);
  mutex_.unlock();
  return inst_size_ + idx;
}
  
int SynthIndexManager::prevSE() {
  mutex_.lock();
  int idx = (se_idx_ > 0) ? se_idx_ - 1 : se_size_ - 1;
  mutex_.unlock();
  return inst_size_ + idx;
}
  
  
}  // namespace ns_sound
  
}  // namespace cellophane