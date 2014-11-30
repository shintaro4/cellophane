//
//  ThreeVCO.mm
//

#include "ThreeVCO.h"


namespace lib_maximplus {
  
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
ThreeVCO::ThreeVCO() : frequency_(0.0f) {}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float ThreeVCO::convertFromNoteNumber(int note_number) {
  convert converter;
  return converter.mtof(note_number);
}
  
void ThreeVCO::prepare(const TimeDiff timestamp, int duration, int note_number,
                       float velocity, Envelope::Types type, float pan) {
  timestamp_ = timestamp;
  duration_ = duration;
  trigger_ = true;
  pan_ = pan;
  key_bias_.setBias(note_number);
  frequency_ = convertFromNoteNumber(note_number);
  eg_.setEnvelope(duration_, velocity, type, 1.0f);
}
  
ThreeVCO::Settings ThreeVCO::getSettings() const {
  Settings settings = {
    .bias_point = key_bias_.getBiasPoint(),
    .bias_level = key_bias_.getBiasLevel(),
    .bias_type = key_bias_.getBiasType(),
    .vco1_type = vco1_.getType(), .vco1_duty = vco1_.getDuty(),
    .vco1_transpose = vco1_.getTranspose(),
    .vco2_type = vco2_.getType(), .vco2_duty = vco2_.getDuty(),
    .vco2_transpose = vco2_.getTranspose(),
    .vco3_type = vco3_.getType(), .vco3_duty = vco3_.getDuty(),
    .vco3_transpose = vco3_.getTranspose(),
    .vcf_type = vcf_.getType(), .vcf_cutoff = vcf_.getCutoff(),
    .vca_amplifier = vca_.getAmplifier(),
    .lfo_type = lfo_.getType(), .lfo_duty = lfo_.getDuty(),
    .lfo_frequency = lfo_.getFrequency(),
  };
  return settings;
}
  
void ThreeVCO::setSettings(ThreeVCO::Settings settings) {
  key_bias_.setBiasPoint(settings.bias_point);
  key_bias_.setBiasLevel(settings.bias_level);
  key_bias_.setBiasType(settings.bias_type);
  vco1_.setType(settings.vco1_type);
  vco1_.setDuty(settings.vco1_duty);
  vco1_.setTranspose(settings.vco1_transpose);
  vco2_.setType(settings.vco2_type);
  vco2_.setDuty(settings.vco2_duty);
  vco2_.setTranspose(settings.vco2_transpose);
  vco3_.setType(settings.vco3_type);
  vco3_.setDuty(settings.vco3_duty);
  vco3_.setTranspose(settings.vco3_transpose);
  vcf_.setType(settings.vcf_type);
  vcf_.setCutoff(settings.vcf_cutoff);
  vca_.setAmplifier(settings.vca_amplifier);
  lfo_.setType(settings.lfo_type);
  lfo_.setDuty(settings.lfo_duty);
  lfo_.setFrequency(settings.lfo_frequency);
}
  
  
}  // namespace lib_maximplus
