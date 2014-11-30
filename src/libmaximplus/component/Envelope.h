//
//  Envelope.h
//

#pragma once

#include "k_maximplus.h"


namespace lib_maximplus {


class Envelope {
  
public:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  enum Types {
    kAR_aR, kAR_Ar, kAR_AR,                     // AR envelope
    kASR_aSr, kASR_aSR, kASR_ASr, kASR_ASR,     // ASR envelope
    kMinAR_aR, kMinAR_Ar, kMinAR_AR,            // minimum AR envelope
    kMinASR_asr,                                // minimum ASR envelope
    kRelative, kSamplePlay                      // specialized envelope
  };

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const int kEGTypeSize;
  static const int kFreeDuration;
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Envelope();

  bool getState() const;
  
  float AR(float input, bool trigger);
  float ASR(float input, bool trigger);
  float ADSR(float input, bool trigger);

  void setEnvelope(int duration, float velocity,
                   Types type, float sustain_level);
  void freeEnvelope();
  
private:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  struct EnvCounts {
    // These count based on a audio sample time.
    int attack;
    int decay;
    int sustain;
    int release;
  };
  
  struct EnvCoefficients {
    float attack;
    float decay;
    float release;
  };
  
  enum EnvPhases {
    kAttackPhase, kDecayPhase, kSustainPhase, kReleasePhase
  };
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kMinIntervalCount;
  static const int kMinAttackCount;
  static const int kMinDecayCount;
  static const int kMinSustainCount;
  static const int kMinReleaseCount;

  static const int kMinFreeCount;
  static const float kMinFreeCoefficient;
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  Envelope(const Envelope&);
  Envelope& operator=(const Envelope&);

  float freeEnvSmoothly(float input);
  
  void setCounts(int duration, Types type);
  void setCoefficients();
  
  void setCountsAR_aR(int duration_count);
  void setCountsAR_Ar(int duration_count);
  void setCountsAR_AR(int duration_count);
  
  void setCountsASR_aSr(int duration_count);
  void setCountsASR_aSR(int duration_count);
  void setCountsASR_ASr(int duration_count);
  void setCountsASR_ASR(int duration_count);
  
  void setCountsMinAR_aR(int duration_count);
  void setCountsMinAR_Ar(int duration_count);
  void setCountsMinAR_AR(int duration_count);
  
  void setCountsMinASR_asr(int duration_count);
  
  void setCountsRelative(int duration_count);
  void setCountsSamplePlay(int duration_count);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  bool state_;
  EnvPhases phase_;
  int sample_count_;
  EnvCounts counts_;
  Types type_;
  float amplitude_;
  float sustain_level_;
  EnvCoefficients coefficients_;
  float velocity_;
  bool freeing_;
  
};


}  // namespace lib_maximplus
