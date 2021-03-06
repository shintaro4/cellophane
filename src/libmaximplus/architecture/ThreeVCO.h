//
//  ThreeVCO.h
//

#pragma once

#include "BaseArchitecture.h"
#include "Oscillator.h"
#include "Filter.h"
#include "Amplifier.h"
#include "Delay.h"


namespace lib_maximplus {
  
  
class ThreeVCO : public BaseArchitecture {
    
public:
    
  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
    
  struct Settings {
    int bias_point;
    float bias_level;
    KeyBias::Types bias_type;
    Oscillator::Types vco1_type;
    float vco1_duty;
    float vco1_transpose;
    Oscillator::Types vco2_type;
    float vco2_duty;
    float vco2_transpose;
    Oscillator::Types vco3_type;
    float vco3_duty;
    float vco3_transpose;
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
  
  ThreeVCO();
  
  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------
  
  Oscillator vco1_;
  Oscillator vco2_;
  Oscillator vco3_;
  Filter vcf_;
  Amplifier vca_;
  Envelope eg_;
  Oscillator lfo_;
  Delay delay_;
  
  float frequency_;
  
private:

  //--------------------------------------------------------------
  // private methods
  //--------------------------------------------------------------

  ThreeVCO(const ThreeVCO&);
  ThreeVCO& operator=(const ThreeVCO&);

  void init(int size);
  
};
  
  
}  // namespace lib_maximplus
