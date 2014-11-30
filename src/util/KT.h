//
//  KT.h
//

#pragma once

#include "ofMain.h"
#include "k_aliases.h"
#include "BaseCellularAutomata.h"
#include "Envelope.h"


namespace cellophane {


class KT {

public:
  
  //--------------------------------------------------------------
  // track constants
  //--------------------------------------------------------------

  // track
  static const int kCATrackSize = 3;
  static const int kTotalTrackSize = KT::kCATrackSize + 1;
  static const int kUserTrackIndex;
  
  // coordination
  static const int kMinSoundDuration;
  static const int kMaxSoundDuration;
  static const int kMinDeployDuration;
  static const int kMaxDeployDuration;
  static const int kSweepSoundDuration;
  static const int kSweepGraphicsDuration;

  // player
  struct PlayerEventArgs {
    int track_idx;
    ns_composition::BaseCellularAutomata* ca;
    TimeDiff timestamp;
    int duration;
    int note_degree;
  };

private:
  
  KT();
  KT(const KT&);
  KT& operator=(const KT&);
  
};


}  // namespace cellophane
