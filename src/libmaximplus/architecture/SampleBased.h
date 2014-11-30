//
//  SampleBased.h
//

#include "BaseArchitecture.h"
#include "Oscillator.h"
#include "Sample.h"
#include "Filter.h"
#include "Amplifier.h"
#include "Delay.h"


namespace lib_maximplus {
  

class SampleBased : public BaseArchitecture {
  
public:
  
  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
  
  struct Settings {
    int bias_point;
    float bias_level;
    KeyBias::Types bias_type;
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
  // protected constants
  //--------------------------------------------------------------

  static const float kEqualTemperament[12];
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------

  SampleBased(const std::string& file_name, int sample_note_number);
  
  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------
  
  Sample sp_;
  Filter vcf_;
  Amplifier vca_;
  Envelope eg_;
  Oscillator lfo_;
  Delay delay_;

  float speed_;
  int sample_note_number_;
  
private:

  SampleBased(const SampleBased&);
  SampleBased& operator=(const SampleBased&);
  
};


}  // namespace lib_maximplus
