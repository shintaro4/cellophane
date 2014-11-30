//
//  Graphics.mm
//

#include "Graphics.h"
#include "Timekeeper.h"
#include "helper.h"
#include "shape_animation_helper.h"
#include "shape_helper.h"


namespace cellophane {
  
namespace ns_graphics {
    

//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int Graphics::kUndeployDuration =  500000;
const int Graphics::kClearDuration    =  100000;
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Graphics::Graphics(int track_idx) : BaseGraphics<ns_shape::Shape>(track_idx),
      shape_index_manager_(new ShapeIndexManager()) {
  // initialize the callback type list
  callback_types_ = toVector(KG::kCallbackTypeSize, KG::kCallbackTypeList);
  initShapes();
}

Graphics::Graphics(int track_idx, const std::vector<ns_shape::Shape*>& shapes,
                   ShapeIndexManager* shape_index_manager)
    : BaseGraphics<ns_shape::Shape>(track_idx, shapes),
      shape_index_manager_(shape_index_manager) {
  // initialize the callback type list
  callback_types_ = toVector(KG::kCallbackTypeSize, KG::kCallbackTypeList);
}

Graphics::~Graphics() {
  for (std::vector<ns_shape::Shape*>::iterator iter = shapes_.begin();
       iter != shapes_.end(); ++iter) {
    delete (*iter);
  }
  shapes_.clear();
  
  delete shape_index_manager_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Graphics::update(const TimeDiff current_time, Grid* grid) {
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->getState()) {
      shapes_[i]->update(current_time);
      handleCallback(i, current_time, grid);
    }
  }
}
  
void Graphics::clear() {
  const TimeDiff current_time = Timekeeper::getInstance().getElapsed();
  for (int i = 0; i < shapes_.size(); ++i) {
    shapes_[i]->setCallbackState(KG::kDeployCallback, false);
    
    ns_shape::animateLinearly(shapes_[i], KG::kAlphaParam, current_time,
                              kClearDuration, 0.0f);
    
    shapes_[i]->setCallback(KG::kUndeployCallback,
                            current_time + kClearDuration);
  }
  shape_index_manager_->reset();
}

void Graphics::setupShape(const TimeDiff timestamp, int duration,
                          const ShapeArgs& args, Grid* grid) {
  int undeploy_idx = shape_index_manager_->shrink(timestamp);
  if (undeploy_idx >= 0) undeployShape(undeploy_idx, timestamp, grid);

  int deploy_idx = shape_index_manager_->allocate(timestamp);
  shapes_[deploy_idx]->set(args);
  deployShape(deploy_idx, timestamp, duration, args);
  shapes_[deploy_idx]->setState(true);
}

bool Graphics::getShapeState(int idx) const {
  if (idx < 0 || idx >= shapes_.size()) return false;
  return shapes_[idx]->getState();
}

ShapeIndexManager* Graphics::getShapeIndexManager() {
  return shape_index_manager_;
}
 
void Graphics::setHoldingShapeIndex(int shape_idx) {
  shape_index_manager_->setIgnoreIndex(shape_idx);
}
  
void Graphics::resetHoldingShapeIndex() {
  shape_index_manager_->resetIgnoreIndex();
}

//--------------------------------------------------------------
// animation methods
//--------------------------------------------------------------
void Graphics::rotateShapes(int duration, bool filling, Grid* grid) {
  for (int i = 0; i < shapes_.size(); ++i) {
    if (shapes_[i]->getState()) {
      rotateShape(i, duration, filling, grid);
    }
  }
}
  
void Graphics::rotateShape(int idx, int duration, bool filling, Grid* grid) {
  if (shapes_[idx]->getCallbackState(KG::kDeployCallback) ||
      shapes_[idx]->getCallbackState(KG::kUndeployCallback)) return;
  
  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  KG::ShapeTypes type = shapes_[idx]->getType();
  float size = shapes_[idx]->getSize();
  float angle = shapes_[idx]->getEndValue(KG::kAngleParam);
  int rotation = (ofRandom(1) < 1.0f) ? 1 : -1;
  float rotated = ns_shape::getRotatedAngle(type, angle, rotation);
  
  ns_shape::Shape* shape = shapes_[idx];
  
  shape->setFilling(filling);
  ns_shape::animateLinearly(shape, KG::kAngleParam, timestamp, duration,
                            rotated);
  
  ns_shape::animateLinearly(shape, KG::kWidthParam, timestamp, duration,
                            ns_shape::getAdjustedWidth(type, rotated, size));
  ns_shape::animateLinearly(shape, KG::kHeightParam, timestamp, duration,
                            ns_shape::getAdjustedHeight(type, rotated, size));

  if (!shape->getCallbackState(KG::kMovedCallback)) {
    grid->removeForm(track_idx_, idx);
  }
  shape->setCallback(KG::kMovedCallback, timestamp + duration);
}

void Graphics::moveShape(int idx, int duration, const ofPoint& grid_point,
                         Grid* grid) {
  if (shapes_[idx]->getCallbackState(KG::kDeployCallback) ||
      shapes_[idx]->getCallbackState(KG::kUndeployCallback)) return;
  
  TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  ns_shape::Shape* shape = shapes_[idx];
  
  ns_shape::animateLinearly(shape, KG::kXParam, timestamp, duration,
                            shape->getCurrentValue(KG::kXParam), grid_point.x);
  ns_shape::animateLinearly(shape, KG::kYParam, timestamp, duration,
                            shape->getCurrentValue(KG::kYParam), grid_point.y);
  
  if (!shape->getCallbackState(KG::kMovedCallback)) {
    grid->removeForm(track_idx_, idx);
  }
  shape->setCallback(KG::kMovedCallback, timestamp + duration);
}
  
void Graphics::handleChangeColorEvent(const ofColor& color) {
  for (int i = 0; i < shapes_.size(); ++i) shapes_[i]->setColor(color);
}

void Graphics::clearShape(int idx, const TimeDiff timestamp, int duration,
                          Grid* grid) {
  undeployShape(idx, timestamp, duration, grid);
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void Graphics::deployShape(int idx, const TimeDiff timestamp, int duration,
                           const ShapeArgs& args) {
  ns_shape::animateLinearly(shapes_[idx], KG::kWidthParam, timestamp, duration,
                            0.0f, args.width);
  ns_shape::animateLinearly(shapes_[idx], KG::kHeightParam, timestamp, duration,
                            0.0f, args.height);
  shapes_[idx]->setCallback(KG::kDeployCallback, timestamp + duration);
}

void Graphics::undeployShape(int idx, const TimeDiff timestamp, Grid* grid) {
  undeployShape(idx, timestamp, kUndeployDuration, grid);
}

void Graphics::undeployShape(int idx, const TimeDiff timestamp, int duration,
                             Grid* grid) {
  if (!shape_index_manager_->release(idx)) return;

  if (!shapes_[idx]->isCallbackScheduling()) {
    grid->removeForm(track_idx_, idx);
  }
  shapes_[idx]->setCallbackState(KG::kDeployCallback, false);
  shapes_[idx]->setCallbackState(KG::kMovedCallback, false);
  
  float alpha = shapes_[idx]->getCurrentValue(KG::kAlphaParam);
  ns_shape::animateLinearly(shapes_[idx], KG::kAlphaParam,
                            timestamp, duration, alpha, 0.0f);
  shapes_[idx]->setCallback(KG::kUndeployCallback,  timestamp + duration);
}

void Graphics::removeShape(int idx, Grid* grid) {
  if (!shape_index_manager_->release(idx)) return;
  
  grid->removeForm(track_idx_, idx);
  shapes_[idx]->reset();
}

void Graphics::resetShape(int idx) {
  if (!shape_index_manager_->release(idx)) return;
  
  shapes_[idx]->reset();
}

//--------------------------------------------------------------
// callback methods
//--------------------------------------------------------------
void Graphics::handleCallback(int idx, const TimeDiff current_time,
                              Grid* grid) {
  for (int i = 0; i < callback_types_.size(); ++i) {
    KG::CallbackTypes type = callback_types_[i];
    if (shapes_[idx]->triggerCallback(type, current_time)) {
      if (type == KG::kDeployCallback) {
        handleDeployCallback(idx, grid);
      } else if (type == KG::kUndeployCallback) {
        handleUndeployCallback(idx);
      } else if (type == KG::kMovedCallback) {
        handleMovedCallback(idx, grid);
      }
    }
  }
}

void Graphics::handleDeployCallback(int idx, Grid* grid) {
  grid->addForm(shapes_[idx]->getForm(track_idx_, idx));
  shapes_[idx]->setCallbackState(KG::kDeployCallback, false);
}

void Graphics::handleUndeployCallback(int idx) {
  shapes_[idx]->reset();
}

void Graphics::handleMovedCallback(int idx, Grid* grid) {
  if (shapes_[idx]->getCallbackState(KG::kDeployCallback) ||
      shapes_[idx]->getCallbackState(KG::kUndeployCallback)) return;
    
  if (grid->isAcceptablePoint(shapes_[idx]->getCenter())) {
    grid->addForm(shapes_[idx]->getForm(track_idx_, idx));
    shape_index_manager_->updateTimestamp(idx);
    shapes_[idx]->resetVertices();
    shapes_[idx]->setCallbackState(KG::kMovedCallback, false);
  } else {
    resetShape(idx);
  }
}
  
//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Graphics::initShapes() {
  // use a vector as a static array
  shapes_.resize(KG::kTrackShapeSize);
  for (int i = 0; i < shapes_.size(); ++i) {
    shapes_[i] = new ns_shape::Shape();
  }
}

  
}  // namespace ns_graphics
  
}  // namespace cellophane
