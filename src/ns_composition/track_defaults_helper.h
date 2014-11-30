//
//  track_defaults_helper.h
//

#pragma once

#include "CARunner.h"


namespace cellophane {
  
namespace ns_composition {


CARunner* getDefaultCARunner(int track_idx, int palette_idx, int scale_idx,
                             bool filling);
BaseCA* getDefaultCA(int track_idx);
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
