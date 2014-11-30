//
//  square.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {
  
namespace ns_shape {

namespace square {

  
const ofVec3f getVertexVector(float angle, float size, int vertex_number);
float getAdjustedWidth(float angle, float size);
float getAdjustedHeight(float angle, float size);
  
void draw(float width, float height);
  
const int kNumberOfVertices = 4;
const float kAngleStep = 45.0f;

  
}  // namespace square

}  // namespace ns_shape

}  // namespace cellophane
