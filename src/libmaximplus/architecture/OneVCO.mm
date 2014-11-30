//
//  OneVCO.mm
//

#include "OneVCO.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
OneVCO::OneVCO() : frequency_(0.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float OneVCO::convertFromNoteNumber(int note_number) {
  convert converter;
  return converter.mtof(note_number);
}

void OneVCO::prepare(const TimeDiff timestamp, int duration, int note_number,
                     float velocity, Envelope::Types type, float pan) {
  timestamp_ = timestamp;
  duration_ = duration;
  trigger_ = true;
  pan_ = pan;
  key_bias_.setBias(note_number);
  frequency_ = convertFromNoteNumber(note_number);
  eg_.setEnvelope(duration_, velocity, type, 1.0f);
}

OneVCO::Settings OneVCO::getSettings() const {
  Settings settings = {
    .bias_point = key_bias_.getBiasPoint(),
    .bias_level = key_bias_.getBiasLevel(),
    .bias_type = key_bias_.getBiasType(),
    .vco_type = vco_.getType(), .vco_duty = vco_.getDuty(),
    .vco_transpose = vco_.getTranspose(),
    .vcf_type = vcf_.getType(), .vcf_cutoff = vcf_.getCutoff(),
    .vca_amplifier = vca_.getAmplifier(),
    .lfo_type = lfo_.getType(), .lfo_duty = lfo_.getDuty(),
    .lfo_frequency = lfo_.getFrequency(),
  };
  return settings;
}
  
void OneVCO::setSettings(OneVCO::Settings settings) {
  key_bias_.setBiasPoint(settings.bias_point);
  key_bias_.setBiasLevel(settings.bias_level);
  key_bias_.setBiasType(settings.bias_type);
  vco_.setType(settings.vco_type);
  vco_.setDuty(settings.vco_duty);
  vco_.setTranspose(settings.vco_transpose);
  vcf_.setType(settings.vcf_type);
  vcf_.setCutoff(settings.vcf_cutoff);
  vca_.setAmplifier(settings.vca_amplifier);
  lfo_.setType(settings.lfo_type);
  lfo_.setDuty(settings.lfo_duty);
  lfo_.setFrequency(settings.lfo_frequency);
}

  
}  // namespace lib_maximplus
