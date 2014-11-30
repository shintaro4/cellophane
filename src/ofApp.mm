#include "ofApp.h"
#include "helper.h"
#include "layer_helper.h"
#include "KC.h"
#include "KD.h"


namespace cellophane {
  

// aliases
using CompositionLayer= cellophane::ns_layer::CompositionLayer;
using UILayer = cellophane::ns_layer::UILayer;
using NavigationLayer = cellophane::ns_layer::NavigationLayer;

  
//--------------------------------------------------------------
// constructor
//--------------------------------------------------------------
ofApp::ofApp() : settings_(new Settings()), focus_(KU::kNavigationFocus) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void ofApp::setup() {
  Environment::getInstance().showEnvironment();
  ofSetFrameRate(KD::kDefaultFPS);
  ofSetCircleResolution(KD::kDefaultCircleResolution);
  ofEnableAlphaBlending();
  
  // initialize singlton classes
  Timekeeper::getInstance().init(Poco::TimerCallback<ofApp>
                                 (*this, &ofApp::onTimer));
  
  // init settings
  settings_->setup();
  const KU::Modes mode = settings_->getMode();
  ofXml xml = settings_->getXml();
  initLayers(mode, xml);
  
  // custom event
  ofAddListener(navigation_layer_->changeModeEvent, this,
                &ofApp::handleChangeModeEvent);
  ofAddListener(ui_layer_->changeColorEvent, this,
                &ofApp::handleChangeColorEvent);
  ofAddListener(navigation_layer_->clearEvent, this,
                &ofApp::handleClearEvent);

  // audio
  maxiSettings::setup(KD::kSampleRate, KD::kChannels, KD::kBufferSize);
  ofSoundStreamSetup(maxiSettings::channels, 0, this, maxiSettings::sampleRate,
                     maxiSettings::bufferSize, 1);
}

//--------------------------------------------------------------
void ofApp::update() {
  const TimeDiff current_time = Timekeeper::getInstance().getElapsed();
  composition_layer_->update(current_time);
  ui_layer_->update(current_time);
  navigation_layer_->update(current_time);
}

//--------------------------------------------------------------
void ofApp::draw() {
  composition_layer_->draw();
  ui_layer_->draw();
  navigation_layer_->draw();
}

//--------------------------------------------------------------
void ofApp::exit() {
  Timekeeper::getInstance().stop();
  
  ofRemoveListener(navigation_layer_->changeModeEvent, this,
                   &ofApp::handleChangeModeEvent);
  ofRemoveListener(ui_layer_->changeColorEvent, this,
                   &ofApp::handleChangeColorEvent);
  ofRemoveListener(navigation_layer_->clearEvent, this,
                   &ofApp::handleClearEvent);

  saveToXml();
  
  ofLog(OF_LOG_NOTICE, "(called ofApp::exit)");
  
  delete settings_;
  delete composition_layer_;
  delete ui_layer_;
  delete navigation_layer_;
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs& touch) {
  if (navigation_layer_->inside(touch)) {
    focus_ = KU::kNavigationFocus;
    navigation_layer_->touchDown(touch);
  } else {
    if (settings_->getMode() == KU::kUIMode && ui_layer_->inside(touch)) {
      focus_ = KU::kUIFocus;
      ui_layer_->touchDown(touch);
    } else {
      focus_ = KU::kCompositionFocus;
      composition_layer_->touchDown(touch);
    }
  }
}
  
//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs& touch) {
  if (focus_ == KU::kUIFocus) {
    ui_layer_->touchMoved(touch);
  } else if (focus_ == KU::kCompositionFocus){
    composition_layer_->touchMoved(touch);
  }
}
  
//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs& touch) {
  if (focus_ == KU::kNavigationFocus) {
    navigation_layer_->touchUp(touch);
  } else {
    if (focus_ == KU::kUIFocus) {
      ui_layer_->touchUp(touch);
    } else if (focus_ == KU::kCompositionFocus){
      composition_layer_->touchUp(touch);
    }
  }
  focus_ = KU::kNavigationFocus;
}
  
//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs& touch) {
  ofLog(OF_LOG_NOTICE, "(called ofApp::touchDoubleTap)");
}
  
//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& touch) {}

//--------------------------------------------------------------
void ofApp::lostFocus() {
  Timekeeper::getInstance().stop();
  saveToXml();
  ofLog(OF_LOG_NOTICE, "(called ofApp::lostFocus)");
}

//--------------------------------------------------------------
void ofApp::gotFocus() {
  Timekeeper::getInstance().start();
  ofLog(OF_LOG_NOTICE, "(called ofApp::gotFocus)");
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning() {}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation) {}

//--------------------------------------------------------------
// event handler
//--------------------------------------------------------------
void ofApp::handleClearEvent() {
  composition_layer_->handleClearEvent();
}
  
void ofApp::handleChangeModeEvent(KU::Modes& mode) {
  if (mode == settings_->getMode()) return;

  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  if (mode == KU::kUIMode) {
    composition_layer_->fade(timestamp, lib_animation::kEaseOutCubic, mode);
    ui_layer_->fade(timestamp, lib_animation::kEaseInCubic, mode);
    navigation_layer_->fade(timestamp, lib_animation::kEaseInCubic, mode);
  } else if (mode == KU::kCompositionMode) {
    composition_layer_->fade(timestamp, lib_animation::kEaseInCubic, mode);
    ui_layer_->fade(timestamp, lib_animation::kEaseOutCubic, mode);
    navigation_layer_->fade(timestamp, lib_animation::kEaseInCubic, mode);
  }
  settings_->setMode(mode);
}

void ofApp::handleChangeColorEvent(int& palette_idx) {
  composition_layer_->handleChangeColorEvent(palette_idx);
}
  
//--------------------------------------------------------------
// xml methods
//--------------------------------------------------------------
void ofApp::saveToXml() {
  // before saving, remove all nodes
  settings_->clear();
  
  composition_layer_->addToSettings(settings_);
  ui_layer_->addToSettings(settings_);
  
  settings_->save();
}
  
//--------------------------------------------------------------
// timer methods
//--------------------------------------------------------------
void ofApp::onTimer(Poco::Timer &timer) {
  Timekeeper::getInstance().refresh();
}

//--------------------------------------------------------------
// audio methods
//--------------------------------------------------------------
void ofApp::audioOut(float* output, int buffer_size, int n_channels) {
  composition_layer_->audioOut(output, buffer_size, n_channels);
}

void ofApp::initLayers(KU::Modes mode, ofXml& xml) {
  // navigation layer
  navigation_layer_ = new NavigationLayer(mode);
  ui_layer_ = new UILayer(mode, xml);
  const int palette_idx = ui_layer_->getPaletteIndex();
  composition_layer_ = new CompositionLayer(mode, palette_idx, xml);
  
  // init background color
  ofBackground(KC::kBackgroundColor);
}

  
}  // namespace cellophane
