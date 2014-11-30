//
//  Timekeeper.mm
//

#include "Timekeeper.h"


namespace cellophane {


//--------------------------------------------------------------
// constants
//--------------------------------------------------------------
const int Timekeeper::kDefaultBPM = 90;
const int Timekeeper::kDefaultBeats = 4;
const int Timekeeper::kSampleRate = 44100;
const u_int32_t Timekeeper::kPeriodicInterval = 10;  // 10 milliceconds
const u_int32_t Timekeeper::kSecondInMicroSeconds =  1000000;
const u_int32_t Timekeeper::kMinuteInMicroSeconds = 60000000;
const float Timekeeper::kSamplesPerMicroSecond =
  kSampleRate / static_cast<float>(kSecondInMicroSeconds);
const int Timekeeper::kStepResolution = 16;
  
//--------------------------------------------------------------
// events
//--------------------------------------------------------------
ofEvent<TimeDiff> Timekeeper::stepEvent = ofEvent<TimeDiff>();
  
//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------
Timekeeper& Timekeeper::getInstance() {
  static Timekeeper instance;
  return instance;
}

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Timekeeper::Timekeeper() : timer_(NULL), next_step_time_(0), step_time_(0) {}

Timekeeper::~Timekeeper() {
  stop_watch_.stop();
  delete timer_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Timekeeper::init(const Poco::AbstractTimerCallback &callback) {
  if (!timer_) {
    timer_ = new Poco::Timer(0, kPeriodicInterval);
    timer_->start(callback, Poco::Thread::PRIO_HIGHEST);
    step_time_ =
        kMinuteInMicroSeconds / kDefaultBPM * kDefaultBeats / kStepResolution;
    next_step_time_ = step_time_;
  }
}

void Timekeeper::start() {
  stop_watch_.start();
}
  
void Timekeeper::stop() {
  stop_watch_.stop();
}

void Timekeeper::restart(int bpm) {
  stop_watch_.stop();
  step_time_ = kMinuteInMicroSeconds / bpm * kDefaultBeats / kStepResolution;
  next_step_time_ = step_time_;
  stop_watch_.restart();
}

void Timekeeper::refresh() {
  if (getElapsed() >= next_step_time_) {
    ofNotifyEvent(stepEvent, next_step_time_);
    next_step_time_ += step_time_;
  }
}
  
void Timekeeper::changeBPM(int bpm) {
  // update bpm params
  const TimeDiff elapsed_time = stop_watch_.elapsed();
  int remaining_time = static_cast<int>(next_step_time_ - elapsed_time);
  if (remaining_time < 0) remaining_time = -remaining_time;
  float remaining_ratio = remaining_time / static_cast<float>(step_time_);
  
  // update the mesure time by new bpm
  step_time_ = kMinuteInMicroSeconds / bpm * kDefaultBeats / kStepResolution;
  next_step_time_ = elapsed_time + remaining_ratio * step_time_;
}
  
//--------------------------------------------------------------
// getter/setter
//--------------------------------------------------------------
TimeDiff Timekeeper::getElapsed() const {
  return stop_watch_.elapsed();
}

int Timekeeper::getStepTime() const {
  return step_time_;
}
  
TimeDiff Timekeeper::getNextStepTime() const {
  return next_step_time_;
}

  
}  // namespace cellophane
