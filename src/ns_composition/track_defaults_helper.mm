//
//  track_defaults_helper.mm
//

#include "track_defaults_helper.h"
#include "helper.h"
#include "KU.h"
#include "UserCA.h"
#include "PlayerCA.h"
#include "KC.h"
#include "KM.h"
#include "KD.h"
#include "map_helper.h"


namespace cellophane {
  
namespace ns_composition {


CARunner* getDefaultCARunner(int track_idx, int palette_idx, int scale_idx,
                             bool filling) {
  return new CARunner(track_idx,
                      KD::kDefaultCARunnerTriggerTime,
                      getDefaultCA(track_idx),
                      scale_idx,
                      ns_composition::createPace(track_idx, palette_idx,
                                                 filling));
}

BaseCA* getDefaultCA(int track_idx) {
  const int default_rule_numbers[] = {101, 45, 75, 89};
  const int idx = (track_idx >= 0 && track_idx < 4) ? track_idx
      : KT::kUserTrackIndex;
  
  if (idx == KT::kUserTrackIndex) {
    return new UserCA(default_rule_numbers[idx]);
  } else {
    return new PlayerCA(default_rule_numbers[idx]);
  }
}
  
    
}  // namespace ns_composition
  
}  // namespace cellophane
