//
//  Track.mm
//

#include "Track.h"
#include "track_save_xml_helper.h"
#include "track_load_xml_helper.h"
#include "helper.h"
#include "ca_helper.h"
#include "direction_helper.h"
#include "coordination_helper.h"
#include "graphics_helper.h"
#include "map_helper.h"
#include "Timekeeper.h"
#include "KD.h"
#include "track_defaults_helper.h"


namespace cellophane {
  
namespace ns_composition {
    

// aliases
using Assignment = cellophane::ns_graphics::Grid::Assignment;
  
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Track::Track(int track_idx, int palette_idx, int scale_idx,
             const std::string& xpath, ofXml& xml, Grid* grid)
    : track_idx_(track_idx) {
  init(palette_idx, scale_idx, xpath, xml, grid);
}

Track::~Track() {
  delete ca_runner_;
  delete sound_;
  delete graphics_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Track::update(const TimeDiff current_time, Grid* grid) {
  sound_->update(current_time);
  graphics_->update(current_time, grid);
}
  
void Track::draw() {
  graphics_->draw();
}
  
void Track::clear() {
  ca_runner_->clear();
  sound_->clear();
  graphics_->clear();
  filling_ = KD::kDefaultTrackFilling;
}

void Track::adjustTime(const TimeDiff timestamp, int duration) {
  graphics_->adjustTime(timestamp, duration);
}

const std::pair<float, float> Track::play(const TimeDiff current_time) {
  return sound_->play(current_time);
}

//--------------------------------------------------------------
// event methods
//--------------------------------------------------------------
void Track::handlePlayer(KT::PlayerEventArgs& args, int palette_idx,
                         Grid* grid) {
  const Assignment assignment = grid->assign();
  if (assignment.result) {
    const int note_number = nextNoteNumber(args.note_degree, assignment.center);
    const ofColor color = cellophane::getPaletteColor(palette_idx, track_idx_);
    ns_composition::coordinatePlayer(args, assignment.center, color,
                                     filling_, note_number,
                                     sound_, graphics_, grid);
  }
}

void Track::handleTouchDown(const ofPoint& grid_point, int palette_idx,
                            Grid* grid) {
  const int note_number = nextNoteNumberWithNoRest(grid_point);
  const ofColor color = cellophane::getPaletteColor(palette_idx, track_idx_);
  ns_composition::coordinateTouchDown(grid_point, color, filling_,
                                      note_number, ca_runner_->getCA(),
                                      sound_, graphics_, grid);
}

void Track::handleTouchMoved(const ofPoint& grid_point, int palette_idx,
                             Grid* grid) {
  const int note_number = nextNoteNumberWithNoRest(grid_point);
  const ofColor color = cellophane::getPaletteColor(palette_idx, track_idx_);
  ns_composition::coordinateTouchMoved(grid_point, color, filling_, note_number,
                                       ca_runner_->getCA(), sound_, graphics_,
                                       grid);
}
  
void Track::handleTap(int shape_idx, Grid* grid) {
  const Shape* shape = graphics_->getShape(shape_idx);
  if (!shape) return;

  filling_ = !filling_;
  ca_runner_->setStepsHolding(!filling_);
  
  const ofPoint grid_point = ns_graphics::findGridPoint(shape);
  const int note_number = nextNoteNumberWithNoRest(grid_point);

  ns_composition::coordinateTap(filling_, note_number, grid_point,
                                sound_, graphics_, grid);
}

void Track::rotateShapes(Grid* grid) {
  filling_ = !filling_;
  ca_runner_->setStepsHolding(!filling_);
  graphics_->rotateShapes(KT::kMaxDeployDuration, filling_, grid);
}

void Track::handleSweep(int shape_idx, const ofVec3f& dir_vec, Grid* grid) {
  const Shape* shape = graphics_->getShape(shape_idx);
  if (!shape) return;

  const ofPoint grid_point = ns_graphics::findDestinationGridPoint(shape,
                                                                   dir_vec);
  const int note_number = nextNoteNumberWithNoRest(grid_point);
  ns_composition::coordinateSweep(shape_idx, note_number, grid_point,
                                  sound_, graphics_, grid);

  ns_composition::manipulateCellSequence(ca_runner_->getCA());
}
  
void Track::handleDrag(int shape_idx, const ofPoint& grid_point, Grid* grid) {
  const int note_number = nextNoteNumberWithNoRest(grid_point);
  ns_composition::coordinateDrag(shape_idx, note_number, grid_point,
                                 sound_, graphics_, grid);
}

void Track::handleChangeColorEvent(int palette_idx, int scale_idx) {
  // scale
  ca_runner_->setScaleIndex(scale_idx);

  // pace
  const CARunner::Pace pace =
      ns_composition::createPace(track_idx_, palette_idx, filling_);
  ca_runner_->setPace(pace);
  
  // color
  const ofColor color = cellophane::getPaletteColor(palette_idx, track_idx_);
  graphics_->handleChangeColorEvent(color);
  
  // sound
  const int preset_number = KS::kSynthPresetMap[palette_idx][track_idx_];
  sound_->setPreset(preset_number);
}

//--------------------------------------------------------------
// for layers
//--------------------------------------------------------------
bool Track::getShapeState(int shape_idx) const {
  return graphics_->getShapeState(shape_idx);
}
  
int Track::findShapeIndex(const ofTouchEventArgs& touch,
                          const ofPoint& grid_point) const {
  return graphics_->findShapeIndex(touch, grid_point);
}

void Track::setLayerAlpha(float layer_alpha) {
  graphics_->setLayerAlpha(layer_alpha);
}

void Track::setHoldingShapeIndex(int shape_idx) {
  graphics_->setHoldingShapeIndex(shape_idx);
}
  
void Track::resetHoldingShapeIndex() {
  graphics_->resetHoldingShapeIndex();
}
  
//--------------------------------------------------------------
// ca track methods
//--------------------------------------------------------------
CARunner* Track::getCARunner() {
  return ca_runner_;
}
  
void Track::startPlayer() {
  ca_runner_->setState(true);
}

void Track::stopPlayer() {
  ca_runner_->setState(false);
}
  
void Track::setScaleIndex(int scale_idx) {
  ca_runner_->setScaleIndex(scale_idx);
}

//--------------------------------------------------------------
// setting xml methods
//--------------------------------------------------------------
void Track::addToSettings(const std::string& xpath, const TimeDiff trigger_time,
                          Settings* settings) {
  settings->addTo(xpath, trackToXmlString(trigger_time));
}
  
const std::string Track::trackToXmlString(const TimeDiff trigger_time) const {
  std::string s;
  
  s += ns_composition::graphicsToXmlString(graphics_);
  s += ns_composition::CARunnerToXmlString(ca_runner_, trigger_time);
  s += "<filling>" + ofToString(filling_) + "</filling>";

  return "<track>" + s + "</track>";
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
int Track::nextNoteNumber(int note_degree, const ofPoint& point) const {
  const int preset_number = sound_->getPreset();
  return ns_composition::createNoteNumber(note_degree, point, preset_number);
}

int Track::nextNoteNumberWithNoRest(const ofPoint& point) {
  const int note_degree = ca_runner_->nextNoteDegreeWithNoRest();
  const int preset_number = sound_->getPreset();
  return ns_composition::createNoteNumber(note_degree, point, preset_number);
}
  
//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Track::init(int palette_idx, int scale_idx) {
  // ca runner
  ca_runner_ = ns_composition::getDefaultCARunner(track_idx_, palette_idx,
                                                  scale_idx, filling_);
  // sound
  const int preset_number = KS::kSynthPresetMap[palette_idx][track_idx_];
  sound_ = new Sound(preset_number);
}
  
void Track::init(int palette_idx, int scale_idx,
                 const std::string& xpath, ofXml& xml, Grid* grid) {
  // ca runner
  filling_ = ns_composition::loadFilling(xpath + "/filling", xml);
  ca_runner_ = ns_composition::loadCARunner(xpath + "/ca_runner",
                                            xml, track_idx_, palette_idx,
                                            scale_idx, filling_);

  // sound
  const int preset_number = KS::kSynthPresetMap[palette_idx][track_idx_];
  sound_ = new Sound(preset_number);
  
  // graphics
  graphics_ = ns_composition::loadGraphics(track_idx_,
                                           xpath + "/graphics", xml);
  
  ns_composition::registerGrid(track_idx_, graphics_, grid);
}
  

}  // namespace ns_composition
  
}  // namespace cellophane
