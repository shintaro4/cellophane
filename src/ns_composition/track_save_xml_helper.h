//
//  track_save_xml_helper.h
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

  
// saving to xml
const std::string graphicsToXmlString(Graphics* graphics);
const std::string shapesToXmlString(const std::vector<Shape*> shapes);
const std::string shapeIndexManagerToXmlString(ShapeIndexManager*
                                               shape_index_manager);
const std::string CARunnerToXmlString(CARunner* ca_runner,
                                      const TimeDiff trigger_time);
const std::string caToXmlString(BaseCA* ca);
const std::string paceToXmlString(const CARunner::Pace& pace);

  
}  // namespace ns_composition
  
}  // namespace cellophane
