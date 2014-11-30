//
//  Settings.mm
//

#include "Settings.h"
#include "ofxiOSExtras.h"
#include "helper.h"
#include "KC.h"
#include "Timekeeper.h"


namespace cellophane {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const std::string Settings::kVersion = "1.0";
const std::string Settings::kFilePath = "settings.xml";
const std::string Settings::kRootNodeName = "settings";
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Settings::Settings() : mode_(KU::kCompositionMode),
      bpm_(Timekeeper::kDefaultBPM)  {}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Settings::setup() {
  if (xml_.load(ofxiOSGetDocumentsDirectory() + kFilePath) &&
      xml_.getName() == kRootNodeName &&
      getVersion() == kVersion) {
    loadFromXml(xml_);
  } else {
    // initialize xml
    clear();
  }
}

//--------------------------------------------------------------
// mode methods
//--------------------------------------------------------------
KU::Modes Settings::getMode() const {
  return mode_;
}
  
void Settings::setMode(KU::Modes mode) {
  mode_ = mode;
}

//--------------------------------------------------------------
// bpm methods
//--------------------------------------------------------------
int Settings::getBpm() const {
  return bpm_;
}
  
void Settings::setBpm(int bpm) {
  bpm_ = bpm;
}


//--------------------------------------------------------------
// xml methods
//--------------------------------------------------------------
bool Settings::save() {
  return xml_.save(ofxiOSGetDocumentsDirectory() + kFilePath);
}
  
bool Settings::addToRoot(const std::string& xml_string) {
  xml_.reset();
  return addNodesFromString(xml_string);
}
  
bool Settings::addTo(const std::string& xpath, const std::string& xml_string) {
  resetPath(xpath);
  return addNodesFromString(xml_string);
}

void Settings::clear() {
  xml_.clear();
  xml_.addChild(kRootNodeName);
  addToSettings();
}
  
ofXml& Settings::getXml() {
  xml_.reset();
  return xml_;
}
  
void Settings::resetPath(const std::string& xpath) {
  xml_.reset();
  addChildRecursive(xpath);
}
  
void Settings::removeNodes(const std::string& xpath) {
  xml_.reset();
  if (xml_.exists(xpath)) xml_.remove(xpath);
}

void Settings::printXml() {
  cout << xml_.toString() << endl;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
bool Settings::addNodesFromString(const std::string& xml_string) {
  if (tmp_.loadFromBuffer(xml_string)) {
    xml_.addXml(tmp_);
    return true;
  } else {
    return false;
  }
}

void Settings::addChildRecursive(const std::string& xpath) {
  xml_.reset();
  const std::vector<std::string> tokens = ofXml::tokenize(xpath, "/");
  for (int i = 0; i < tokens.size(); ++i) {
    if (!xml_.exists(tokens[i])) xml_.addChild(tokens[i]);
    xml_.setTo(tokens[i]);
  }
}

//--------------------------------------------------------------
// members save to/load from xml
//--------------------------------------------------------------
const std::string Settings::getVersion() {
  xml_.reset();
  const std::string version_path = "version";
  return (xml_.exists(version_path)) ? xml_.getValue(version_path) : "";
}
  
void Settings::addToSettings() {
  addToRoot("<version>" + kVersion + "</version>");
  addToRoot("<mode>" + ofToString(toInt(mode_)) + "</mode>");
  addToRoot("<bpm>" + ofToString(bpm_) + "</bpm>");
}
  
void Settings::loadFromXml(ofXml& xml) {
  xml.reset();
  const std::string mode_path = "mode";
  if (xml.exists(mode_path)) {
    mode_ = cellophane::toModes(xml.getIntValue(mode_path));
  }
  
  const std::string bpm_path = "bpm";
  if (xml.exists(bpm_path)) {
    bpm_ = xml.getIntValue(bpm_path);
  }
}

  
}  // namespace cellophane