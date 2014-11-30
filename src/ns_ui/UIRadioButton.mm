//
//  UIRadioButton.mm
//

#include "UIRadioButton.h"


namespace cellophane {
  
namespace ns_ui {
    

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UIRadioButton::UIRadioButton(KU::Options option, float size,
                             const std::vector<ofPoint>& anchors,
                             const std::vector<std::string>& image_paths,
                             int value)
    : BaseUI(option), value_(value) {
  initButtons(size, anchors, image_paths);
}
  
UIRadioButton::~UIRadioButton() {
  for (std::vector<UIButton*>::iterator iter = buttons_.begin();
       iter != buttons_.end(); ++iter) {
    if ((*iter)->getOption() != KU::kNoneOption) {
      ofRemoveListener((*iter)->uiEvent, this, &UIRadioButton::handleUIEvent);
    }
    delete (*iter);
  }
  buttons_.clear();
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UIRadioButton::draw() {
  for (int i = 0; i < buttons_.size(); ++i) buttons_[i]->draw();
}

void UIRadioButton::touchDown(const ofTouchEventArgs& touch) {
  for (int i = 0; i < buttons_.size(); ++i) buttons_[i]->touchDown(touch);
}

void UIRadioButton::touchUp(const ofTouchEventArgs& touch) {
  for (int i = 0; i < buttons_.size(); ++i) buttons_[i]->touchUp(touch);
}

void UIRadioButton::setLayerAlpha(float layer_alpha) {
  for (int i = 0; i < buttons_.size(); ++i) {
    buttons_[i]->setLayerAlpha(layer_alpha);
  }
}

bool UIRadioButton::inside(const ofTouchEventArgs& touch) const {
  for (int i = 0; i < buttons_.size(); ++i) {
    if (buttons_[i]->inside(touch)) return true;
  }
  return false;
}
  
int UIRadioButton::getValue() const {
  return value_;
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void UIRadioButton::handleUIEvent(KU::UIEventArgs& args) {
  value_ = args.member_id;
  KU::UIEventArgs radio_args = {
    .option = option_, .member_id = member_id_, .value = value_
  };
  ofNotifyEvent(uiEvent, radio_args);
  
  // update all button values
  for (int i = 0; i < buttons_.size(); ++i) {
    bool button_value = (i == value_);
    buttons_[i]->setValue(button_value);
  }
}
  
void UIRadioButton::initButtons(float size,
                                const std::vector<ofPoint>& anchors,
                                const std::vector<std::string>& image_paths) {
  // use a vector as a static array
  buttons_.resize(anchors.size());
  
  for (int i = 0; i < anchors.size(); ++i) {
    bool button_value = (i == value_);
    buttons_[i] = new UIButton(option_, i, anchors[i], size, image_paths[i],
                               true, button_value);
    ofAddListener(buttons_[i]->uiEvent, this, &UIRadioButton::handleUIEvent);
  }
}
  
  
}  // namespace ns_ui
  
}  // namespace cellophane
