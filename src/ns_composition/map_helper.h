//
//  map_helper.h
//

#pragma once

#include "CARunner.h"


namespace cellophane {
  
namespace ns_composition {

  
int paletteToScaleIndex(int palette_idx);
const CARunner::Pace createPace(int track_idx, int palette_idx, int filling);
int createNoteNumber(int note_degree, const ofPoint& point, int preset_number);
int convertToBaseNoteNumber(const ofPoint& point,
                            const std::pair<int, int>& base_range);

int mapLiveCellIndexOnIndex(int idx, int range);
int mapOnNoteDegree(int idx, int scale_idx);
int mapOnNoteDegreeWithNoRest(int idx, int scale_idx, int range);
int mapOnSteps(int idx, int steps_idx, int range);
  
void manipulateCellSequence(BaseCellularAutomata* ca);

  
}  // namespace ns_composition
  
}  // namespace cellophane
