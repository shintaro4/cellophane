//
//  helper.h
//

#pragma once

#include "ofMain.h"
#include "KG.h"
#include "KU.h"


namespace cellophane {
  

ofColor getPaletteColor(int palette_idx, int track_idx);
  
TimeDiff toTimeDiff(const std::string& s);
KG::ShapeTypes toShapeTypes(int n);
KU::Modes toModes(int n);

bool toBool(int value);
bool toBool(KU::Modes mode);
int toInt(unsigned char n);
int toInt(KG::ShapeTypes type);
int toInt(KU::Modes mode);

template <typename T>
std::vector<T> toVector(int size, const T array[]) {
  std::vector<T> v;
  v.resize(size);
  for (int i = 0; i < v.size(); ++i) v[i] = array[i];

  return v;
}
  
  
}  // namespace cellophane