//
//  triangle.mm
//

#include "triangle.h"


namespace cellophane {
  
namespace ns_shape {

namespace triangle {

  
//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------
  
//  triangle(isosceles right triangle) shape's vertex number:
//
//        0
//
//
//  2           1
//
const ofVec3f getVertexVector(float angle, float size, int vertex_number) {
  float width = getAdjustedWidth(angle, size);
  float height = getAdjustedHeight(angle, size);
  ofVec3f vec(0, 0, 0);
    
  if (vertex_number == 0) {        // top-middle
    vec.set(0.0f, -height * 0.666666f);
  } else if (vertex_number == 1) { // bottom-right
    vec.set(width * 0.5f, height * 0.333333f);
  } else if (vertex_number == 2) { // bottom-left
    vec.set(-width * 0.5f, height * 0.333333f);
  }
    
  return vec.getRotated(angle, ofVec3f(0, 0, 1));
}
  
float getAdjustedWidth(float angle, float size) {
  float width = size;
  if (angle < 0.0f) angle += 360.0f;
  if (angle == 45.0f || angle == 135.0f ||
      angle == 225.0f || angle == 315.0f) width *= 0.707106781f;
  return width;
}
  
float getAdjustedHeight(float angle, float size) {
  float height = size * 0.5f;
  if (angle < 0.0f) angle += 360.0f;
  if (angle == 45.0f || angle == 135.0f ||
      angle == 225.0f || angle == 315.0f) height *= 0.707106781f;
  return height;
}
  
void draw(float width, float height) {
  ofTriangle(-width * 0.5f, height * 0.333333f,
             0.0f, -height * 0.666666f,
             width * 0.5f, height * 0.333333f);
}

  
}  // namespace triangle

}  // namespace ns_shape

}  // namespace cellophane
