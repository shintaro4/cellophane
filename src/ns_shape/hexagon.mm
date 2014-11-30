//
//  hexagon.mm
//

#include "hexagon.h"


namespace cellophane {
  
namespace ns_shape {
  
namespace hexagon {


//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------

// hexagon shape's vertex number:
//
//     5     0
//
//  4           1
//
//     3     2
//
const ofVec3f getVertexVector(float angle, float size, int vertex_number) {
  float width = getAdjustedWidth(angle, size);
  float height = getAdjustedHeight(angle, size);
  ofVec3f vec(0, 0, 0);
    
  if (vertex_number == 0) {        // top-right
    vec.set(width * 0.25f, -height * 0.5f);
  } else if (vertex_number == 1) { // middle-right
    vec.set(width * 0.5f, 0.0f);
  } else if (vertex_number == 2) { // bottom-right
    vec.set(width * 0.25f, height * 0.5f);
  } else if (vertex_number == 3) { // bottom-left
    vec.set(-width * 0.25f, height * 0.5f);
  } else if (vertex_number == 4) { // middle-left
    vec.set(-width * 0.5f, 0.0f);
  } else if (vertex_number == 5) { // top-left
    vec.set(-width * 0.25f, -height * 0.5f);
  }
    
  return vec.getRotated(angle, ofVec3f(0, 0, 1));
}
  
float getAdjustedWidth(float angle, float size) {
  //return size * scale;
  float side = size;
  if (angle < 0.0f) angle += 360.0f;
  if (angle == 30.0f || angle == 90.0f || angle == 150.0f ||
      angle == 210.0f || angle == 270.0f || angle == 330.0f) {
    side *= 0.866025403f;
  }
  return side;
}
  
float getAdjustedHeight(float angle, float size) {
  float side = getAdjustedWidth(angle, size);
  return side * 0.866025403f;
}
  
void draw(float width, float height) {
  ofBeginShape();
  ofVertex(width * 0.25f, -height * 0.5f);
  ofVertex(width * 0.5f, 0.0f);
  ofVertex(width * 0.25f, height * 0.5f);
  ofVertex(-width * 0.25f, height * 0.5f);
  ofVertex(-width * 0.5f, 0.0f);
  ofVertex(-width * 0.25f, -height * 0.5f);
  ofEndShape();
}

  
}  // namespace hexagon

}  // namespace ns_shape

}  // namespace cellophane
