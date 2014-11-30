//
//  Track.h
//

#pragma once

#include "Sound.h"
#include "Graphics.h"
#include "CARunner.h"
#include "KT.h"


namespace cellophane {
  
namespace ns_composition {
    

// aliases
using Sound = ns_sound::Sound;
using Graphics = ns_graphics::Graphics;
using Grid = ns_graphics::Grid;

  
class CARunner;
class Coordinator;

  
class Track {

public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Track(int track_idx, int palette_idx, int scale_idx,
        const std::string& xpath, ofXml& xml, Grid* grid);
  ~Track();
  
  void update(const TimeDiff current_time, Grid* grid);
  void draw();
  void clear();
  void adjustTime(const TimeDiff timestamp, int duration);
  const std::pair<float, float> play(const TimeDiff current_time);

  // event
  void handlePlayer(KT::PlayerEventArgs& args, int palette_idx, Grid* grid);
  void handleTouchDown(const ofPoint& grid_point, int palette_idx,
                       Grid* grid);
  void handleTouchMoved(const ofPoint& grid_point, int palette_idx,
                        Grid* grid);
  void handleTap(int shape_idx, Grid* grid);
  void rotateShapes(Grid* grid);
  void handleSweep(int shape_idx, const ofVec3f& dir_vec, Grid* grid);
  void handleDrag(int shape_idx, const ofPoint& grid_point, Grid* grid);
  
  void handleChangeColorEvent(int palette_idx, int scale_idx);
  
  // for layers
  bool getShapeState(int shape_idx) const;
  int findShapeIndex(const ofTouchEventArgs& touch,
                     const ofPoint& grid_point) const;
  void setLayerAlpha(float layer_alpha);
  void setHoldingShapeIndex(int shape_idx);
  void resetHoldingShapeIndex();
  
  // ca runner
  CARunner* getCARunner();
  void startPlayer();
  void stopPlayer();
  void setScaleIndex(int scale_idx);
  
  // for setting xml methods
  void addToSettings(const std::string& xpath, const TimeDiff trigger_time,
                     Settings* settings);
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  Track(const Track&);
  Track& operator=(const Track&);

  const std::string trackToXmlString(const TimeDiff trigger_time) const;

  int nextNoteNumber(int note_degree, const ofPoint& point) const;
  int nextNoteNumberWithNoRest(const ofPoint& point);
  
  void init(int palette_idx, int scale_idx);
  void init(int palette_idx, int scale_idx,
            const std::string& xpath, ofXml& xml, Grid* grid);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  const int track_idx_;
  
  CARunner* ca_runner_;
  ns_sound::Sound* sound_;
  ns_graphics::Graphics* graphics_;
  bool filling_;
  
};


}  // namespace ns_composition
  
}  // namespace cellophane
