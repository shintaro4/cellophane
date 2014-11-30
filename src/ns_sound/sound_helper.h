//
//  sound_helper.h
//

#pragma once

#include "ofMain.h"
#include "Sound.h"
#include "BaseCellularAutomata.h"


namespace cellophane {
  
namespace ns_sound {
    
  
// aliases
using BaseCA = cellophane::ns_composition::BaseCellularAutomata;
using EGTypes = lib_maximplus::Envelope::Types;


const std::pair<int, int> getPresetBaseKeyRange(int preset_number);
int createDurationByCA(BaseCA* ca);
float createVelocity(EGTypes eg_type);
float createVelocityByCA(EGTypes eg_type, BaseCA* ca);
float createVelocity(EGTypes type, int step);
float createPan(float x);
  
const Sound::SynthArgs
createUserArgs(int note_number, EGTypes eg_type, float x, BaseCA* ca);

const Sound::SynthArgs
createPlayerArgs(int duration, int note_number, EGTypes eg_type, float x,
               BaseCA* ca);

const Sound::SynthArgs
createSEArgs(int duration, int note_number, EGTypes eg_type, float x);
  

}  // namespace ns_sound
  
}  // namespace cellophane
