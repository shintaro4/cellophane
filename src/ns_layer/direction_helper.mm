//
//  direction_helper.mm
//

#include "direction_helper.h"
#include "Environment.h"


namespace cellophane {
  
namespace ns_layer {

  
// aliases
using Env = cellophane::Environment;

  
const KG::Directions getDirection(const ofPoint& vec) {
  const ofVec3f unit_vec = vec.getNormalized();
  KG::Directions direction = KG::kSoutheast;
  for (int i = 0; i < KG::kDirectionSize; i += 2) {
    int start_dir = i;
    int end_dir = (start_dir == KG::kDirectionSize - 2) ? 0 : start_dir + 2;
    if (isInArea(unit_vec, start_dir, end_dir)) {
      direction = static_cast<KG::Directions>(i + 1);
      break;
    }
  }
  
  return direction;
}

const ofVec3f getDirectionVector(const ofPoint& vec) {
  return KG::kDirectionList[getDirection(vec)];
}

const ofVec3f getDirectionVector(KG::Directions direction) {
  return KG::kDirectionList[direction];
}

bool isInArea(const ofVec3f& vec, int start_dir, int end_dir) {
  const ofVec3f start_vec = KG::kDirectionList[start_dir];
  const ofVec3f end_vec = KG::kDirectionList[end_dir];
  ofVec3f start_crossed = start_vec.getCrossed(vec);
  ofVec3f end_crossed = end_vec.getCrossed(vec);
  
  return (start_crossed.z >= 0 && end_crossed.z < 0);
}

int mod(int a, int b) {
  // assert b > 1
  int result = a % b;
  return (result < 0) ? result + b : result;
}

  
}  // namespace ns_layer
  
}  // namespace cellophane
