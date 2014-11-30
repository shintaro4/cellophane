//
//  Timekeeper.h
//

#pragma once

#include "Poco/Stopwatch.h"
#include "Poco/Thread.h"
#include "Poco/Timestamp.h"
#include "Poco/Timer.h"
#include "ofEvents.h"

#include "Settings.h"


namespace cellophane {


class Timekeeper {

public:

  //--------------------------------------------------------------
  // events
  //--------------------------------------------------------------

  static ofEvent<TimeDiff> stepEvent;
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const int kDefaultBPM;
  static const int kDefaultBeats;
  static const int kSampleRate;
  static const u_int32_t kPeriodicInterval;
  static const u_int32_t kSecondInMicroSeconds;
  static const u_int32_t kMinuteInMicroSeconds;
  static const float kSamplesPerMicroSecond;
  static const int kStepResolution;

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  static Timekeeper& getInstance();
  ~Timekeeper();
  
  void init(const Poco::AbstractTimerCallback& callback);
  void start();
  void stop();
  void restart(int bpm);
  void refresh();
  void changeBPM(int bpm);

  TimeDiff getElapsed() const;
  int getStepTime() const;
  TimeDiff getNextStepTime() const;
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Timekeeper();
  Timekeeper(const Timekeeper&);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  Poco::Timer* timer_;
  Poco::Stopwatch stop_watch_;
  TimeDiff next_step_time_;
  int step_time_;
  
};


}  // namespace cellophane
