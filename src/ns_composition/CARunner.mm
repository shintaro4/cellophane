//
//  CARunner.mm
//

#include "CARunner.h"
#include "map_helper.h"
#include "Timekeeper.h"
#include "ca_helper.h"
#include "KM.h"
#include "PlayerCA.h"


namespace cellophane {
  
namespace ns_composition {
    
  
//--------------------------------------------------------------
// events
//--------------------------------------------------------------
ofEvent<KT::PlayerEventArgs> CARunner::playerEvent =
    ofEvent<KT::PlayerEventArgs>();

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
CARunner::CARunner(int track_idx, TimeDiff trigger_time, BaseCA* ca,
                   int scale_idx, const Pace& pace)
    : track_idx_(track_idx), state_(false), trigger_time_(trigger_time),
      ca_(ca), scale_idx_(scale_idx), pace_(pace), interrupting_(false) {
  ofAddListener(Timekeeper::stepEvent, this, &CARunner::handleClockEvent);
}

CARunner::~CARunner() {
  ofRemoveListener(Timekeeper::stepEvent, this, &CARunner::handleClockEvent);
  delete ca_;
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void CARunner::updateCA() {
  ca_->update();
}

void CARunner::clear() {
  ca_->shuffle();
  trigger_time_ = Timekeeper::getInstance().getNextStepTime();
  pace_.steps_holding = false;
}

int CARunner::getLiveCellIndexInRange(int range) {
  return ca_->getLiveCellIndexInRange(range);
}
  
int CARunner::mapLiveCellIndexOnIndex(int range) {
  const int idx = ca_->getLiveCellIndex();
  return ns_composition::mapLiveCellIndexOnIndex(idx, range);
}

int CARunner::nextNoteDegree() {
  const int idx = ca_->getLiveCellIndexInRange(KM::kScaleDegreeSize);
  return ns_composition::mapOnNoteDegree(idx, scale_idx_);
}

int CARunner::nextNoteDegreeWithNoRest() {
  const int range = KM::kScaleDegreeSize;
  const int idx = ca_->getLiveCellIndexInRange(range);
  return ns_composition::mapOnNoteDegreeWithNoRest(idx, scale_idx_, range);
}

//--------------------------------------------------------------
// getter/setter
//--------------------------------------------------------------
bool CARunner::getState() const {
  return state_;
}

void CARunner::setState(bool state) {
  state_ = state;
}
  
TimeDiff CARunner::getTriggerTime() const {
  return trigger_time_;
}

BaseCA* CARunner::getCA() {
  return ca_;
}
  
void CARunner::setScaleIndex(int scale_idx) {
  if (scale_idx < 0 || scale_idx >= KM::kScaleListSize) return;
  scale_idx_ = scale_idx;
}
  
void CARunner::setStepsHolding(bool steps_holding) {
  pace_.steps_holding = steps_holding;
  if (pace_.steps_holding) interrupting_ = true;
}

const CARunner::Pace& CARunner::getPace() const {
  return pace_;
}
  
void CARunner::setPace(const Pace& pace) {
  pace_ = pace;
}
  
int CARunner::getCellSequenceNumber() {
  return ca_->getCellSequenceNumber();
}
  
void CARunner::setMaskSequenceByNumber(int mask_sequence_number) {
  if (track_idx_ != KT::kUserTrackIndex) {
    static_cast<PlayerCA*>(ca_)->setMaskSequenceByNumber(mask_sequence_number);
  }
}
  
//--------------------------------------------------------------
// protected methods
//--------------------------------------------------------------
void CARunner::handleClockEvent(TimeDiff& timestamp) {
  if (!state_ ||
      (!interrupting_ && timestamp < trigger_time_)) return;

  ca_->update();

  const int step_time = Timekeeper::getInstance().getStepTime();
  const int interval = (pace_.steps_holding) ?
      getHoldingInterval(step_time) : createInterval(step_time);
  trigger_time_ = timestamp + interval;

  const int note_degree = (pace_.steps_holding) ?
      nextNoteDegreeWithNoRest() : nextNoteDegree();
  // fire PlayerEvent
  if (track_idx_ > 0 && note_degree >= 0) {
    KT::PlayerEventArgs args = {
      .track_idx = track_idx_, .ca = ca_,
      .timestamp = timestamp, .duration = createDuration(step_time, interval),
      .note_degree = note_degree
    };
    ofNotifyEvent(playerEvent, args);
  }
  
  if (interrupting_) interrupting_ = false;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
int CARunner::createInterval(int step_time) {
  const int range = KM::kStepsList[pace_.steps_idx][0];
  const int idx = ca_->getLiveCellIndexInRange(range);
  const int steps = ns_composition::mapOnSteps(idx, pace_.steps_idx, range);
  return step_time * steps;
}

int CARunner::createDuration(int step_time, int interval) {
  return ofMap(ca_->getLiveRatio(), 0.0f, 1.0f, step_time, interval);
}

int CARunner::getHoldingInterval(int step_time) const {
  return step_time * KM::kHoldingSteps[pace_.holding_steps_idx];
}

  
}  // namespace ns_composition
  
}  // namespace cellophane
