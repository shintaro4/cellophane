//
//  BaseGraphics.h
//

#pragma once

#include "Shape.h"


namespace cellophane {
  
namespace ns_graphics {
  
  
template <class T>
class BaseGraphics {
  
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  virtual ~BaseGraphics() {};

  virtual void draw();
  virtual void adjustTime(const TimeDiff timestamp, int duration);

  int findShapeIndex(const ofTouchEventArgs& touch,
                     const ofPoint& grid_point) const;
  
  const T* getShape(int idx) const;
  const std::vector<T*> getShapes() const;
  
  void setLayerAlpha(float alpha);
  
protected:
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------
  
  explicit BaseGraphics(int track_idx) : track_idx_(track_idx) {};
  BaseGraphics(int track_idx, const std::vector<T*>& shapes)
      : track_idx_(track_idx), shapes_(shapes) {};
  
  bool isUndeploying(int idx) const;

  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------
  
  const int track_idx_;
  std::vector<T*> shapes_;
  
private:
  
  BaseGraphics(const BaseGraphics&);
  BaseGraphics& operator=(const BaseGraphics&);
  
};


//--------------------------------------------------------------
// public method implementation
//--------------------------------------------------------------
template <class T>
void BaseGraphics<T>::draw() {
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->getState()) shapes_[i]->draw();
  }
}

template <class T>
void BaseGraphics<T>::adjustTime(const TimeDiff timestamp, int duration) {
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->getState()) {
      shapes_[i]->adjustTime(timestamp, duration);
    }
  }
}

template <class T>
int BaseGraphics<T>::findShapeIndex(const ofTouchEventArgs& touch,
                                    const ofPoint& grid_point) const {
  // at first, find shape index by touch
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->inside(touch) &&
        !shapes_[i]->getCallbackState(KG::kDeployCallback) &&
        !shapes_[i]->getCallbackState(KG::kUndeployCallback)) return i;
  }
  // if the touch is not inside any shapes, then find shape index by grid_point
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->isCenter(grid_point) &&
        !shapes_[i]->getCallbackState(KG::kDeployCallback) &&
        !shapes_[i]->getCallbackState(KG::kUndeployCallback)) return i;
  }
  
  return -1;
}

template <class T>
const T* BaseGraphics<T>::getShape(int idx) const {
  if (idx >= 0 && idx < shapes_.size()) {
    return shapes_[idx];
  } else {
    return NULL;
  }
}

template <class T>
const std::vector<T*> BaseGraphics<T>::getShapes() const {
  return shapes_;
}
  
//--------------------------------------------------------------
// getter/setter implementation
//--------------------------------------------------------------
template <class T>
void BaseGraphics<T>::setLayerAlpha(float alpha) {
  for (int i = 0; i < shapes_.size(); ++i) shapes_[i]->setLayerAlpha(alpha);
}

//--------------------------------------------------------------
// protected method implementations
//--------------------------------------------------------------
template <class T>
bool BaseGraphics<T>::isUndeploying(int idx) const {
  bool result = false;
  if (idx >= 0 && idx < shapes_.size()) {
    result = shapes_[idx]->getCallbackState(KG::kUndeployCallback);
  }
  return result;
}


}  // namespace ns_graphics
  
}  // namespace cellophane
