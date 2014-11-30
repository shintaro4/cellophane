//
//  SampleBased.mm
//

#include "SampleBased.h"


namespace lib_maximplus {
  

//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const float SampleBased::kEqualTemperament[12] = {
  1.0f, 1.059463f, 1.122462f, 1.189207f, 1.259921f, 1.334840f,
  1.414214f, 1.498307f, 1.587401f, 1.681793f, 1.781797f, 1.887749f
};

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
SampleBased::SampleBased(const std::string& file_name, int sample_note_number)
    : speed_(1.0f), sample_note_number_(sample_note_number) {
  sp_.load(file_name);
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
float SampleBased::convertFromNoteNumber(int note_number) {
  int sample_note_number_idx = sample_note_number_ % 12;
  int note_number_idx = note_number % 12;
  int idx = (12 - sample_note_number_idx + note_number_idx) % 12;
  float speed = kEqualTemperament[idx];
  if (note_number_idx < sample_note_number_idx) speed *= 0.5f;
  
  // shifting octaves 
  int difference = note_number - sample_note_number_;
  for (int diff = difference; diff >=  12; diff -= 12) speed *= 2.0f;
  for (int diff = difference; diff <= -12; diff += 12) speed *= 0.5f;

  return speed;
}

void SampleBased::prepare(const TimeDiff timestamp, int duration,
                          int note_number, float velocity,
                          Envelope::Types type, float pan) {
  timestamp_ = timestamp;
  duration_ = duration;
  trigger_ = true;
  pan_ =pan;
  key_bias_.setBias(note_number);
  speed_ = convertFromNoteNumber(note_number);
  eg_.setEnvelope(duration_, velocity, type, 1.0f);
  sp_.reset();
}

SampleBased::Settings SampleBased::getSettings() const {
  Settings settings = {
    .bias_point = key_bias_.getBiasPoint(),
    .bias_level = key_bias_.getBiasLevel(),
    .bias_type = key_bias_.getBiasType(),
    .vcf_type = vcf_.getType(), .vcf_cutoff = vcf_.getCutoff(),
    .vca_amplifier = vca_.getAmplifier(),
    .lfo_type = lfo_.getType(), .lfo_duty = lfo_.getDuty(),
    .lfo_frequency = lfo_.getFrequency(),
  };
  return settings;
}
  
void SampleBased::setSettings(SampleBased::Settings settings) {
  key_bias_.setBiasPoint(settings.bias_point);
  key_bias_.setBiasLevel(settings.bias_level);
  key_bias_.setBiasType(settings.bias_type);
  vcf_.setType(settings.vcf_type);
  vcf_.setCutoff(settings.vcf_cutoff);
  vca_.setAmplifier(settings.vca_amplifier);
  lfo_.setType(settings.lfo_type);
  lfo_.setDuty(settings.lfo_duty);
  lfo_.setFrequency(settings.lfo_frequency);
}


}  // namespace lib_maximplus
