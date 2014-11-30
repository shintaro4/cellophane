//
//  circle.mm
//

#include "circle.h"


namespace cellophane {
  
namespace ns_shape {
  
namespace circle {


//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------

// circle shape's vertex number:
//
//        0
//    7       1
//
//  6           2
//
//    5       3
//        4
//
const ofVec3f getVertexVector(float angle, float size, int vertex_number) {
  float radius = getAdjustedWidth(angle, size) * 0.5f;
  float coefficient = radius * 0.707106781f; // 1 / sqrt(2)
  ofVec3f vec(0, 0, 0);
    
  if (vertex_number == 0) {        // top-middle
    vec.set(0.0f, -radius);
  } else if (vertex_number == 1) { // top-right
    vec.set(coefficient, -coefficient);
  } else if (vertex_number == 2) { // middle-right
    vec.set(radius, 0.0f);
  } else if (vertex_number == 3) { // bottom-right
    vec.set(coefficient, coefficient);
  } else if (vertex_number == 4) { // bottom-middle
    vec.set(0.0f, radius);
  } else if (vertex_number == 5) { // bottom-left
    vec.set(-coefficient, coefficient);
  } else if (vertex_number == 6) { // middle-left
    vec.set(-radius, 0.0f);
  } else if (vertex_number == 7) { // top-left
    vec.set(-coefficient, -coefficient);
  }
    
  return vec.getRotated(angle, ofVec3f(0, 0, 1));
}
  
float getAdjustedWidth(float angle, float size) {
  return size;
}
  
float getAdjustedHeight(float angle, float size) {
  return getAdjustedWidth(angle, size);
}
  
void draw(float width, float height) {
  ofEllipse(0.0f, 0.0f, width, height);
}

  
}  // namespace circle

}  // namespace ns_shape

}  // namespace cellophane
