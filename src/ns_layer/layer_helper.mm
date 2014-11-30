//
//  layer_helper.mm
//

#include "layer_helper.h"


namespace cellophane {
  
namespace ns_layer {


float getSize(float size) {
  return (Env::getInstance().isRetina()) ? size * 2.0f : size;
}
  
const std::string getImagePath(const std::string& file_path) {
  return (Env::getInstance().isRetina()) ? file_path + "@2x.png"
      : file_path + "png";
}

  
}  // namespace ns_layer
  
}  // namespace cellophane