//
//  ca_helper.mm
//

#include "ca_helper.h"
#include "KU.h"
#include "KM.h"
#include "KG.h"


namespace cellophane {
  
namespace ns_composition {
  

const std::deque<bool> next(const std::deque<bool>& rule,
                            const std::deque<bool>& seq) {
  std::deque<bool> next_sequence(seq.size(), false);
  for (int i = 0; i < seq.size(); ++i) {
    int left_idx = (i + seq.size() - 1) % seq.size();
    int left = (seq[left_idx]) ? 4 : 0;
    int center = (seq[i]) ? 2 : 0;
    int right_idx = (i + 1) % seq.size();
    int right = (seq[right_idx]) ? 1 : 0;
    next_sequence[i] = rule[left + center + right];
  }
  return next_sequence;
}
  
int convertToNumber(const std::deque<bool>& seq) {
  int number = 0;
  int bit = 1;
  for (int i = 0; i < seq.size(); ++i) {
    if (seq[i]) number += bit;
    bit *= 2;
  }
  return number;
}
  
void convertToSequence(int number, std::deque<bool>& seq) {
  int bit = 1;
  for (int i = 0; i < seq.size(); ++i) {
    seq[i] = (number & bit) ? true : false;
    bit <<= 1;
  }
}
  
const std::vector<int>
collectLiveIndices(const std::deque<bool>& seq, int range) {
  std::vector<int> indices;
  if (range > seq.size()) return indices;
  
  for (int i = 0; i < range; ++i) {
    if (seq[i]) indices.push_back(i);
  }
  return indices;
}

const std::vector<int>
collectMaskedLiveIndices(const std::deque<bool>& seq,
                         const std::deque<bool>& mask, int range) {
  std::vector<int> indices;
  if (range > seq.size()) return indices;
  
  for (int i = 0; i < range; ++i) {
    if (seq[i] && mask[i]) indices.push_back(i);
  }
  return indices;
}

bool equal(const std::deque<bool>& lhs, const std::deque<bool>& rhs) {
  if (lhs.size() != rhs.size()) return false;
  return std::equal(lhs.begin(), lhs.end(), rhs.begin());
}

bool isAllDead(const std::deque<bool>& seq) {
  for (int i = 0; i < seq.size(); ++i) {
    if (seq[i]) return false;
  }
  return true;
}
  
bool isAllDead(const std::deque<bool>& seq, const std::deque<bool>& mask) {
  if (seq.size() != mask.size()) return true;

  for (int i = 0; i < seq.size(); ++i) {
    if (seq[i] && mask[i]) return false;
  }
  return true;
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
