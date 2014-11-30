//
//  direction_helper.h
//

#pragma once

#include "KG.h"


namespace cellophane {
  
namespace ns_layer {
    

const KG::Directions getDirection(const ofPoint& vec);
const ofVec3f getDirectionVector(const ofPoint& vec);
const ofVec3f getDirectionVector(KG::Directions direction);

bool isInArea(const ofVec3f& vec, int start_dir, int end_dir);

int mod(int a, int b);
  
  
}  // namespace ns_layer
  
}  // namespace cellophane
