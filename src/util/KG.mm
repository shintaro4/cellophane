//
//  KG.mm
//

#include "KG.h"


namespace cellophane {
  

//--------------------------------------------------------------
// graphics constants
//--------------------------------------------------------------
// Graphics
const int KG::kTrackShapeSize = 16;

// Callbacks
const KG::CallbackTypes KG::kCallbackTypeList[kCallbackTypeSize] = {
  kDeployCallback, kUndeployCallback, kMovedCallback
};

// Params
const int KG::kParamSize = 9;

// Shape
const float KG::kShapeLineWidth = 2.0f;
  
// Direction
const ofVec3f KG::kDirectionList[kDirectionSize] = {
  ofVec3f(0.92388f,   0.382683f,  0.0f),  // (kZeroDirection)
  ofVec3f(1.0f,       1.0f,       0.0f),  // kSoutheast
  ofVec3f(0.382683f,  0.92388f,   0.0f),
  ofVec3f(0.0f,       1.0f,       0.0f),  // kSouth
  ofVec3f(-0.382683f, 0.92388f,   0.0f),
  ofVec3f(-1.0f,      1.0f,       0.0f),  // kSouthwest
  ofVec3f(-0.92388f,  0.382683f,  0.0f),
  ofVec3f(-1.0f,      0.0f,       0.0f),  // kWest
  ofVec3f(-0.92388f,  -0.382683f, 0.0f),
  ofVec3f(-1.0f,      -1.0f,      0.0f),  // kNorthwest
  ofVec3f(-0.382683f, -0.92388f,  0.0f),
  ofVec3f(0.0f,       -1.0f,      0.0f),  // kNorth
  ofVec3f(0.382683f,  -0.92388f,  0.0f),
  ofVec3f(1.0f,       -1.0f,      0.0f),  // kNortheast
  ofVec3f(0.92388f,   -0.382683f, 0.0f),
  ofVec3f(1.0f,       0.0f,       0.0f)   // kEast
};


}  // namespace cellophane