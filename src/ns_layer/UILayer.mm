//
//  UILayer.mm
//

#include "UILayer.h"
#include "helper.h"
#include "layer_helper.h"
#include "UIText.h"
#include "KC.h"
#include "KD.h"


namespace cellophane {
  
namespace ns_layer {

  
// aliases
using UIButton = ns_ui::UIButton;
using UIRadioButton = ns_ui::UIRadioButton;
using UIText = ns_ui::UIText;
using Env = cellophane::Environment;


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const std::string UILayer::kXPath = "ui";

//--------------------------------------------------------------
// events
//--------------------------------------------------------------
ofEvent<int> UILayer::changeStepsComboEvent = ofEvent<int>();
ofEvent<int> UILayer::changeColorEvent = ofEvent<int>();
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
UILayer::UILayer(KU::Modes mode, ofXml& xml)
    : palette_idx_(KD::kDefaultPaletteIndex) {
  loadFromXml(xml);

  initPaletteUI(palette_idx_);
  
  alpha_ = toLayerAlpha(mode);
}

UILayer::~UILayer() {
  delete animation_;
  
  for (std::vector<BaseUI*>::iterator iter = ui_.begin();
       iter != ui_.end(); ++iter) {
    if ((*iter)->getOption() != KU::kNoneOption) {
      ofRemoveListener((*iter)->uiEvent, this, &UILayer::handleUIEvent);
    }

    delete (*iter);
  }
  ui_.clear();
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void UILayer::update(const TimeDiff current_time) {
  for (int i = 0; i < ui_.size(); ++i) {
    ui_[i]->update(current_time);
    ui_[i]->setLayerAlpha(alpha_);
  }
  updateParams(current_time);
}

void UILayer::draw() {
  if (alpha_ == 0.0f) return;
  
  ofPushStyle();
  ofPushMatrix();
  ofTranslate(origin_);
  for (int i = 0; i < ui_.size(); ++i) ui_[i]->draw();
  ofPopMatrix();
  ofPopStyle();
}

void UILayer::touchDown(ofTouchEventArgs& touch) {
  for (int i = 0; i < ui_.size(); ++i) {
    ui_[i]->touchDown(touch);
  }
}

void UILayer::touchMoved(ofTouchEventArgs& touch) {}

void UILayer::touchUp(ofTouchEventArgs& touch) {
  for (int i = 0; i < ui_.size(); ++i) {
    ui_[i]->touchUp(touch);
  }
}
  
bool UILayer::inside(const ofTouchEventArgs& touch) const {
  for (int i = 0; i < ui_.size(); ++i) {
    if (ui_[i]->inside(touch)) return true;
  }
  return false;
}

//--------------------------------------------------------------
// getters
//--------------------------------------------------------------
int UILayer::getPaletteIndex() const {
  return palette_idx_;
}

float UILayer::toLayerAlpha(KU::Modes mode) const {
  return (mode == KU::kUIMode) ? 0.875 : 0.0f;
}

//--------------------------------------------------------------
// setting xml methods
//--------------------------------------------------------------
void UILayer::addToSettings(Settings* settings) {
  settings->addTo(kXPath, paletteIndexToXmlString());
}

void UILayer::loadFromXml(ofXml& xml) {
  xml.reset();
  std::string palette_idx_path = kXPath + "/palette_idx";
  if (xml.exists(palette_idx_path)) {
    palette_idx_ = xml.getIntValue(palette_idx_path);
  }
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void UILayer::handleUIEvent(KU::UIEventArgs& args) {
  if (args.option == KU::kColorOption) {
    palette_idx_ = args.value;
    ofNotifyEvent(changeColorEvent, palette_idx_);
  }
}
  
const std::string UILayer::paletteIndexToXmlString() const {
  return "<palette_idx>" + ofToString(palette_idx_) + "</palette_idx>";
}
  
void UILayer::appendUIRadioButton(KU::Options option, float size,
                                  const std::vector<ofPoint>& anchors,
                                  const std::vector<std::string>& image_paths,
                                  int value) {
  BaseUI* radio_button(new UIRadioButton(option, size, anchors, image_paths,
                                         value));
  
  ofAddListener(radio_button->uiEvent, this, &UILayer::handleUIEvent);
  ui_.push_back(radio_button);
}

//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void UILayer::initPaletteUI(int palette_idx) {
  const int size = ns_layer::getSize(48.0f);
  std::vector<ofPoint> anchors;
  std::vector<std::string> image_paths;
  
  // note: the anchor point is its left-top position
  const float margin = size * 0.375f;
  const float left = (ofGetWidth() -
                      KC::kPaletteSize * size -
                      (KC::kPaletteSize - 1) * margin
                      ) / 2;

  const float y = ofGetHeight() / 2.0f - size;
  for (int i = 0; i < KC::kPaletteSize; ++i) {
    const ofPoint anchor(left + (size + margin) * i, y);
    anchors.push_back(anchor);
    
    const std::string image_path =
        ns_layer::getImagePath("images/icons/color_button_" +
                               ofToString(i + 1) + "_w3-48");
    image_paths.push_back(image_path);
  }
  appendUIRadioButton(KU::kColorOption, size, anchors, image_paths,
                      palette_idx);
}

  
}  // namespace ns_layer
  
}  // namespace cellophane
