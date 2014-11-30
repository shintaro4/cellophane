//
//  CompositionLayer.mm
//

#include "CompositionLayer.h"
#include "direction_helper.h"
#include "graphics_helper.h"
#include "Timekeeper.h"


namespace cellophane {

namespace ns_layer {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
CompositionLayer::CompositionLayer(KU::Modes mode, int palette_idx, ofXml& xml)
    : composition_(new Composition(palette_idx, xml)),
      touch_mode_(KL::kNoneMode), touch_buffer_(new TouchBuffer()) {
  touch_key_.track_idx = -1;
  touch_key_.shape_idx = -1;
  hold_key_ = touch_key_;
        
  alpha_ = toLayerAlpha(mode);
}

CompositionLayer::~CompositionLayer() {
  delete animation_;
  delete composition_;
  delete touch_buffer_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void CompositionLayer::update(const TimeDiff current_time) {
  composition_->update(current_time);
  composition_->setAlpha(alpha_);
  updateParams(current_time);
}

void CompositionLayer::draw() {
  if (alpha_ == 0.0f) return;
  
  ofPushStyle();
  ofPushMatrix();
  ofTranslate(origin_);
  composition_->draw();
  ofPopMatrix();
  ofPopStyle();
}

void CompositionLayer::touchDown(ofTouchEventArgs& touch) {
  TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  touch_buffer_->setBuffer(touch, timestamp);
  
  touch_key_ = composition_->findShapeKey(touch, touch_buffer_->getGridPoint());
  if (touch_key_.track_idx >= 0) {  // touch on shape
    touch_mode_ = KL::kHoldMode;
    hold_key_ = touch_key_;
    composition_->setHoldingShapeIndex(hold_key_);
  } else {
    composition_->handleTouchDown(touch_buffer_->getGridPoint());
  }
}

void CompositionLayer::touchMoved(ofTouchEventArgs& touch) {
  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  if (touch_buffer_->isIgnoreEvent(timestamp) ||
      touch_buffer_->isSameGridPoint(touch)) return;
  
  touchMovedOnUser(touch);
  touchMovedOnShapes(touch);

  touch_buffer_->setBuffer(touch, timestamp);
}

void CompositionLayer::touchUp(ofTouchEventArgs& touch) {
  if (touch_mode_ == KL::kHoldMode) composition_->handleTap(touch_key_);
  composition_->resetHoldingShapeIndex();
  touch_mode_ = KL::kNoneMode;
}
  
void CompositionLayer::handleChangeColorEvent(int palette_idx) {
  composition_->handleChangeColorEvent(palette_idx);
}
  
void CompositionLayer::handleClearEvent() {
  composition_->clear();
}

void CompositionLayer::audioOut(float* output, int buffer_size,
                                int n_channels) {
  composition_->audioOut(output, buffer_size, n_channels);
}

float CompositionLayer::toLayerAlpha(KU::Modes mode) const {
  if (mode == KU::kCompositionMode) {
    return 0.5f;
  } else if (mode == KU::kUIMode) {
    return 0.25f;
  }
  return 0.0f;
}

//--------------------------------------------------------------
// setting xml methods
//--------------------------------------------------------------
void CompositionLayer::addToSettings(Settings* settings) {
  composition_->addToSettings(settings);
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void CompositionLayer::touchMovedOnUser(const ofTouchEventArgs& touch) {
  if (touch_mode_ == KL::kHoldMode) touch_mode_ = KL::kDragMode;

  const ofPoint grid_point = ns_graphics::convertToGridPoint(touch);
  if (touch_mode_ == KL::kDragMode) {
    if (composition_->getShapeState(hold_key_)) {
      composition_->handleDrag(hold_key_, grid_point);
    } else {
      touch_mode_ = KL::kNoneMode;
    }
  } else {
    composition_->handleTouchMoved(grid_point);
  }
}

void CompositionLayer::touchMovedOnShapes(const ofTouchEventArgs& touch) {
  const ofVec3f vec = touch_buffer_->getVector(touch);
  const ofVec3f dir_vec = ns_layer::getDirectionVector(vec);

  const std::vector<KG::ShapeKey> shape_keys =
      composition_->findShapeKeys(touch,
                                  ns_graphics::convertToGridPoint(touch));
  for (int i = 0; i < shape_keys.size(); ++i) {
    if (shape_keys[i].track_idx == touch_key_.track_idx &&
        shape_keys[i].shape_idx == touch_key_.shape_idx) continue;
    
    if (shape_keys[i].track_idx >= 0) { 
      composition_->handleSweep(shape_keys[i], dir_vec);
    }
  }
}
  
  
}  // namespace ns_layer
  
}  // namespace cellophane
