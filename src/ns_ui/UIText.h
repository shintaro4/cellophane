//
//  UIText.h
//

#pragma once

#include "BaseUI.h"


namespace cellophane {
  
namespace ns_ui {

  
class UIText : public BaseUI {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  UIText(const ofPoint& anchor, const std::string& text, int font_size);
  
  virtual void draw();
  virtual bool inside(const ofTouchEventArgs& touch) const;
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  UIText(const UIText&);
  UIText& operator=(const UIText&);
  
  void updateColor();
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  ofRectangle bound_;
  ofTrueTypeFont font_;
  ofPoint anchor_;
  std::string text_;
  ofColor color_;
  
};


}  // namespace ns_ui
  
}  // namespace cellophane
