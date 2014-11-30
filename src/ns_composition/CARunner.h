//
//  CARunner.h
//

#pragma once

#include "KT.h"
#include "BaseCellularAutomata.h"
#include "Composition.h"


namespace cellophane {
  
namespace ns_composition {

  
// aliases
using BaseCA = cellophane::ns_composition::BaseCellularAutomata;
  
  
class CARunner {
  
public:

  //--------------------------------------------------------------
  // events
  //--------------------------------------------------------------
  
  static ofEvent<KT::PlayerEventArgs> playerEvent;

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  struct Pace {
    int steps_idx;
    int holding_steps_idx;
    bool steps_holding;
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  CARunner(int track_idx, TimeDiff trigger_time, BaseCA* ca,
           int scale_idx, const Pace& pace);
  ~CARunner();

  void updateCA();
  void clear();

  int getLiveCellIndexInRange(int range);
  int mapLiveCellIndexOnIndex(int range);
  
  int nextNoteDegree();
  int nextNoteDegreeWithNoRest();

  bool getState() const;
  void setState(bool state);
  TimeDiff getTriggerTime() const;
  BaseCA* getCA();
  
  void setScaleIndex(int scale_idx);
  void setStepsHolding(bool steps_holding);
  const Pace& getPace() const;
  void setPace(const Pace& pace);

  int getCellSequenceNumber();
  void setMaskSequenceByNumber(int mask_sequence_number);
  
  void handleClockEvent(TimeDiff& timestamp);

private:
  
  //--------------------------------------------------------------
  // private methods
  //--------------------------------------------------------------

  CARunner(const CARunner&);
  CARunner& operator=(const CARunner&);

  int createInterval(int step_time);
  int createDuration(int step_time, int interval);
  int getHoldingInterval(int step_time) const;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  const int track_idx_;
  bool state_;
  TimeDiff trigger_time_;
  
  BaseCA* ca_;
  int scale_idx_;
  Pace pace_;

  bool interrupting_;
  
};

  
}  // namespace ns_compositon
  
}  // namespace cellophane
