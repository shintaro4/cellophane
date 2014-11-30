#pragma once

#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "Environment.h"
#include "Timekeeper.h"
#include "Settings.h"

#include "CompositionLayer.h"
#include "UILayer.h"
#include "NavigationLayer.h"


namespace cellophane {

  
class ofApp : public ofxiOSApp {
	
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  ofApp();

  void setup();
  void update();
  void draw();
  void exit();
	
  void touchDown(ofTouchEventArgs& touch);
  void touchMoved(ofTouchEventArgs& touch);
  void touchUp(ofTouchEventArgs& touch);
  void touchDoubleTap(ofTouchEventArgs& touch);
  void touchCancelled(ofTouchEventArgs& touch);
  
  void lostFocus();
  void gotFocus();
  void gotMemoryWarning();
  void deviceOrientationChanged(int newOrientation);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  void handleChangeModeEvent(KU::Modes& mode);
  void handleChangeColorEvent(int& palette_idx);
  void handleClearEvent();
  
  void saveToXml();
  void onTimer(Poco::Timer& timer);
  void audioOut(float* output, int buffer_size, int n_channels);

  void initLayers(KU::Modes mode, ofXml& xml);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  Settings* settings_;
  
  ns_layer::CompositionLayer* composition_layer_;
  ns_layer::UILayer* ui_layer_;
  ns_layer::NavigationLayer* navigation_layer_;
  
  KU::FocusTypes focus_;
  
};
  
  
}  // namespace cellophane
