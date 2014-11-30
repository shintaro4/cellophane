//
//  SimpleSynth.h
//

#pragma once

#include "KS.h"
#include "OneVCO.h"
#include "Animation.h"
#include "EGTimer.h"


namespace cellophane {
  
namespace ns_sound {
    
    
// aliases
using OneVCO = lib_maximplus::OneVCO;
using EG = lib_maximplus::Envelope;
using Animation = lib_animation::Animation;
using Transition = lib_animation::Transition;
using Motion = lib_animation::Motion;
    
    
class SimpleSynth : public OneVCO {
      
public:
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kPresetSize = 9;
  static const Settings kPresets[kPresetSize];
  static const int kPresetBaseKeyRanges[kPresetSize][2];
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  explicit SimpleSynth(int preset_number);
  ~SimpleSynth();
  
  bool getState() const;
  
  virtual void prepare(const TimeDiff timestamp, int duration, int note_number,
                       float velocity, EG::Types eg_type, float pan);
  
  void update(const TimeDiff current_time);
  void free();
  int getPreset() const;
  void setPreset(int preset_number);
  
  float getCurrentValue(KS::Params param) const;
  float getEndValue(KS::Params param) const;
  void setTransition(KS::Params param, Transition trans);
  
protected:
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------
  
  virtual float synthesize();
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  SimpleSynth(const SimpleSynth&);
  SimpleSynth& operator=(const SimpleSynth&);
  
  void handleTrigger(const TimeDiff current_time);
  void updateParam(int param_idx, float value);
  void updateParams(const std::vector<Motion>& motions);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  int preset_number_;
  Animation* animation_;
  EGTimer* eg_timer_;
  
};
  
  
}  // namespace ns_sound
  
}  // namespace cellophane
