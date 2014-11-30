//
//  equilateral.mm
//

#include "equilateral.h"


namespace cellophane {
  
namespace ns_shape {
  
namespace equilateral {

  
//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------
  
// equilateral triangle shape's vertex number:
//
//        0
//
//
//
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
  return size;
}
  
float getAdjustedHeight(float angle, float size) {
  return size * 0.866025403f;
}
  
void draw(float width, float height) {
  ofTriangle(-width * 0.5f, height * 0.333333f,
             0.0f, -height * 0.666666f,
             width * 0.5f, height * 0.333333f);
}

  
}  // namespace equilateral

}  // namespace ns_shape

}  // namespace cellophane
