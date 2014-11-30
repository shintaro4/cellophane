//
//  equilateral.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {

namespace ns_shape {
  
namespace equilateral {
  

const ofVec3f getVertexVector(float angle, float size, int vertex_number);
float getAdjustedWidth(float angle, float size);
float getAdjustedHeight(float angle, float size);
  
void draw(float width, float height);
  
const int kNumberOfVertices = 3;
const float kAngleStep = 60.0f;

  
}  // namespace equilateral

}  // namespace ns_shape

}  // namespace cellophane
