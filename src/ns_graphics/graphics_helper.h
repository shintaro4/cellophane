//
//  graphics_helper.h
//

#pragma once

#include "Graphics.h"


namespace cellophane {
  
namespace ns_graphics {
    

int mapOnDuration(int sound_duration);
  
const ofPoint convertToGridPoint(float x, float y);
const ofPoint convertToGridPoint(const ofPoint& point);
const ofPoint convertToGridPoint(const ofTouchEventArgs& touch);
int findShapeSizeIndex(float shape_size);
float findGridSize(float shape_size);
const ofPoint findGridPoint(const Shape* shape);
const ofPoint findDestinationGridPoint(const Shape* shape,
                                       const ofVec3f& dir_vec);
  
std::vector<ofPoint> collectNeighbors(const ofPoint& center, float grid_size,
                                      int start_idx, int idx_increment);
std::vector<ofPoint> collectAllNeighbors(const ofPoint& center,
                                         float grid_size);
std::vector<ofPoint> collectCornerNeighbors(const ofPoint& center,
                                            float grid_size);
std::vector<ofPoint> collectCrossNeighbors(const ofPoint& center,
                                           float grid_size);
  
  
}  // namespace ns_composition
  
}  // namespace cellophane