//
//  Envelope.mm
//

#include "Envelope.h"


namespace lib_maximplus {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int Envelope::kEGTypeSize = 13;
const int Envelope::kFreeDuration = kMinFreeCount * kMicroSecondsPerSample;

const int Envelope::kMinIntervalCount = 3072;
const int Envelope::kMinAttackCount   =  384;
const int Envelope::kMinDecayCount    =  384;
const int Envelope::kMinSustainCount  = 2304;
const int Envelope::kMinReleaseCount  =  384;
  
const int Envelope::kMinFreeCount     =  384;
const float Envelope::kMinFreeCoefficient = 1.0f / kMinFreeCount;
  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Envelope::Envelope() : state_(false), phase_(kAttackPhase), sample_count_(0),
    type_(kMinAR_aR), amplitude_(0.0f), sustain_level_(1.0f),
    velocity_(0.0f), freeing_(false) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
bool Envelope::getState() const {
  return state_;
}
  
float Envelope::AR(float input, bool trigger) {
  ++sample_count_;
  
  if (freeing_) return freeEnvSmoothly(input);
  
  // find the envelope phase
  phase_ = kSustainPhase;
  if (!trigger) {
    phase_ = kReleasePhase;
  } else if (sample_count_ < counts_.attack) {
    phase_ = kAttackPhase;
  }
  
  // update the amplitude
  if (phase_ == kAttackPhase && amplitude_ < 1.0f) {
    amplitude_ += coefficients_.attack;
  } else if (phase_ == kSustainPhase) {
    amplitude_ = 1.0f;
  }	else if (phase_ == kReleasePhase && amplitude_ > 0.0f) {
    amplitude_ -= coefficients_.release;
  }
  if (amplitude_ < 0.0f) {
    state_ = false;
    amplitude_ = 0.0f;
  }
  
  return velocity_ * input * amplitude_;
}

float Envelope::ASR(float input, bool trigger) {
  ++sample_count_;

  if (freeing_) return freeEnvSmoothly(input);
  
  // find the envelope phase
  phase_ = kReleasePhase;
  if (trigger && sample_count_ < counts_.attack) {
    phase_ = kAttackPhase;
  } else if (trigger && sample_count_ < counts_.attack + counts_.sustain) {
    phase_ = kSustainPhase;
  }
  
  // update the amplitude
  if (phase_ == kAttackPhase && amplitude_ < 1.0f) {
		amplitude_ += coefficients_.attack;
	} else if (phase_ == kSustainPhase) {
    amplitude_ = 1.0f;
  }	else if (phase_ == kReleasePhase && amplitude_ > 0.0f) {
    amplitude_ -= coefficients_.release;
	}
  if (amplitude_ < 0.0f) {
    state_ = false;
    amplitude_ = 0.0f;
  }
  
  return velocity_ * input * amplitude_;
}

float Envelope::ADSR(float input, bool trigger) {
  ++sample_count_;

  if (freeing_) return freeEnvSmoothly(input);
  
  // find the envelope phase
  phase_ = kReleasePhase;
  if (trigger && sample_count_ < counts_.attack) {
    phase_ = kAttackPhase;
  } else if (trigger && sample_count_ < counts_.attack + counts_.decay) {
    phase_ = kDecayPhase;
  } else if (trigger &&
             sample_count_ < counts_.attack + counts_.decay + counts_.sustain) {
    phase_ = kSustainPhase;
  }

  // update the amplitude
	if (phase_ == kAttackPhase && amplitude_ < 1.0f) {
		amplitude_ += coefficients_.attack;
	} else if (phase_ == kDecayPhase && amplitude_ > sustain_level_) {
    amplitude_ -= coefficients_.decay;
  } else if (phase_ == kSustainPhase) {
    amplitude_ = sustain_level_;
  }	else if (phase_ == kReleasePhase && amplitude_ > 0.0f) {
    amplitude_ -= coefficients_.release;
	}
  if (amplitude_ < 0.0f) {
    state_ = false;
    amplitude_ = 0.0f;
  }
  
  return velocity_ * input * amplitude_;
}

void Envelope::setEnvelope(int duration, float velocity,
                           Types type, float sustain_level) {
  amplitude_ = 0.0f;
  velocity_ = velocity;
  type_ = type;
  sustain_level_ = sustain_level;
  
  setCounts(duration, type);
  setCoefficients();
  
  sample_count_ = 0;
  freeing_ = false;

  state_ = true;
}

void Envelope::freeEnvelope() {
  freeing_ = true;
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
float Envelope::freeEnvSmoothly(float input) {
  amplitude_ -= kMinFreeCoefficient;
  if (amplitude_ < 0.0f) {
    state_ = false;
    amplitude_ = 0.0f;
  }
  return velocity_ * input * amplitude_;
}
  
void Envelope::setCounts(int duration, Types type) {
  int duration_count = duration / kMicroSecondsPerSample;
  if (duration_count < kMinIntervalCount) {
    duration_count = kMinIntervalCount;
  }
  
  if (type == kAR_aR) {
    setCountsAR_aR(duration_count);
  } else if (type == kAR_Ar) {
    setCountsAR_Ar(duration_count);
  } else if (type == kAR_AR) {
    setCountsAR_AR(duration_count);
  }
  else if (type == kASR_aSr) {
    setCountsASR_aSr(duration_count);
  } else if (type == kASR_aSR) {
    setCountsASR_aSR(duration_count);
  } else if (type == kASR_ASr) {
    setCountsASR_ASr(duration_count);
  } else if (type == kASR_ASR) {
    setCountsASR_ASR(duration_count);
  }
  else if (type == kMinAR_aR) {
    setCountsMinAR_aR(duration_count);
  } else if (type == kMinAR_Ar) {
    setCountsMinAR_Ar(duration_count);
  } else if (type == kMinAR_AR) {
    setCountsMinAR_AR(duration_count);
  }
  else if (type == kMinASR_asr) {
    setCountsMinASR_asr(duration_count);
  }
  else if (type == kRelative) {
    setCountsRelative(duration_count);
  } else if (type == kSamplePlay) {
    setCountsSamplePlay(duration_count);
  }
}

void Envelope::setCoefficients() {
  float remains = 1.0f - amplitude_;
  coefficients_.attack = (remains > 0) ? remains / counts_.attack : 0.01f;
  coefficients_.decay = (counts_.decay > 0) ?
  (1.0f - sustain_level_) / counts_.decay : 0.01f;
  coefficients_.release = sustain_level_ / counts_.release;
}

// AR envelope
void Envelope::setCountsAR_aR(int duration_count) {
  counts_.attack = kMinAttackCount;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = duration_count - kMinAttackCount;
}

void Envelope::setCountsAR_Ar(int duration_count) {
  counts_.attack = duration_count - kMinReleaseCount;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = kMinReleaseCount;
}

void Envelope::setCountsAR_AR(int duration_count) {
  int ar_count = duration_count / 2;
  counts_.attack = ar_count;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = ar_count;
}

// ASR envelope
void Envelope::setCountsASR_aSr(int duration_count) {
  counts_.attack = kMinAttackCount;
  counts_.decay = 0;
  counts_.sustain = duration_count - kMinAttackCount - kMinReleaseCount;
  counts_.release = kMinReleaseCount;
}

void Envelope::setCountsASR_aSR(int duration_count) {
  int sr_count = (duration_count - kMinAttackCount) / 2;
  counts_.attack = kMinAttackCount;
  counts_.decay = 0;
  counts_.sustain = sr_count;
  counts_.release = sr_count;
}
  
void Envelope::setCountsASR_ASr(int duration_count) {
  int as_count = (duration_count - kMinReleaseCount) / 2;
  counts_.attack = as_count;
  counts_.decay = 0;
  counts_.sustain = as_count;
  counts_.release = kMinReleaseCount;
}

void Envelope::setCountsASR_ASR(int duration_count) {
  int asr_count = duration_count / 3;
  counts_.attack = asr_count;
  counts_.decay = 0;
  counts_.sustain = asr_count;
  counts_.release = asr_count;
}

// minimum AR envelope
void Envelope::setCountsMinAR_aR(int duration_count) {
  counts_.attack = kMinAttackCount;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = kMinIntervalCount - kMinAttackCount;
}

void Envelope::setCountsMinAR_Ar(int duration_count) {
  counts_.attack = kMinIntervalCount - kMinReleaseCount;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = kMinReleaseCount;
}

void Envelope::setCountsMinAR_AR(int duration_count) {
  int ar_count = kMinIntervalCount / 2;
  counts_.attack = ar_count;
  counts_.decay = 0;
  counts_.sustain = 0;
  counts_.release = ar_count;
}

// minimum ASR envelope
void Envelope::setCountsMinASR_asr(int duration_count) {
  counts_.attack = kMinAttackCount;
  counts_.decay = 0;
  counts_.sustain = kMinSustainCount;
  counts_.release = kMinReleaseCount;
}
  
// specialized envelope
void Envelope::setCountsRelative(int duration_count) {
  float attack_count_ratio = kMinAttackCount /
  static_cast<float>(kMinIntervalCount);
  float release_count_ratio = kMinReleaseCount /
  static_cast<float>(kMinIntervalCount);
  float sustain_count_ratio = 1.0f - attack_count_ratio - release_count_ratio;
  
  counts_.attack = duration_count * attack_count_ratio;
  counts_.decay = 0;
  counts_.sustain = duration_count * sustain_count_ratio;
  counts_.release = duration_count * release_count_ratio;
}
  
void Envelope::setCountsSamplePlay(int duration_count) {
  counts_.attack = 0;
  counts_.decay = 0;
  counts_.sustain = duration_count - kMinReleaseCount;
  counts_.release = kMinReleaseCount;
}
  

}  // namespace lib_maximplus
