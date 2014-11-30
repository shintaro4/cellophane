//
//  UIButton.h
//

#pragma once

#include "BaseUI.h"


namespace cellophane {
  
namespace ns_ui {
    
    
class UIButton : public BaseUI {
      
public:
      
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  UIButton(KU::Options option, const ofPoint& anchor, float size,
           const std::string& image_path, bool toggle, bool value);

  UIButton(KU::Options option, int member_id, const ofPoint& anchor, float size,
           const std::string& image_path, bool toggle, bool value);
  
  virtual void draw();
  virtual void touchDown(const ofTouchEventArgs& touch);
  virtual void touchUp(const ofTouchEventArgs& touch);
  virtual bool inside(const ofTouchEventArgs& touch) const;
  
  bool getValue() const;
  void setValue(bool value);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  UIButton(const UIButton&);
  UIButton& operator=(const UIButton&);
  
  void updateOffset(bool state);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  ofRectangle bound_;
  bool value_;
  float size_;
  ofImage image_;
  ofColor color_;
  float offset_;
  bool holding_;
  bool toggle_;
  
};
  
  
}  // namespace ns_ui
  
}  // namespace cellophane