//
//  hexagon.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {
  
namespace ns_shape {
  
namespace hexagon {

  
const ofVec3f getVertexVector(float angle, float size, int vertex_number);
float getAdjustedWidth(float angle, float size);
float getAdjustedHeight(float angle, float size);
  
void draw(float width, float height);
  
const int kNumberOfVertices = 6;
const float kAngleStep = 30.0f;

  
}  // namespace hexagon

}  // namespace ns_shape

}  // namespace cellophane
