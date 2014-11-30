//
//  IndexLog.h
//

#pragma once

#include "ofMain.h"
#include "k_aliases.h"


namespace cellophane {
  
namespace ns_graphics {
    
    
class IndexLog {
      
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  explicit IndexLog(int size);
  explicit IndexLog(const std::vector<TimeDiff>& timestamps);
  
  void reset();
  void set(int idx, const TimeDiff timestamp);
  void updateTimestamp(int idx);
  int getIndexByOldest() const;
  int getIndexSafely() const;
  
  void resetIgnoreIndex();
  void setIgnoreIndex(int ignore_idx);
  
  int getSize() const;
  const std::vector<TimeDiff> getTimestamps() const;
  const std::vector<TimeDiff> getReducedTimestamps() const;
  
private:
      
  //--------------------------------------------------------------
  // memthods
  //--------------------------------------------------------------

  IndexLog(const IndexLog&);
  IndexLog& operator=(const IndexLog&);

  int getIndexByRandom() const;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  int ignore_idx_;
  std::vector<TimeDiff> timestamps_;
  
};

  
}  // namespace ns_graphics

}  // namespace cellophane
