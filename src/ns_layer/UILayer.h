//
//  UILayer.h
//

#pragma once

#include "UIButton.h"
#include "UIRadioButton.h"
#include "BaseLayer.h"
#include "Settings.h"


namespace cellophane {
  
namespace ns_layer {
    

// aliases
using BaseUI = ns_ui::BaseUI;
  
  
class UILayer : public BaseLayer<UILayer> {
  
public:

  //--------------------------------------------------------------
  // events
  //--------------------------------------------------------------

  static ofEvent<int> changeStepsComboEvent;
  static ofEvent<int> changeColorEvent;
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  UILayer(KU::Modes mode, ofXml& xml);
  ~UILayer();
  
  void update(const TimeDiff current_time);
  void draw();
  
  void touchDown(ofTouchEventArgs& touch);
  void touchMoved(ofTouchEventArgs& touch);
  void touchUp(ofTouchEventArgs& touch);
  
  bool inside(const ofTouchEventArgs& touch) const;
  
  int getPaletteIndex() const;
  
  float toLayerAlpha(KU::Modes mode) const;
  
  // for setting xml methods
  void addToSettings(Settings* settings);
  void loadFromXml(ofXml& xml);

private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const std::string kXPath;

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  UILayer(const UILayer&);
  UILayer& operator=(const UILayer&);

  void handleUIEvent(KU::UIEventArgs& args);

  const std::string paletteIndexToXmlString() const;

  void appendUIRadioButton(KU::Options option, float size,
                           const std::vector<ofPoint>& anchors,
                           const std::vector<std::string>& image_paths,
                           int value);

  void initPaletteUI(int palette_idx);

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  int palette_idx_;
  std::vector<BaseUI*> ui_;
  
};


}  // namespace ns_layer
  
}  // namespace cellophane
