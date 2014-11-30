//
//  helper.mm
//

#include "helper.h"
#include "Poco/NumberParser.h"
#include "KC.h"


namespace cellophane {
  

ofColor getPaletteColor(int palette_idx, int track_idx) {
  if (palette_idx >= 0 && palette_idx < KC::kPaletteSize &&
      track_idx >= 0 && track_idx < KT::kTotalTrackSize) {
    const int palette_list_idx = KC::KPaletteMap[palette_idx];
    const int hex = KC::kPaletteList[palette_list_idx][track_idx];
    return ofColor::fromHex(hex);
  } else {
    return ofColor();
  }
}

TimeDiff toTimeDiff(const std::string& s) {
  return Poco::NumberParser::parse64(s);
}

KG::ShapeTypes toShapeTypes(int n) {
  return static_cast<KG::ShapeTypes>(n);
}
  
KU::Modes toModes(int n) {
  return static_cast<KU::Modes>(n);
}

bool toBool(int value) {
  return static_cast<bool>(value);
}
  
bool toBool(KU::Modes mode ) {
  return static_cast<bool>(toInt(mode));
}

int toInt(unsigned char n) {
  return static_cast<int>(n);
}
  
int toInt(KG::ShapeTypes type) {
  return static_cast<int>(type);
}
  
int toInt(KU::Modes mode) {
  return static_cast<int>(mode);
}
  

}  // namespace cellophane
