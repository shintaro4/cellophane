//
//  shape_helper.h
//

#pragma once

#include "BaseShape.h"
#include "BaseCellularAutomata.h"
#include "KM.h"


namespace cellophane {
  
namespace ns_shape {


// aliases
using BaseCA = cellophane::ns_composition::BaseCellularAutomata;
using EGTypes = lib_maximplus::Envelope::Types;
  
  
ShapeArgs createArgs(const ofPoint& center, const ofColor color, bool filling);

const ShapeArgs createUserArgs(const ofPoint& center, const ofColor color,
                               bool filling, int duration, BaseCA* ca,
                               bool touch_moved);
const ShapeArgs createUserTouchDownArgs(const ofPoint& center,
                                        const ofColor color, bool filling,
                                        int duration, BaseCA* ca);
const ShapeArgs createUserTouchMovedArgs(const ofPoint& center,
                                         const ofColor color, bool filling,
                                         int duration, BaseCA* ca);
const ShapeArgs createPlayerArgs(const ofPoint& center, const ofColor color,
                                 bool filling, int duration, BaseCA* ca);
int convertToShapeSize(int duration, bool touch_moved);

float getRotatedAngle(KG::ShapeTypes type, float current_angle,
                      int rotation);
float getRotatedAngle(KG::ShapeTypes type, float current_angle);
  
float getAdjustedWidth(KG::ShapeTypes type, float angle,
                       float size);
float getAdjustedHeight(KG::ShapeTypes type, float angle,
                        float size);
int getNumberOfVertices(KG::ShapeTypes type);
const ofVec3f getVertexVector(KG::ShapeTypes type, float angle,
                              float size, int vertex_number);

void draw(KG::ShapeTypes type, float width, float height);
  
float getAngleStep(KG::ShapeTypes type);

  
}  // namespace ns_shape

}  // namespace cellophane
