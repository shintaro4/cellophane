//
//  UIImage.h
//

#pragma once

#include "BaseUI.h"


namespace cellophane {
  
namespace ns_ui {
    
  
class UIImage : public BaseUI {
      
public:
      
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  UIImage(const ofPoint& anchor, float width, float height,
          const std::string& image_path);
  
  virtual void draw();
  virtual bool inside(const ofTouchEventArgs& touch) const;
  
private:
  
  UIImage(const UIImage&);
  UIImage& operator=(const UIImage&);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  ofRectangle bound_;
  ofImage image_;
  ofColor color_;
  
};
  
  
}  // namespace ns_ui
  
}  // namespace cellophane
