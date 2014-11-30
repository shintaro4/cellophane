//
//  Sound.h
//

#pragma once

#include "SimpleSynth.h"
#include "Settings.h"
#include "SynthIndexManager.h"


namespace cellophane {

namespace ns_sound {

  
// aliases
using Synth = ns_sound::SimpleSynth;
using EGTypes = lib_maximplus::Envelope::Types;


class Sound {

public:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  struct SynthArgs {
    int duration;
    int note_number;
    float velocity;
    EGTypes eg_type;
    float pan;
  };

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Sound(int preset_number);
  ~Sound();
  
  void update(const TimeDiff current_time);
  const std::pair<float, float> play(const TimeDiff current_time);
  void clear();

  void assignInst(const TimeDiff timestamp, const SynthArgs& args);
  void assignSE(const TimeDiff timestamp, const SynthArgs& args);
  void free(int idx);
  
  int getPreset() const;
  void setPreset(int preset_number);
  
private:
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Sound(const Sound&);
  Sound& operator=(const Sound&);
  
  void assign(int prev_idx, int synth_idx, const TimeDiff timestamp,
              const SynthArgs& args);
  
  const std::string velocityOffsetToXmlString() const;
  
  void init(int preset_number);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::vector<Synth*> synths_;
  SynthIndexManager* synth_idx_manager_;
  
};
  
  
}  // namespace ns_sound
  
}  // namespace cellophane