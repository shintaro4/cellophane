//
//  coordination_helper.mm
//

#include "coordination_helper.h"
#include "Timekeeper.h"
#include "sound_helper.h"
#include "shape_helper.h"
#include "graphics_helper.h"


namespace cellophane {
  
namespace ns_composition {


// aliases
using EG = lib_maximplus::Envelope;
using SynthArgs = ns_sound::Sound::SynthArgs;
using ShapeArgs = ns_shape::ShapeArgs;

  
void coordinatePlayer(const KT::PlayerEventArgs& args,
                      const ofPoint& center, const ofColor& color,
                      bool filling, int note_number,
                      Sound* sound, Graphics* graphics, Grid* grid) {
  const SynthArgs synth_args =
      ns_sound::createPlayerArgs(args.duration, note_number,
                                 EG::kAR_aR, center.x, args.ca);
  const ShapeArgs shape_args =
      ns_shape::createPlayerArgs(center, color, filling, args.duration,
                                 args.ca);
  
  const int duration = ns_graphics::mapOnDuration(synth_args.duration);
  const int step_time = Timekeeper::getInstance().getStepTime();
  const int noise = static_cast<int>(ofRandom(0.125f) * step_time);
  graphics->setupShape(args.timestamp + noise, duration, shape_args, grid);
  sound->assignInst(args.timestamp + noise, synth_args);
}

void coordinateTouchDown(const ofPoint& center, const ofColor& color,
                         bool filling, int note_number, BaseCA* ca,
                         Sound* sound, Graphics* graphics, Grid* grid) {
  const SynthArgs synth_args =
      ns_sound::createUserArgs(note_number, EG::kAR_aR, center.x, ca);
  const ShapeArgs shape_args =
      ns_shape::createUserTouchDownArgs(center, color, filling,
                                        synth_args.duration, ca);

  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  const int duration = ns_graphics::mapOnDuration(synth_args.duration);
  graphics->setupShape(timestamp, duration, shape_args, grid);
  sound->assignInst(timestamp, synth_args);
}
  
void coordinateTouchMoved(const ofPoint& center, const ofColor& color,
                          bool filling, int note_number, BaseCA* ca,
                          Sound* sound, Graphics* graphics, Grid* grid) {
  const SynthArgs synth_args =
      ns_sound::createSEArgs(KT::kMinSoundDuration, note_number,
                             EG::kMinAR_aR, center.x);
  const ShapeArgs shape_args =
      ns_shape::createUserTouchMovedArgs(center, color, filling,
                                         synth_args.duration, ca);

  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  graphics->setupShape(timestamp, KT::kMinDeployDuration, shape_args, grid);
  sound->assignSE(timestamp, synth_args);
}
  
void coordinateTap(bool filling, int note_number, const ofPoint& grid_point,
                   Sound* sound, Graphics* graphics, Grid* grid) {
  graphics->rotateShapes(KT::kMaxDeployDuration, filling, grid);
  assignSESound(KT::kMaxDeployDuration, note_number, EG::kAR_Ar,
                grid_point.x, sound);
}

void coordinateSweep(int shape_idx, int note_number, const ofPoint& grid_point,
                     Sound* sound, Graphics* graphics, Grid* grid) {
  graphics->moveShape(shape_idx, KT::kSweepGraphicsDuration, grid_point, grid);
  assignSESound(KT::kSweepSoundDuration, note_number, EG::kMinAR_Ar,
                grid_point.x, sound);
}
 
void coordinateDrag(int shape_idx, int note_number, const ofPoint& grid_point,
                    Sound* sound, Graphics* graphics, Grid* grid) {
  graphics->moveShape(shape_idx, KT::kMinDeployDuration, grid_point, grid);
  assignSESound(KT::kMinSoundDuration, note_number, EG::kMinAR_aR,
                grid_point.x, sound);
}

void assignSESound(int duration, int note_number, EGTypes eg_type, float x,
                   Sound* sound) {
  const SynthArgs synth_args =
      ns_sound::createSEArgs(duration, note_number, eg_type, x);
  const TimeDiff timestamp = Timekeeper::getInstance().getElapsed();
  sound->assignSE(timestamp, synth_args);
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane