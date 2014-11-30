//
//  Composition.mm
//

#include "Composition.h"
#include "sound_helper.h"
#include "track_load_xml_helper.h"
#include "helper.h"
#include "Timekeeper.h"
#include "KM.h"
#include "KC.h"


namespace cellophane {

namespace ns_composition {
    
  
//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
// for xml settings
const std::string Composition::kCompositionXPath = "composition";
const std::string Composition::kTracksXPath = "tracks";
const std::string Composition::kGridXPath = "grid";
const std::string Composition::kScalePath = "scale";
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Composition::Composition(int palette_idx, ofXml& xml)
    : grid_(new Grid()), palette_idx_(palette_idx), scale_idx_(0) {
  initTracks(xml);
  initGrid(xml);
  startCARunners();
}

Composition::~Composition() {
  for (std::vector<Track*>::iterator iter = tracks_.begin();
       iter != tracks_.end(); ++iter) {
    const CARunner* ca_runner = (*iter)->getCARunner();
    ofRemoveListener(ca_runner->playerEvent, this, &Composition::handlePlayer);
    delete (*iter);
  }
  tracks_.clear();

  delete grid_;
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Composition::update(const TimeDiff current_time) {
  for (int i = 0; i < tracks_.size(); ++i) {
    tracks_[i]->update(current_time, grid_);
  }
}

void Composition::draw() {
//  grid_->drawAllGridPoints();
  for (int i = tracks_.size() - 1; i >= 0; --i) tracks_[i]->draw();
//  grid_->drawAssignedCenters();
//  grid_->drawNeighbors();
}
  
bool Composition::getShapeState(const KG::ShapeKey& key) const {
  return tracks_[key.track_idx]->getShapeState(key.shape_idx);
}

const KG::ShapeKey Composition::findShapeKey(const ofTouchEventArgs& touch,
                                             const ofPoint& grid_point) const {
  for (int i = 0; i < tracks_.size(); ++i) {
    int shape_idx = tracks_[i]->findShapeIndex(touch, grid_point);
    if (shape_idx >= 0) {
      return {.track_idx = i, .shape_idx = shape_idx};
    }
  }
  
  return {.track_idx = -1, .shape_idx = -1};
}
  
const std::vector<KG::ShapeKey>
Composition::findShapeKeys(const ofTouchEventArgs& touch,
                           const ofPoint& grid_point) const {
  std::vector<KG::ShapeKey> shape_keys;
  
  for (int i = 0; i < tracks_.size(); ++i) {
    int shape_idx = tracks_[i]->findShapeIndex(touch, grid_point);
    if (shape_idx >= 0) {
      KG::ShapeKey shape_key = {
        .track_idx = i, .shape_idx = shape_idx
      };
      shape_keys.push_back(shape_key);
    }
  }
  return shape_keys;
}

void Composition::setHoldingShapeIndex(const KG::ShapeKey& key) {
  if (key.track_idx >= 0 && key.track_idx < KT::kTotalTrackSize &&
      key.shape_idx >= 0 && key.shape_idx < KG::kTrackShapeSize) {
    tracks_[key.track_idx]->setHoldingShapeIndex(key.shape_idx);
  }
}
 
void Composition::resetHoldingShapeIndex() {
  for (int i = 0; i < tracks_.size(); ++i) tracks_[i]->resetHoldingShapeIndex();
}

void Composition::adjustTime(const TimeDiff timestamp, int duration) {
  for (int i = 0; i < tracks_.size(); ++i) {
    tracks_[i]->adjustTime(timestamp, duration);
  }
}
  
void Composition::audioOut(float* output, int buffer_size, int n_channels) {
  const TimeDiff current_time = Timekeeper::getInstance().getElapsed();
  for (int i = 0; i < buffer_size; ++i) {
    float left_out = 0.0f;
    float right_out = 0.0f;
    for (int i = 0; i < tracks_.size(); ++i) {
      std::pair<float, float> track_out = tracks_[i]->play(current_time);
      left_out += track_out.first;
      right_out += track_out.second;
    }

    output[i * n_channels]     = left_out;
    output[i * n_channels + 1] = right_out;
  }
}

//--------------------------------------------------------------
// event handlers
//--------------------------------------------------------------
void Composition::handlePlayer(KT::PlayerEventArgs& args) {
  if (grid_->getShapeCenterSize() <= 0) return;

  tracks_[args.track_idx]->handlePlayer(args, palette_idx_, grid_);
}
  
void Composition::handleTouchDown(const ofPoint& grid_point) {
  CARunner* ca_runner = tracks_[KT::kUserTrackIndex]->getCARunner();
  ca_runner->updateCA();

  updateScaleIndex(ca_runner);
  maskPlayerCAs(ca_runner);
  
  tracks_[KT::kUserTrackIndex]->handleTouchDown(grid_point, palette_idx_,
                                                grid_);
}

void Composition::handleTouchMoved(const ofPoint& grid_point) {
  tracks_[KT::kUserTrackIndex]->handleTouchMoved(grid_point, palette_idx_,
                                                 grid_);
}
  
void Composition::handleTap(const KG::ShapeKey& key) {
  if (key.track_idx == KT::kUserTrackIndex) {
    for (int i = 1; i < tracks_.size(); ++i) tracks_[i]->rotateShapes(grid_);
  }
  tracks_[key.track_idx]->handleTap(key.shape_idx, grid_);
}

void Composition::handleSweep(const KG::ShapeKey& key, const ofVec3f& dir_vec) {
  tracks_[key.track_idx]->handleSweep(key.shape_idx, dir_vec, grid_);
}

void Composition::handleDrag(const KG::ShapeKey& key,
                             const ofPoint& grid_point) {
  tracks_[key.track_idx]->handleDrag(key.shape_idx, grid_point, grid_);
}

void Composition::handleChangeColorEvent(int palette_idx) {
  if (palette_idx < 0 || palette_idx >= KC::kPaletteSize) return;
  palette_idx_ = palette_idx;

  // update scale indices by the new set
  CARunner* ca_runner = tracks_[KT::kUserTrackIndex]->getCARunner();
  updateScaleIndex(ca_runner);
  for (int i = 0; i < tracks_.size(); ++i) {
    tracks_[i]->handleChangeColorEvent(palette_idx_, scale_idx_);
  }
}
    
//--------------------------------------------------------------
// setters
//--------------------------------------------------------------
void Composition::clear() {
  grid_->clear();
  for (int i = 0; i < tracks_.size(); ++i) tracks_[i]->clear();
}
  
void Composition::setAlpha(float alpha) {
  for (int i = 0; i < tracks_.size(); ++i) {
    tracks_[i]->setLayerAlpha(alpha);
  }
}
  
//--------------------------------------------------------------
// setting xml methods
//--------------------------------------------------------------
void Composition::addToSettings(Settings* settings) {
  const std::vector<TimeDiff> trigger_times = getReducedTriggerTimes();
  for (int i = 0; i < tracks_.size(); ++i) {
    tracks_[i]->addToSettings(kTracksXPath, trigger_times[i], settings);
  }
  grid_->addToSettings(kGridXPath, settings);
  settings->addTo(kScalePath, "<idx>" + ofToString(scale_idx_) + "</idx>");
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
const std::vector<TimeDiff> Composition::getReducedTriggerTimes() const {
  std::vector<TimeDiff> trigger_times;
  for (int i = 0; i < tracks_.size(); ++i) {
    trigger_times.push_back(tracks_[i]->getCARunner()->getTriggerTime());
  }
  const TimeDiff smallest = *std::min_element(trigger_times.begin() + 1,
                                              trigger_times.end());
  const TimeDiff step_time = Timekeeper::getInstance().getStepTime();
  for (int i = 1; i < trigger_times.size(); ++i) {
    trigger_times[i] = trigger_times[i] - smallest + step_time;
  }
  
  return trigger_times;
}
  
void Composition::maskPlayerCAs(CARunner* ca_runner) {
  const int cell_sequence_number = ca_runner->getCellSequenceNumber();
  for (int i = 1; i < tracks_.size(); ++i) {
    tracks_[i]->getCARunner()->setMaskSequenceByNumber(cell_sequence_number);
  }
}

void Composition::updateScaleIndex(CARunner* ca_runner) {
  const int scale_set_idx = KM::kScaleMap[palette_idx_];
  const int offset = KM::kScaleSet[scale_set_idx][0];
  const int range = KM::kScaleSet[scale_set_idx][1];
  const int idx = ca_runner->getLiveCellIndexInRange(range);
  if (idx != -1) {
    scale_idx_ = offset + idx;
    for (int i = 0; i < tracks_.size(); ++i) {
      tracks_[i]->setScaleIndex(scale_idx_);
    }
  }
}

//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Composition::initTracks(ofXml& xml) {
  // use a vector as a static array
  tracks_.resize(KT::kTotalTrackSize);
  
  scale_idx_ = ns_composition::loadScaleIndex(kScalePath, xml, palette_idx_);
  xml.reset();
  for (int i = 0; i < tracks_.size(); ++i) {
    const std::string xpath = kTracksXPath + "/track[" + ofToString(i) + "]";
    tracks_[i] = new Track(i, palette_idx_, scale_idx_, xpath, xml, grid_);
  }
}

void Composition::initGrid(ofXml& xml) {
  const std::string forms_path = kGridXPath + "/forms";
  const std::deque<Form> forms = ns_composition::loadForms(forms_path, xml);
  grid_->mergeForms(forms);
}
  
void Composition::startCARunners() {
  for (int i = 0; i < tracks_.size(); ++i) {
    ofAddListener(tracks_[i]->getCARunner()->playerEvent,
                  this, &Composition::handlePlayer);
    if (i > 0) tracks_[i]->startPlayer();
  }
}

  
}  // namespace ns_composition
  
}  // namespace cellophane
