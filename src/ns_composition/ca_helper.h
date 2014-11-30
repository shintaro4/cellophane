//
//  ca_helper.h
//

#pragma once

#include "BaseCellularAutomata.h"


namespace cellophane {
  
namespace ns_composition {


const std::deque<bool> next(const std::deque<bool>& rule,
                            const std::deque<bool>& seq);
  
int convertToNumber(const std::deque<bool>& seq);
void convertToSequence(int number, std::deque<bool>& seq);
  
const std::vector<int>
collectLiveIndices(const std::deque<bool>& seq, int range);
const std::vector<int>
collectMaskedLiveIndices(const std::deque<bool>& seq,
                         const std::deque<bool>& mask, int range);
  
bool equal(const std::deque<bool>& lhs, const std::deque<bool>& rhs);
bool isAllDead(const std::deque<bool>& seq);
bool isAllDead(const std::deque<bool>& seq, const std::deque<bool>& mask);
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
