//
//  BaseArchitecture.h
//

#pragma once

#include "Poco/Timestamp.h"

#include "KeyBias.h"
#include "Envelope.h"


namespace lib_maximplus {


// aliases
using TimeDiff = Poco::Timestamp::TimeDiff;

  
class BaseArchitecture {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  virtual ~BaseArchitecture();
  
  virtual void prepare(const TimeDiff timestamp, int duration, int note_number,
                       float velocity, Envelope::Types type, float pan) = 0;
  virtual float convertFromNoteNumber(int note_number) = 0;

  virtual void adjustTime(const TimeDiff timestamp, int duration);

  float play(const TimeDiff current_time);
  void stop();

  float getPan() const;
  void setPan(float pan);
  int getBiasPoint() const;
  void setBiasPoint(int bias_point);
  float getBiasLevel() const;
  void setBiasLevel(float bias_level);
  KeyBias::Types getBiasType() const;
  void setBiasType(KeyBias::Types bias_type);
  
protected:

  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------
  
  BaseArchitecture();
  
  virtual float synthesize() = 0;

  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------

  TimeDiff timestamp_;
  int duration_;
  bool trigger_;
  float pan_;
  KeyBias key_bias_;

private:

  BaseArchitecture(const BaseArchitecture&);
  BaseArchitecture& operator=(const BaseArchitecture&);
  
};


}  // namespace lib_maximplus
