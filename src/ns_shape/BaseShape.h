//
//  BaseShape.h
//

#pragma once

#include "KG.h"
#include "Animation.h"
#include "Grid.h"


namespace cellophane {

namespace ns_shape {


// aliases
using Animation = lib_animation::Animation;
using Transition = lib_animation::Transition;
using Motion = lib_animation::Motion;
using Form = cellophane::ns_graphics::Grid::Form;
  
  
//--------------------------------------------------------------
// types
//--------------------------------------------------------------
  
struct ShapeArgs {
  KG::ShapeTypes type;
  ofPoint center;
  ofColor color;
  float size;
  float width;
  float height;
  float angle;
  bool filling;
};

  
class BaseShape {

public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  virtual ~BaseShape();
  
  virtual void update(const TimeDiff current_time);
  virtual void draw();
  virtual void reset();
  virtual void set(const ShapeArgs& shape_args);
  virtual bool inside(const ofTouchEventArgs& touch) const = 0;
  virtual void adjustTime(const TimeDiff timestamp, int duration);
  
  bool getState() const;
  void setState(bool state);
  KG::ShapeTypes getType() const;
  void setType(KG::ShapeTypes type);
  const ofPoint& getCenter() const;
  void setCenter(const ofPoint& center);
  const ofColor& getColor() const;
  void setColor(const ofColor& color);
  void invertColor();
  float getSize() const;
  bool getFilling() const;
  void setFilling(bool filling);
  float getLayerAlpha() const;
  void setLayerAlpha(float layer_alpha);
  
  float getCurrentValue(KG::Params param) const;
  float getEndValue(KG::Params param) const;
  void setTransition(KG::Params param, lib_animation::Transition trans);

  const Form getForm(int track_idx, int shape_idx) const;

protected:
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------
  
  BaseShape();
  BaseShape(bool state, const ShapeArgs& args, float layer_alpha);

  void updateParams(const std::vector<Motion>& motions);
  void updateParam(KG::Params param, float value);
  
  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------
  
  bool state_;
  KG::ShapeTypes type_;
  ofPoint center_;
  ofColor color_;
  float size_;
  float width_;
  float height_;
  float angle_;
  bool filling_;
  float layer_alpha_;
  
  Animation* animation_;

private:
  
  BaseShape(const BaseShape&);
  BaseShape& operator=(const BaseShape&);
  
};

  
}  // namespace ns_shape

}  // namespace cellophane
