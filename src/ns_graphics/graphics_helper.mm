//
//  graphics_helper.mm
//

#include "graphics_helper.h"
#include "KT.h"
#include "Environment.h"
#include "direction_helper.h"
#include "KD.h"


namespace cellophane {
  
namespace ns_graphics {
  
  
// aliases
using Env = cellophane::Environment;
using Shape = cellophane::ns_shape::Shape;
  

int mapOnDuration(int sound_duration) {
  return static_cast<int>(ofMap(sound_duration,
                                KT::kMinSoundDuration, KT::kMaxSoundDuration,
                                KT::kMinDeployDuration, KT::kMaxDeployDuration)
                          );
}
 
const ofPoint convertToGridPoint(float x, float y) {
  return ofPoint(Env::getInstance().convertToGridValue(x),
                 Env::getInstance().convertToGridValue(y));
}

const ofPoint convertToGridPoint(const ofPoint& point) {
  return convertToGridPoint(point.x, point.y);
}
  
const ofPoint convertToGridPoint(const ofTouchEventArgs& touch) {
  return convertToGridPoint(touch.x, touch.y);
}
  
int findShapeSizeIndex(float shape_size) {
  const int idx = Env::getInstance().getShapeSizeIndex(shape_size);
  return (idx < 0) ? 0 : idx;
}
  
float findGridSize(float shape_size) {
  const int idx = findShapeSizeIndex(shape_size);
  return Env::getInstance().getShapeSize(idx);
}

const ofPoint findGridPoint(const Shape* shape) {
  return convertToGridPoint(shape->getCurrentValue(KG::kXParam),
                            shape->getCurrentValue(KG::kYParam));
}
  
const ofPoint findDestinationGridPoint(const Shape* shape,
                                       const ofVec3f& dir_vec) {
  const ofPoint grid_point = findGridPoint(shape);
  const int shape_idx = findShapeSizeIndex(shape->getSize());
  const int inverted_idx = Env::kNumberOfShapeSize - 1 - shape_idx;
  const float size = Env::getInstance().getShapeSize(inverted_idx);
  const ofVec3f vec = dir_vec * size;
  return ofPoint(grid_point + vec);
}

std::vector<ofPoint> collectNeighbors(const ofPoint& center, float grid_size,
                                      int start_idx, int idx_increment) {
  std::vector<ofPoint> neighbors;
  if (grid_size <= Env::getInstance().getGridResolution()) {
    neighbors.push_back(center);
  } else {
    const float half_size = grid_size / 2;
    for (int i = start_idx; i < KG::kDirectionSize; i += idx_increment) {
      const ofVec3f vec(KG::kDirectionList[i] * half_size);
      neighbors.push_back(ofPoint(center + vec));
    }
  }
  return neighbors;
}
  
std::vector<ofPoint> collectAllNeighbors(const ofPoint& center,
                                         float grid_size) {
  return collectNeighbors(center, grid_size, 1, 2);
}
  
std::vector<ofPoint> collectCornerNeighbors(const ofPoint& center,
                                            float grid_size) {
  return collectNeighbors(center, grid_size, 1, 4);
}
  
std::vector<ofPoint> collectCrossNeighbors(const ofPoint& center,
                                           float grid_size) {
  return collectNeighbors(center, grid_size, 3, 4);
}

  
}  // namespace ns_composition
  
}  // namespace cellophane
