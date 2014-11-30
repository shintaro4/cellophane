//
//  BaseLayer.h
//

#pragma once

#include "KG.h"
#include "shape_animation_helper.h"


namespace cellophane {
  
namespace ns_layer {
  
  
template <class Derived>
class BaseLayer {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  virtual ~BaseLayer() {};

  void update(const TimeDiff current_time) {
    static_cast<Derived*>(this)->update(current_time);
  };
  void draw() {
    static_cast<Derived*>(this)->draw();
  };

  void touchDown(ofTouchEventArgs& touch) {
    static_cast<Derived*>(this)->touchDown(touch);
  };
  void touchMoved(ofTouchEventArgs& touch) {
    static_cast<Derived*>(this)->touchMoved(touch);
  };
  void touchUp(ofTouchEventArgs& touch) {
    static_cast<Derived*>(this)->touchUp(touch);
  };
  
  void fade(const TimeDiff timestamp, lib_animation::Types env, float end);
  void fade(const TimeDiff timestamp, lib_animation::Types env, KU::Modes mode);
  void setOrigin(const ofPoint& origin);
  
protected:
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  const int kFadeDuration = 200000;
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------

  BaseLayer() : alpha_(0.0f), origin_(ofPoint()),
        animation_(new lib_animation::Animation(KG::kParamSize)) {};
  explicit BaseLayer(float alpha) : alpha_(alpha), origin_(ofPoint()),
        animation_(new lib_animation::Animation(KG::kParamSize)) {};
  
  void updateParams(const TimeDiff current_time);
  void updateParam(KG::Params param, float value);

  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------

  float alpha_;
  ofPoint origin_;
  lib_animation::Animation* animation_;
  
private:
  
  BaseLayer(const BaseLayer&);
  BaseLayer& operator=(const BaseLayer&);
  
};


//--------------------------------------------------------------
// public methods implementation
//--------------------------------------------------------------
template <class Derived>
void BaseLayer<Derived>::fade(const TimeDiff timestamp,
                              lib_animation::Types type, float end) {
  lib_animation::Transition trans =
      lib_animation::createTransition(timestamp, kFadeDuration,
                                      type, alpha_, end);
  animation_->setTransition(KG::kAlphaParam, trans);
}

template <class Derived>
void BaseLayer<Derived>::fade(const TimeDiff timestamp,
                              lib_animation::Types type, KU::Modes mode) {
  const float end = static_cast<Derived*>(this)->toLayerAlpha(mode);
  lib_animation::Transition trans =
      lib_animation::createTransition(timestamp, kFadeDuration,
                                      type, alpha_, end);
  animation_->setTransition(KG::kAlphaParam, trans);
}
  
template <class Derived>
void BaseLayer<Derived>::setOrigin(const ofPoint& origin) {
  origin_ = origin;
}
  

//--------------------------------------------------------------
// protected methods implementation
//--------------------------------------------------------------
template <class Derived>
void BaseLayer<Derived>::updateParams(const TimeDiff current_time) {
  const std::vector<lib_animation::Motion> motions =
      animation_->update(current_time);
  for (int i = 0; i < motions.size(); ++i) {
    if (motions[i].changed) updateParam(static_cast<KG::Params>(i),
                                        motions[i].value);
  }
}

template <class Derived>
void BaseLayer<Derived>::updateParam(KG::Params param, float value) {
  if (param == KG::kXParam) {
    origin_.x = value;
  } else if (param == KG::kYParam) {
    origin_.y = value;
  } else if (param == KG::kAlphaParam) {
    alpha_ = value;
  }
}
  

}  // namespace ns_layer
  
}  // namespace cellophane
