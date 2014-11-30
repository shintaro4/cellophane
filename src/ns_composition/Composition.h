//
//  Composition.h
//

#pragma once

#include "KT.h"
#include "Track.h"
#include "Envelope.h"


namespace cellophane {
  
namespace ns_composition {


//aliases
using EG = lib_maximplus::Envelope;
using EGTypes = lib_maximplus::Envelope::Types;

  
//--------------------------------------------------------------
// types
//--------------------------------------------------------------
  
  
class Track;
class CARunner;

  
class Composition {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Composition(int palette_idx, ofXml& xml);
  ~Composition();
  
  void update(const TimeDiff current_time);
  void draw();

  bool getShapeState(const KG::ShapeKey& key) const;
  const KG::ShapeKey findShapeKey(const ofTouchEventArgs& touch,
                                  const ofPoint& grid_point) const;
  const std::vector<KG::ShapeKey>
  findShapeKeys(const ofTouchEventArgs& touch, const ofPoint& grid_point) const;
  void setHoldingShapeIndex(const KG::ShapeKey& key);
  void resetHoldingShapeIndex();

  void adjustTime(const TimeDiff timestamp, int duration);
  void audioOut(float* output, int buffer_size, int n_channels);
  
  void handlePlayer(KT::PlayerEventArgs& args);
  void handleTouchDown(const ofPoint& grid_point);
  void handleTouchMoved(const ofPoint& grid_point);
  void handleTap(const KG::ShapeKey& key);
  void handleSweep(const KG::ShapeKey& key, const ofVec3f& dir_vec);
  void handleDrag(const KG::ShapeKey& key, const ofPoint& grid_point);

  void handleChangeColorEvent(int palette_idx);
  
  void clear();
  void setAlpha(float alpha);
  
  // for setting xml methods
  void addToSettings(Settings* settings);

private:
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const std::string kCompositionXPath;
  static const std::string kTracksXPath;
  static const std::string kGridXPath;
  static const std::string kScalePath;
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Composition(const Composition&);
  Composition& operator=(const Composition&);

  const std::vector<TimeDiff> getReducedTriggerTimes() const;
  void maskPlayerCAs(CARunner* ca_runner);
  void updateScaleIndex(CARunner* ca_runner);

  void initTracks(ofXml& xml);
  void initGrid(ofXml& xml);
  void startCARunners();
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::vector<Track*> tracks_;
  ns_graphics::Grid* grid_;
  int palette_idx_;
  int scale_idx_;
  
};

  
}  // namespace ns_composition
 
}  // namespace cellophane
