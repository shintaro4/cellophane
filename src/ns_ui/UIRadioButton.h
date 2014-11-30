//
//  UIRadioButton.h
//

#pragma once

#include "UIButton.h"


namespace cellophane {
  
namespace ns_ui {
    

class UIRadioButton : public BaseUI {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  UIRadioButton(KU::Options option, float size,
                const std::vector<ofPoint>& anchors,
                const std::vector<std::string>& image_paths, int value);
  ~UIRadioButton();
  
  virtual void draw();
  virtual void touchDown(const ofTouchEventArgs& touch);
  virtual void touchUp(const ofTouchEventArgs& touch);
  virtual void setLayerAlpha(float layer_alpha);
  virtual bool inside(const ofTouchEventArgs& touch) const;
  
  int getValue() const;
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  UIRadioButton(const UIRadioButton&);
  UIRadioButton& operator=(const UIRadioButton&);

  void handleUIEvent(KU::UIEventArgs& args);
  
  void initButtons(float size,
                   const std::vector<ofPoint>& anchors,
                   const std::vector<std::string>& image_paths);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  int value_;
  std::vector<UIButton*> buttons_;
  
};
  

}  // namespace ns_ui
  
}  // namespace cellophane
