//
//  circle.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {

namespace ns_shape {
  
namespace circle {

  
const ofVec3f getVertexVector(float angle, float size, int vertex_number);
float getAdjustedWidth(float angle, float size);
float getAdjustedHeight(float angle, float size);
  
void draw(float width, float height);
  
const int kNumberOfVertices = 8;
const float kAngleStep = 0.0f;

  
}  // namespace circle

}  // namespace ns_shape

}  // namespace cellophane
