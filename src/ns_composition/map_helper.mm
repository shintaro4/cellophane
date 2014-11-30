//
//  map_helper.mm
//

#include "map_helper.h"
#include "Environment.h"
#include "KM.h"
#include "sound_helper.h"
#include "KC.h"


namespace cellophane {
  
namespace ns_composition {

  
// aliases
using Env = cellophane::Environment;
using BaseCA = cellophane::ns_composition::BaseCellularAutomata;


int paletteToScaleIndex(int palette_idx) {
  const int scale_set_idx = KM::kScaleMap[palette_idx];
  return static_cast<int>(ofRandom(KM::kScaleSet[scale_set_idx][0],
                                   KM::kScaleSet[scale_set_idx][1]));
}

const CARunner::Pace createPace(int track_idx, int palette_idx, int filling) {
  const int holding_steps_idx = KM::kHoldingStepsMap[palette_idx][track_idx];
  const int steps_idx = KM::kStepsMap[palette_idx][track_idx];
  return {
    .steps_idx = steps_idx,
    .holding_steps_idx = holding_steps_idx,
    .steps_holding = !filling
  };
}

int createNoteNumber(int note_degree, const ofPoint& point, int preset_number) {
  const std::pair<int, int> base_range =
      ns_sound::getPresetBaseKeyRange(preset_number);
  const int base_note_number = convertToBaseNoteNumber(point, base_range);
  int note_number = note_degree + base_note_number;
  while (note_number < 0) note_number += 12;
  while (note_number >= 128) note_number -= 12;

  return note_number;
}
  
int convertToBaseNoteNumber(const ofPoint& point,
                            const std::pair<int, int>& base_range) {
  const int note_number = ofMap(Env::getInstance().findGridPosition(point.y),
                                Env::getInstance().getVerticalGridSize() - 1, 0,
                                base_range.first, base_range.second);
  return note_number / 12 * 12;
}

int mapLiveCellIndexOnIndex(int idx, int range) {
  if (idx < 0 || range < 0) return -1;
  
  const float ratio =
      static_cast<float>(range - 1) / (BaseCA::kCellSequenceSize - 1);
  return static_cast<int>(roundf(ratio * idx));
}
  
int mapOnNoteDegree(int idx, int scale_idx) {
  return (idx < 0) ? -1 : KM::kScaleList[scale_idx][idx];
}
  
int mapOnNoteDegreeWithNoRest(int idx, int scale_idx, int range) {
  const int list_idx = (idx < 0) ? static_cast<int>(ofRandom(range)) : idx;
  return KM::kScaleList[scale_idx][list_idx];
}
  
int mapOnSteps(int idx, int steps_idx, int range) {
  const int list_idx = (idx < 0) ?
      static_cast<int>(ofRandom(range)) + 1 : idx + 1;
  return KM::kStepsList[steps_idx][list_idx];
}

void manipulateCellSequence(BaseCellularAutomata* ca) {
  ca->rotate(1);
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
