//
//  UIButton.mm
//

#include "UIButton.h"
#include "Environment.h"

namespace cellophane {
  
namespace ns_ui {
    
    
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UIButton::UIButton(KU::Options option, const ofPoint& anchor, float size,
                   const std::string& image_path, bool toggle, bool value)
    : BaseUI(option), bound_(ofRectangle(anchor, size, size)),
      value_(value), size_(size), color_(ofColor(255)), offset_(0.0f),
      holding_(false), toggle_(toggle) {
  image_.loadImage(image_path);
  updateOffset(value_);
}

UIButton::UIButton(KU::Options option, int member_id, const ofPoint& anchor,
                   float size, const std::string& image_path, bool toggle,
                   bool value)
    : BaseUI(option, member_id), bound_(ofRectangle(anchor, size, size)),
      value_(value), size_(size), color_(ofColor(255)), offset_(0.0f),
      holding_(false), toggle_(toggle) {
  image_.loadImage(image_path);
  updateOffset(value_);
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UIButton::draw() {
  ofPushStyle();
  ofSetColor(color_, color_.a * layer_alpha_);
  image_.drawSubsection(bound_.x, bound_.y, size_, size_, offset_, 0.0f);
  ofPopStyle();
}
    
void UIButton::touchDown(const ofTouchEventArgs& touch) {
  if (inside(touch)) {
    if (!toggle_) {
      value_ = !value_;
      updateOffset(value_);
    }
    holding_ = true;
  }
}
  
void UIButton::touchUp(const ofTouchEventArgs& touch) {
  if (holding_) {
    value_ = !value_;
    KU::UIEventArgs args = {
      .option = option_, .member_id = member_id_, .value = value_
    };
    ofNotifyEvent(uiEvent, args);

    updateOffset(value_);
    holding_ = false;
  }
}

bool UIButton::inside(const ofTouchEventArgs& touch) const {
  return bound_.inside(touch.x, touch.y);
}
  
bool UIButton::getValue() const {
  return value_;
}

void UIButton::setValue(bool value) {
  if (toggle_) {
    value_ = value;
    updateOffset(value_);
  }
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void UIButton::updateOffset(bool state) {
  int idx = (state) ? 2 : 0;
  offset_ = size_ * idx;
}


}  // namespace ns_ui
  
}  // namespace cellophane
