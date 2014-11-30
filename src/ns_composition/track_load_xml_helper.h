//
//  track_load_xml_helper.h
//

#pragma once

#include "CARunner.h"
#include "Sound.h"
#include "Graphics.h"


namespace cellophane {
  
namespace ns_composition {
    

// aliases
using Sound = cellophane::ns_sound::Sound;
using SynthIndexManager = cellophane::ns_sound::SynthIndexManager;
using Graphics = cellophane::ns_graphics::Graphics;
using Shape = cellophane::ns_shape::Shape;
using ShapeIndexManager = cellophane::ns_graphics::ShapeIndexManager;
using Form = cellophane::ns_composition::Grid::Form;

  
// load from xml
int loadScaleIndex(const std::string& xpath, ofXml& xml, int palette_idx);
void registerGrid(int track_idx, Graphics* graphics, Grid* grid);
const std::deque<Form> loadForms(const std::string& xpath, ofXml& xml);
Graphics* loadGraphics(int track_idx, const std::string& xpath, ofXml& xml);
ShapeIndexManager* loadShapeIndexManager(const std::string& xpath, ofXml& xml);
CARunner* loadCARunner(const std::string& xpath, ofXml& xml, int track_idx,
                       int palette_idx, int scale_idx, bool filling);
BaseCA* loadCA(const std::string& xpath, ofXml& xml, int track_idx);
const CARunner::Pace loadPace(const std::string& xpath, ofXml& xml,
                              int track_idx, int palette_idx, bool filling);
bool loadFilling(const std::string& xpath, ofXml& xml);
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
