//
//  UIText.mm
//

#include "UIText.h"


namespace cellophane {
  
namespace ns_ui {
    

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UIText::UIText(const ofPoint& anchor, const std::string& text,
               int font_size)
    : BaseUI(KU::kNoneOption), anchor_(anchor), text_(text) {
//  font_.loadFont("font/HelveticaNeueLight.ttf", font_size);
//  font_.setLineHeight(34.0f);
//  font_.setLetterSpacing(1.035);
//  bound_ = font_.getStringBoundingBox(text_, anchor_.x, anchor_.y);
      
  updateColor();
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UIText::draw() {
  ofPushStyle();
  ofSetColor(color_, color_.a * layer_alpha_);
  font_.drawString(text_, anchor_.x, anchor_.y);
  ofPopStyle();
}

bool UIText::inside(const ofTouchEventArgs& touch) const {
  return false;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void UIText::updateColor() {
  color_ = ofColor(0);
}
  
  
}  // namespace ns_ui
  
}  // namespace cellophane
