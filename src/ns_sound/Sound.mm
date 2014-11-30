//
//  Sound.mm
//

#include "Sound.h"
#include "Timekeeper.h"
#include "sound_helper.h"
#include "sound_animation_helper.h"


namespace cellophane {
  
namespace ns_sound {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Sound::Sound(int preset_number)
    : synth_idx_manager_(new SynthIndexManager(KS::kTrackInstSize,
                                               KS::kTrackSESize)) {
  init(preset_number);
}

Sound::~Sound() {
  for (std::vector<Synth*>::iterator iter = synths_.begin();
       iter != synths_.end(); ++iter) {
    delete (*iter);
  }
  synths_.clear();
  
  delete synth_idx_manager_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Sound::update(const TimeDiff current_time) {
  for (int i = 0; i < synths_.size(); ++i) {
    synths_[i]->update(current_time);
  }
}

const std::pair<float, float> Sound::play(const TimeDiff current_time) {
  float left_out = 0.0f;
  float right_out = 0.0f;
  for (int i = 0; i < synths_.size(); ++i) {
    if (synths_[i]->getState()) {
      float pan = synths_[i]->getPan();
      float synth_out = synths_[i]->play(current_time);
      left_out += (1.0f - pan) * synth_out;
      right_out += pan * synth_out;
    }
  }
  
  return std::make_pair(left_out, right_out);
}

void Sound::clear() {
  for (int i = 0; i < synths_.size(); ++i) synths_[i]->stop();
}

void Sound::assignInst(const TimeDiff timestamp, const SynthArgs& args) {
  const int prev_idx = synth_idx_manager_->prevInst();
  const int synth_idx = synth_idx_manager_->nextInst();
  assign(prev_idx, synth_idx, timestamp, args);
}

void Sound::assignSE(const TimeDiff timestamp, const SynthArgs& args) {
  const int prev_idx = synth_idx_manager_->prevSE();
  const int synth_idx = synth_idx_manager_->nextSE();
  assign(prev_idx, synth_idx, timestamp, args);
}
  
void Sound::free(int idx) {
  if (idx < 0 || idx >= synths_.size()) return;
  synths_[idx]->free();
}
  
int Sound::getPreset() const {
  return synths_[0]->getPreset();
}
  
void Sound::setPreset(int preset_number) {
  for (int i = 0; i < synths_.size(); ++i) {
    synths_[i]->setPreset(preset_number);
  }
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void Sound::assign(int prev_idx, int synth_idx, const TimeDiff timestamp,
                   const SynthArgs& args) {
  synths_[prev_idx]->free();
  synths_[synth_idx]->prepare(timestamp, args.duration, args.note_number,
                              args.velocity, args.eg_type, args.pan);
}
  
//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Sound::init(int preset_number) {
  // use a vector as a static array
  synths_.resize(KS::kTrackSynthSize);
  for (int i = 0; i < synths_.size(); ++i) {
    synths_[i] = new Synth(preset_number);
  }
}
  

}  // namespace ns_sound
  
}  // namespace cellophane
