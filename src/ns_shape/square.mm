//
//  square.mm
//

#include "square.h"


namespace cellophane {
  
namespace ns_shape {
  
namespace square {


//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------
  
// square shape's vertex number:
//
//  3            0
//
//
//
//
//
//  2            1
//
const ofVec3f getVertexVector(float angle, float size, int vertex_number) {
  float side = getAdjustedWidth(angle, size);
  float half = side * 0.5f;
  ofVec3f vec(0, 0, 0);
    
  if (vertex_number == 0) { // top-right
    vec.set(half, -half);
  } else if (vertex_number == 1) { // bottom-right
    vec.set(half, half);
  } else if (vertex_number == 2) { // bottom-left
    vec.set(-half, half);
  } else if (vertex_number == 3) { // top-left
    vec.set(-half, -half);
  }
    
  return vec.getRotated(angle, ofVec3f(0, 0, 1));
}
  
float getAdjustedWidth(float angle, float size) {
  float side = size;
  if (angle < 0.0f) angle += 360.0f;
  if (angle == 45.0f || angle == 135.0f ||
      angle == 225.0f || angle == 315.0f) side *= 0.707106781f;
  return side;
}
  
float getAdjustedHeight(float angle, float size) {
  return getAdjustedWidth(angle, size);
}
  
void draw(float width, float height) {
  ofRect(-width * 0.5f, -height * 0.5f, width, height);
}

  
}  // namespace square

}  // namespace ns_shape

}  // namespace cellophane
