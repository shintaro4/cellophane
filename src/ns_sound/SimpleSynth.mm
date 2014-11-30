//
//  SimpleSynth.mm
//

#include "SimpleSynth.h"


namespace cellophane {
  
namespace ns_sound {
    
    
// aliases
using KeyBias = lib_maximplus::KeyBias;
using Oscillator = lib_maximplus::Oscillator;
using Filter = lib_maximplus::Filter;
    
    
//--------------------------------------------------------------
// constatns
//--------------------------------------------------------------
const OneVCO::Settings SimpleSynth::kPresets[kPresetSize] = {
  {
    .bias_point = 60, .bias_level = -0.03f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kSinebuf, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 1.0f
  },
  {
    .bias_point = 60, .bias_level = -0.03f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kTriangle, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 1.0f
  },
  {
    .bias_point = 48, .bias_level = 0.0f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kSquare, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.17f
  },
  {
    .bias_point = 60, .bias_level = 0.0f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kSaw, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.2f
  },
  {
    .bias_point = 60, .bias_level = 0.0f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kPulse, .vco_duty = 0.25f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.17f
  },
  {
    .bias_point = 60, .bias_level = 0.0f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kRP2A03Square1, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.15f
  },
  {
    .bias_point = 60, .bias_level = 0.0f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kRP2A03Square2, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.15f
  },
  {
    .bias_point = 66, .bias_level = -0.013f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kRP2A03Square3, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.15f
  },
  {
    .bias_point = 66, .bias_level = -0.03f, .bias_type = KeyBias::kUpperBias,
    .vco_type = Oscillator::kRP2A03Triangle, .vco_duty = 0.0f,
    .vco_transpose = 1.0f,
    .vcf_type = Filter::kLowPass, .vcf_cutoff = 0.5f,
    .vca_amplifier = 0.5f
  }
};
  
const int SimpleSynth::kPresetBaseKeyRanges[kPresetSize][2] = {
  {60, 84},
  {36, 84},
  {36, 60},
  {60, 84},
  {36, 72},
  {48, 72},
  {48, 72},
  {48, 84},
  {48, 84}
};
    
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
SimpleSynth::SimpleSynth(int preset_number)
    : preset_number_(preset_number), animation_(new Animation(KS::kParamSize)),
      eg_timer_(new EGTimer()) {
  setPreset(preset_number_);
}
    
SimpleSynth::~SimpleSynth() {
  delete animation_;
  delete eg_timer_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
bool SimpleSynth::getState() const {
  return eg_.getState();
}
  
void SimpleSynth::prepare(const TimeDiff timestamp, int duration,
                          int note_number, float velocity,
                          EG::Types eg_type, float pan) {
  timestamp_ = timestamp;
  duration_ = duration;

  pan_ = pan;
  key_bias_.setBias(note_number);
  frequency_ = convertFromNoteNumber(note_number);
  // modulate the frequency in +- 0.5 %
  frequency_ *= ofRandom(0.995f, 1.005f);
  
  eg_timer_->setTimer(timestamp_, duration_, velocity, eg_type);
}
  
void SimpleSynth::update(const TimeDiff current_time) {
  handleTrigger(current_time);
  const std::vector<Motion> motions = animation_->update(current_time);
  updateParams(motions);
}
  
void SimpleSynth::free() {
  stop();
  eg_.freeEnvelope();
  eg_timer_->reset();
}
  
int SimpleSynth::getPreset() const {
  return preset_number_;
}
  
void SimpleSynth::setPreset(int preset_number) {
  if (preset_number < 0 || preset_number >= kPresetSize) preset_number = 0;
  preset_number_ = preset_number;

  setSettings(kPresets[preset_number_]);
}
  
float SimpleSynth::getCurrentValue(KS::Params param) const {
  float value = 0.0f;
  if (param == KS::kVCAAmplifierParam) {
    value = vca_.getAmplifier();
  }
  return value;
}
  
float SimpleSynth::getEndValue(KS::Params param) const {
  int param_i = static_cast<int>(param);
  if (animation_->getTransitionTrigger(param_i)) {
    return animation_->getTransitionEnd(param_i);
  } else {
    return getCurrentValue(param);
  }
}
  
void SimpleSynth::setTransition(KS::Params param, Transition trans) {
  int param_idx = static_cast<int>(param);
  animation_->setTransition(param_idx, trans);
}
  
//--------------------------------------------------------------
// protected methods
//--------------------------------------------------------------
float SimpleSynth::synthesize() {
  float vco_out = vco_.apply(frequency_);
  float vcf_out = vcf_.apply(vco_out);
  float eg_out = eg_.ASR(vcf_out, trigger_);
  float vca_out = vca_.apply(eg_out);
  
  return vca_out * key_bias_.getBias();
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void SimpleSynth::handleTrigger(const TimeDiff current_time) {
  if (eg_timer_->trigger(current_time)) {
    eg_timer_->reset();
    
    trigger_ = true;
    eg_timer_->setEG(eg_);
  }
}
  
void SimpleSynth::updateParam(int param_idx, float value) {
  KS::Params param = static_cast<KS::Params>(param_idx);
  if (param == KS::kVCAAmplifierParam) {
    vca_.setAmplifier(value);
  }
}
  
void SimpleSynth::updateParams(const std::vector<Motion>& motions) {
  for (int i = 0; i < motions.size(); ++i) {
    if (motions[i].changed) updateParam(i, motions[i].value);
  }
}
  
    
}  // namespace ns_sound
  
}  // namespace cellophane
