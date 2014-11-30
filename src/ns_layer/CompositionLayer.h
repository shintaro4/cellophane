//
//  CompositionLayer.h
//

#pragma once

#include "BaseLayer.h"
#include "Composition.h"
#include "TouchBuffer.h"
#include "KL.h"
#include "KU.h"


namespace cellophane {
  
namespace ns_layer {


// aliases
using Composition = ns_composition::Composition;
using ShapeKey = KG::ShapeKey;


class CompositionLayer : public BaseLayer<CompositionLayer> {

public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  CompositionLayer(KU::Modes mode, int palette_idx, ofXml& xml);
  ~CompositionLayer();
  
  void update(const TimeDiff current_time);
  void draw();
  
  void touchDown(ofTouchEventArgs& touch);
  void touchMoved(ofTouchEventArgs& touch);
  void touchUp(ofTouchEventArgs& touch);
  
  void handleChangeColorEvent(int palette_idx);
  
  void handleClearEvent();

  void audioOut(float* output, int buffer_size, int n_channels);

  float toLayerAlpha(KU::Modes mode) const;
  
  // for setting xml methods
  void addToSettings(Settings* settings);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  CompositionLayer(const CompositionLayer&);
  CompositionLayer& operator=(const CompositionLayer&);
  
  void touchMovedOnUser(const ofTouchEventArgs& touch);
  void touchMovedOnShapes(const ofTouchEventArgs& touch);

  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  Composition* composition_;
  KL::TouchModes touch_mode_;
  ShapeKey touch_key_;
  ShapeKey hold_key_;
  TouchBuffer* touch_buffer_;

};


}  // namespace ns_layer
  
}  // namespace cellophane
