//
//  ShapeIndexManager.h
//

#pragma once

#include "KG.h"
#include "IndexLog.h"


namespace cellophane {

namespace ns_graphics {
    
  
class ShapeIndexManager {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  ShapeIndexManager();
  ShapeIndexManager(const std::deque<int>& indices, IndexLog* index_log);
  ~ShapeIndexManager();
  
  bool release(int idx);
  int allocate(const TimeDiff timestamp);
  int shrink(const TimeDiff timestamp);
  void updateTimestamp(int idx);
  void reset();
  
  void setIgnoreIndex(int ignore_idx);
  void resetIgnoreIndex();
  
  const std::deque<int>& getIndices() const;
  const std::vector<TimeDiff> getReducedTimestamps();
  
private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const int kShrinkThreshold;
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  ShapeIndexManager(const ShapeIndexManager&);
  ShapeIndexManager& operator=(const ShapeIndexManager&);

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::deque<int> indices_;
  IndexLog* index_log_;
  ofMutex mutex_;
  
};
  

}  // namespace ns_graphics
  
}  // namespace cellophane
