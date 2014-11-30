//
//  UIImage.mm
//

#include "UIImage.h"


namespace cellophane {
  
namespace ns_ui {
    
    
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UIImage::UIImage(const ofPoint& anchor, float width, float height,
                 const std::string& image_path) : BaseUI(KU::kNoneOption),
      bound_(ofRectangle(anchor, width, height)), color_(ofColor(255)) {
  image_.loadImage(image_path);
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UIImage::draw() {
  ofPushStyle();
  ofSetColor(color_, color_.a * layer_alpha_);
  image_.draw(bound_.x, bound_.y);
  ofPopStyle();
}
  
bool UIImage::inside(const ofTouchEventArgs& touch) const {
  return bound_.inside(touch.x, touch.y);
}
  
  
}  // namespace ns_ui
  
}  // namespace cellophane
