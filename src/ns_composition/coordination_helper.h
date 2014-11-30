//
//  coordination_helper.h
//

#pragma once

#include "Sound.h"
#include "Graphics.h"
#include "Grid.h"
#include "KT.h"


namespace cellophane {
  
namespace ns_composition {
  

// aliases
using Sound = ns_sound::Sound;
using Graphics = ns_graphics::Graphics;
using Grid = ns_graphics::Grid;
using EGTypes = lib_maximplus::Envelope::Types;
using BaseCA = cellophane::ns_composition::BaseCellularAutomata;

  
void coordinatePlayer(const KT::PlayerEventArgs& args,
                      const ofPoint& center, const ofColor& color,
                      bool filling, int note_number,
                      Sound* sound, Graphics* graphics, Grid* grid);
void coordinateTouchDown(const ofPoint& center, const ofColor& color,
                         bool filling, int note_number, BaseCA* ca,
                         Sound* sound, Graphics* graphics, Grid* grid);
void coordinateTouchMoved(const ofPoint& center, const ofColor& color,
                          bool filling, int note_number, BaseCA* ca,
                          Sound* sound, Graphics* graphics, Grid* grid);
void coordinateTap(bool filling, int note_number, const ofPoint& grid_point,
                   Sound* sound, Graphics* graphics, Grid* grid);
void coordinateSweep(int shape_idx, int note_number, const ofPoint& grid_point,
                     Sound* sound, Graphics* graphics, Grid* grid);
void coordinateDrag(int shape_idx, int note_number, const ofPoint& grid_point,
                    Sound* sound, Graphics* graphics, Grid* grid);
  
void assignSESound(int duration, int note_number, EGTypes eg_type, float x,
                   Sound* sound);
  
  
}  // namespace ns_composition
  
}  // namespace cellophane