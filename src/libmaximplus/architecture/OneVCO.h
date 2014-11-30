//
//  OneVCO.h
//

#pragma once

#include "BaseArchitecture.h"
#include "Oscillator.h"
#include "Filter.h"
#include "Amplifier.h"
#include "Delay.h"


namespace lib_maximplus {
  

class OneVCO : public BaseArchitecture {
  
public:
  
  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
  
  struct Settings {
    int bias_point;
    float bias_level;
    KeyBias::Types bias_type;
    Oscillator::Types vco_type;
    float vco_duty;
    float vco_transpose;
    Filter::Types vcf_type;
    float vcf_cutoff;
    float vca_amplifier;
    //vector<int> eg_counts;
    //float sustain_level;
    Oscillator::Types lfo_type;
    float lfo_duty;
    float lfo_frequency;
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  virtual float convertFromNoteNumber(int note_number);
  virtual void prepare(const TimeDiff timestamp, int duration, int note_number,
                       float velocity, Envelope::Types type, float pan);

  Settings getSettings() const;
  void setSettings(Settings settings);
  
protected:
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------
  
  OneVCO();
  
  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------

  Oscillator vco_;
  Filter vcf_;
  Amplifier vca_;
  Envelope eg_;
  Oscillator lfo_;
  Delay delay_;
  
  float frequency_;
  
private:
  
  OneVCO(const OneVCO&);
  OneVCO& operator=(const OneVCO&);
  
};


}  // namespace lib_maximplus
