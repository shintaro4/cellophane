//
//  track_save_xml_helper.mm
//

#include "track_save_xml_helper.h"
#include "helper.h"


namespace cellophane {
  
namespace ns_composition {
  

// aliases
using IndexLog = ns_graphics::IndexLog;


const std::string graphicsToXmlString(Graphics* graphics) {
  std::string s;
  s += shapesToXmlString(graphics->getShapes());
  s += shapeIndexManagerToXmlString(graphics->getShapeIndexManager());
  return "<graphics>" + s + "</graphics>";
}

const std::string shapesToXmlString(const std::vector<Shape*> shapes) {
  std::string s;
  for (int i = 0; i < KG::kTrackShapeSize; ++i) {
    s += "<shape>";

    const bool state =
        (shapes[i]->getCallbackState(KG::kUndeployCallback)) ? false
        : shapes[i]->getState();
    s += "<state>" + ofToString(state) + "</state>";

    s += "<type>" + ofToString(toInt(shapes[i]->getType())) + "</type>";
    
    const float x = shapes[i]->getEndValue(KG::kXParam);
    s += "<center_x>" + ofToString(x) + "</center_x>";
    const float y = shapes[i]->getEndValue(KG::kYParam);
    s += "<center_y>" + ofToString(y) + "</center_y>";

    const ofColor color = shapes[i]->getColor();
    s += "<color_r>" + ofToString(toInt(color.r)) + "</color_r>";
    s += "<color_g>" + ofToString(toInt(color.g)) + "</color_g>";
    s += "<color_b>" + ofToString(toInt(color.b)) + "</color_b>";
    s += "<color_a>" + ofToString(toInt(color.a)) + "</color_a>";
    
    const float size = shapes[i]->getSize();
    s += "<size>" + ofToString(size) + "</size>";
    const float width = shapes[i]->getEndValue(KG::kWidthParam);
    s += "<width>" + ofToString(width) + "</width>";
    const float height = shapes[i]->getEndValue(KG::kHeightParam);
    s += "<height>" + ofToString(height) + "</height>";
    const float angle = shapes[i]->getEndValue(KG::kAngleParam);
    s += "<angle>" + ofToString(angle) + "</angle>";
    
    s += "<filling>" + ofToString(shapes[i]->getFilling()) +
        "</filling>";
    s += "<layer_alpha>" + ofToString(shapes[i]->getLayerAlpha()) +
        "</layer_alpha>";
    
    s += "</shape>";
  }

  return "<shapes>" + s + "</shapes>";
}
  
const std::string shapeIndexManagerToXmlString(ShapeIndexManager*
                                               shape_index_manager) {
  std::string s;
  
  // indices
  s += "<indices>";
  const std::deque<int> indices = shape_index_manager->getIndices();
  for (std::deque<int>::const_iterator iter = indices.begin();
       iter != indices.end(); ++iter) {
    s += "<index>" + ofToString(*iter) + "</index>";
  }
  s += "</indices>";
  
  // logs
  s += "<logs>";
  const std::vector<TimeDiff> timestamps =
      shape_index_manager->getReducedTimestamps();
  for (int i = 0; i < timestamps.size(); ++i) {
    s += "<timestamp>" + ofToString(timestamps[i]) + "</timestamp>";
  }
  s += "</logs>";
  
  return "<shape_index_manager>" + s + "</shape_index_manager>";
}
  
const std::string CARunnerToXmlString(CARunner* ca_runner,
                                      const TimeDiff trigger_time) {
  std::string s;

  // trigger time
  s += "<trigger_time>" + ofToString(trigger_time) + "</trigger_time>";

  // ca
  s += caToXmlString(ca_runner->getCA());

  // pace
  s += paceToXmlString(ca_runner->getPace());
  
  return "<ca_runner>" + s + "</ca_runner>";
}
  
const std::string caToXmlString(BaseCA* ca) {
  std::string s;

  // rule number
  s += "<rule_number>" + ofToString(ca->getRuleNumber()) +
      "</rule_number>";
  
  // cell sequence number
  s += "<cell_sequence_number>" + ofToString(ca->getCellSequenceNumber()) +
      "</cell_sequence_number>";

  return "<ca>" + s + "</ca>";
}

const std::string paceToXmlString(const CARunner::Pace& pace) {
  std::string s;
  
  // steps index
  s += "<steps_idx>" + ofToString(pace.steps_idx) + "</steps_idx>";
  
  // holding steps index
  s += "<holding_steps_idx>" + ofToString(pace.holding_steps_idx) +
      "</holding_steps_idx>";

  return "<scope>" + s + "</scope>";
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
