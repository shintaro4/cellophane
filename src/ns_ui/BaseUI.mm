//
//  BaseUI.mm
//

#include "BaseUI.h"


namespace cellophane {
  
namespace ns_ui {

   
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
BaseUI::BaseUI(KU::Options option) : option_(option), member_id_(0),
      layer_alpha_(1.0f) {}

BaseUI::BaseUI(KU::Options option, int member_id) : option_(option),
      member_id_(member_id), layer_alpha_(1.0f) {}

BaseUI::~BaseUI() {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
KU::Options BaseUI::getOption() const {
  return option_;
}

void BaseUI::setLayerAlpha(float layer_alpha) {
  layer_alpha_ = layer_alpha;
}
  
  
}  // namespace ns_ui
  
}  // namespace cellophane
