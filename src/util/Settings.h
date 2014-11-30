//
//  Settings.h
//

#pragma once

#include "KG.h"
#include "KS.h"
#include "KU.h"


namespace cellophane {


class Settings {

public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  Settings();

  void setup();
  
  // mode
  KU::Modes getMode() const;
  void setMode(KU::Modes mode);
  
  // bpm
  int getBpm() const;
  void setBpm(int bpm);

  // xml
  bool save();
  bool addToRoot(const std::string& xml_string);
  bool addTo(const std::string& xpath, const std::string& xml_string);
  
  void clear();
  ofXml& getXml();
  void resetPath(const std::string& xpath);
  void removeNodes(const std::string& xpath);

  void printXml();
  
private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const std::string kVersion;
  static const std::string kFilePath;
  static const std::string kRootNodeName;
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Settings(const Settings&);
  Settings& operator=(const Settings&);

  bool addNodesFromString(const std::string& xml_string);
  void addChildRecursive(const std::string& xpath);

  const std::string getVersion();
  void addToSettings();
  void loadFromXml(ofXml& xml);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  KU::Modes mode_;
  int bpm_;

  ofXml xml_;
  ofXml tmp_;

};
  
  
}  // namespace cellophane