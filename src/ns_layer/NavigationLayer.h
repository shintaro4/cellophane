//
//  NavigationLayer.h
//

#pragma once

#include "UIButton.h"
#include "BaseLayer.h"


namespace cellophane {
  
namespace ns_layer {
    

// aliases
using UIButton = ns_ui::UIButton;
  

class NavigationLayer : public BaseLayer<NavigationLayer> {
      
public:

  //--------------------------------------------------------------
  // events
  //--------------------------------------------------------------
  
  static ofEvent<KU::Modes> changeModeEvent;
  static ofEvent<void> clearEvent;
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  NavigationLayer(KU::Modes mode);
  ~NavigationLayer();
  
  void update(const TimeDiff current_time);
  void draw();
  
  void touchDown(ofTouchEventArgs& touch);
  void touchMoved(ofTouchEventArgs& touch);
  void touchUp(ofTouchEventArgs& touch);

  bool inside(const ofTouchEventArgs& touch) const;

  float toLayerAlpha(KU::Modes mode) const;
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  NavigationLayer(const NavigationLayer&);
  NavigationLayer& operator=(const NavigationLayer&);
  
  void handleEvent(KU::UIEventArgs& args);
  void initMenu(KU::Modes mode);
  void initClear();
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  std::vector<UIButton*> buttons_;
  
};
  
  
}  // namespace ns_layer
  
}  // namespace cellophane
