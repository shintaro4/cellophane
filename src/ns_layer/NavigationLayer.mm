//
//  NavigationLayer.mm
//

#include "NavigationLayer.h"
#include "helper.h"
#include "layer_helper.h"


namespace cellophane {
  
namespace ns_layer {

  
//--------------------------------------------------------------
// events
//--------------------------------------------------------------
ofEvent<KU::Modes> NavigationLayer::changeModeEvent = ofEvent<KU::Modes>();
ofEvent<void> NavigationLayer::clearEvent = ofEvent<void>();
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
NavigationLayer::NavigationLayer(KU::Modes mode) {
  initMenu(mode);
  initClear();
  
  alpha_ = toLayerAlpha(mode);
}

NavigationLayer::~NavigationLayer() {
  delete animation_;
  
  for (std::vector<UIButton*>::iterator iter = buttons_.begin();
       iter != buttons_.end(); ++iter) {
    if ((*iter)->getOption() != KU::kNoneOption) {
      ofRemoveListener((*iter)->uiEvent, this, &NavigationLayer::handleEvent);
    }
    delete (*iter);
  }
  buttons_.clear();
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void NavigationLayer::update(const TimeDiff current_time) {
  for (int i = 0; i < buttons_.size(); ++i) {
    buttons_[i]->update(current_time);
    buttons_[i]->setLayerAlpha(alpha_);
  }
  updateParams(current_time);
}
  
void NavigationLayer::draw() {
  if (alpha_ == 0.0f) return;
  
  ofPushStyle();
  ofPushMatrix();
  ofTranslate(origin_);
  for (int i = 0; i < buttons_.size(); ++i) buttons_[i]->draw();
  ofPopMatrix();
  ofPopStyle();
}
  
void NavigationLayer::touchDown(ofTouchEventArgs& touch) {
  for (int i = 0; i < buttons_.size(); ++i) {
    buttons_[i]->touchDown(touch);
  }
}

void NavigationLayer::touchMoved(ofTouchEventArgs& touch) {}

void NavigationLayer::touchUp(ofTouchEventArgs& touch) {
  for (int i = 0; i < buttons_.size(); ++i) {
    buttons_[i]->touchUp(touch);
  }
}

bool NavigationLayer::inside(const ofTouchEventArgs& touch) const {
  for (int i = 0; i < buttons_.size(); ++i) {
    if (buttons_[i]->inside(touch)) return true;
  }
  return false;
}

float NavigationLayer::toLayerAlpha(KU::Modes mode) const {
  return 1.0f;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void NavigationLayer::handleEvent(KU::UIEventArgs& args) {
  if (args.option == KU::kWindowOption) {
    KU::Modes mode = (args.value == 1) ? KU::kUIMode : KU::kCompositionMode;
    ofNotifyEvent(changeModeEvent, mode);
  } else if (args.option == KU::kClearOption) {
    ofNotifyEvent(clearEvent);
  }
}

void NavigationLayer::initMenu(KU::Modes mode) {
  const int size = ns_layer::getSize(32.0f);
  const int margin = size * 0.5f;
  // note: the anchor point is its left-top position
  const float left = margin;
  const float bottom = ofGetHeight() - margin - size;
  const ofPoint anchor(left, bottom);
  
  const std::string image_path =
      ns_layer::getImagePath("images/icons/hud_button_w3-32");
  UIButton* button(new UIButton(KU::kWindowOption, anchor, size, image_path,
                                true, toBool(mode)));
  ofAddListener(button->uiEvent, this, &NavigationLayer::handleEvent);
  buttons_.push_back(button);
}
  
void NavigationLayer::initClear() {
  const int size = ns_layer::getSize(32.0f);
  const float margin = size * 0.5f;
  // note: the anchor point is its left-top position
  const float right = ofGetWidth() - margin - size;
  const float bottom = ofGetHeight() - margin - size;
  const ofPoint anchor(right, bottom);

  const std::string image_path =
      ns_layer::getImagePath("images/icons/trash_button_w3-32");
  UIButton* button(new UIButton(KU::kClearOption, anchor, size, image_path,
                                false, true));
  ofAddListener(button->uiEvent, this, &NavigationLayer::handleEvent);
  buttons_.push_back(button);
}

  
}  // namespace ns_layer
  
}  // namespace cellophane