//
//  KM.mm
//

#include "KM.h"

namespace cellophane {
  
  
//--------------------------------------------------------------
// musical constants
//--------------------------------------------------------------
const int KM::kScaleList[kScaleListSize][kScaleDegreeSize] = {
  // {degree1, degree2, ..., degree12}
  
  // Modes of limited transposition
  // http://en.wikipedia.org/wiki/Modes_of_limited_transposition

  // Messiaen's mode 1 : intervals = (tone)
  {0, 0, 2, 2, 4, 4, 6, 6, 8, 8, 10, 10},  // C, D, E, F#, G#, A#
  {1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 11, 11},  // C#, D#, F, G, A, B

  // Messiaen's mode 2 : intervals = (semitone, tone)
  {0, 0, 1, 3, 3, 4, 6, 6, 7, 9, 9, 10},    // C, Db, Eb, E, F#, G, A, Bb
  {1, 1, 2, 4, 4, 5, 7, 7, 8, 10, 10, 11},  // C#, D, E, F, G, G#, A#, B
  {2, 2, 3, 5, 5, 6, 8, 8, 9, 11, 11, 0},   // D, Eb, F, F#, G#, A, B, C

  // Octatonic (8 tones per octave)
  {0, 2, 2, 3, 5, 5, 6, 8, 8, 9, 11, 11},
  {0, 1, 1, 3, 4, 4, 6, 7, 7, 9, 10, 10},

  // Heptatonic (7 tones per octave)
  {0, 0, 2, 2, 4, 5, 5, 7, 7, 9, 9, 11},   // ionian
  {0, 0, 2, 2, 3, 5, 5, 7, 7, 9, 10, 10},  // dorian
  {0, 0, 1, 3, 3, 5, 5, 7, 7, 8, 10, 10},  // phrigian
  {0, 0, 2, 2, 4, 4, 6, 6, 7, 9, 9, 11},   // lydian
  {0, 0, 2, 2, 4, 4, 5, 7, 7, 9, 10, 10},  // mixolydian
  {0, 0, 2, 2, 3, 5, 5, 7, 7, 8, 10, 10},  // aeolian
  {0, 0, 1, 3, 3, 5, 5, 6, 8, 8, 10, 10},  // locrian
  
  // Hexatonic (6 tones per octave)
  {0, 0, 2, 2, 4, 4, 6, 6, 8, 8, 9, 9},
  {0, 0, 3, 3, 5, 5, 6, 6, 7, 7, 10, 10},
  
  // Pentatonic (5 tones per octave)
  {0, 0, 3, 3, 3, 5, 5, 7, 7, 10, 10, 10},
  {0, 0, 2, 2, 2, 4, 4, 7, 7, 9, 9, 9}
};
  
const int KM::kScaleSet[kScaleSetSize][2] = {
  // {index_offset, scale_list_size}

  // scale lists
  {0, 2},  // Messiaen's mode 1
  {2, 3},  // Messiaen's mode 2
  {5, 2},  // Octatonic
  {7, 7},  // Heptatonic
  {14, 2}, // Hexatonic
  {16, 2}, // Pentatonic
};
  
const int KM::kStepsList[kStepsListSize][kStepsListItemSize] = {
  //  {list_size,
  //              steps1, steps2, ..., stepsN}

  {8,
    1, 2, 3, 4, 6, 8, 12, 16},
  {3,
    2, 4, 8, -1, -1, -1, -1, -1},
  {4,
    3, 4, 6, 8, -1, -1, -1, -1},
  {4,
    4, 6, 8, 12, -1, -1, -1, -1},
  {7,
    2, 3, 4, 6, 8, 12, 16, -1},
  {5,
    2, 3, 4, 6, 8, -1, -1, -1},
};
  
const int KM::kHoldingSteps[kHoldingStepsSize] = {
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
};

const int KM::kScaleMap[KC::kPaletteSize] = {
  // palette_idx -> scale_set_idx
  5, 3, 1,
};

const int KM::kStepsMap[KC::kPaletteSize][KT::kTotalTrackSize] = {
  // palette_idx -> track_idx -> steps_list_idx
  {0, 1, 1, 1},
  {0, 2, 2, 2},
  {0, 3, 3, 3}
};

const int KM::kHoldingStepsMap[KC::kPaletteSize][KT::kTotalTrackSize] = {
  // palette_idx -> track_idx -> holding_steps_idx
  {0, 3, 3, 3},
  {0, 1, 1, 1},
  {0, 0, 0, 0}
};

  
}  // namespace cellophane