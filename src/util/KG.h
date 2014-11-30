//
//  KG.h
//

#pragma once

#include "ofMain.h"
#include "k_aliases.h"


namespace cellophane {


class KG {

public:

  //--------------------------------------------------------------
  // graphics constants
  //--------------------------------------------------------------

  enum ShapeTypes {
    kSquareShape, kTriangleShape, kHexagonShape, kEquilateralShape, kCircleShape
  };

  enum CallbackTypes {
    kDeployCallback, kUndeployCallback, kMovedCallback
  };
  
  enum Params {
    kXParam, kYParam, kWidthParam, kHeightParam, kAngleParam, kAlphaParam,
    kHueParam, kSaturationParam, kBrightnessParam
  };
  
  enum Directions {
    kZeroDirection = 0,
    kSoutheast = 1, kSouth = 3, kSouthwest = 5, kWest = 7,
    kNorthwest = 9, kNorth = 11, kNortheast = 13, kEast = 15
  };

  // Graphics
  static const int kTrackShapeSize;

  // Callbacks
  static const int kCallbackTypeSize = 3;
  static const KG::CallbackTypes kCallbackTypeList[kCallbackTypeSize];
  
  // Params
  static const int kParamSize;
  
  // Shape
  struct ShapeKey {
    int track_idx;
    int shape_idx;
  };

  static const float kShapeLineWidth;
  
  // Direction
  static const int kDirectionSize = 16;
  static const ofVec3f kDirectionList[kDirectionSize];

private:
  
  KG();
  KG(const KG&);
  KG& operator=(const KG&);
  
};


}  // namespace cellophane
