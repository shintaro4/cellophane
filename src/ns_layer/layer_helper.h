//
//  layer_helper.h
//

#pragma once

#include "Environment.h"
#include "KU.h"


namespace cellophane {

namespace ns_layer {

  
// aliases
using Env = cellophane::Environment;


float getSize(float size);
const std::string getImagePath(const std::string& file_path);
  
  
}  // namespace ns_layer
  
}  // namespace cellophane