//
//  track_load_xml_helper.mm
//

#include "track_load_xml_helper.h"
#include "track_defaults_helper.h"
#include "helper.h"
#include "UserCA.h"
#include "PlayerCA.h"
#include "KD.h"
#include "map_helper.h"


namespace cellophane {
  
namespace ns_composition {
    
    
// aliases
using IndexLog = ns_graphics::IndexLog;


int loadScaleIndex(const std::string& xpath, ofXml& xml, int palette_idx) {
  xml.reset();
  if (!xml.exists(xpath)) {
    return ns_composition::paletteToScaleIndex(palette_idx);
  }
  return xml.getIntValue(xpath + "/idx");
}
  
void registerGrid(int track_idx, Graphics* graphics, Grid* grid) {
  // add joint points to the frame
  const std::vector<Shape*> shapes = graphics->getShapes();
  for (int i = 0; i < shapes.size(); ++i) {
    if (shapes[i]->getState()) {
      grid->addForm(shapes[i]->getForm(track_idx, i));
    }
  }
}

const std::deque<Form> loadForms(const std::string& xpath, ofXml& xml) {
  std::deque<Form> forms;
  xml.reset();
  if (!xml.exists(xpath)) return forms;
  xml.setTo(xpath);

  for (int i = 0, len = xml.getNumChildren(); i < len; ++i) {
    const std::string path = "form[" + ofToString(i) + "]";
    const int track_idx = xml.getIntValue(path + "/track_idx");
    const int shape_idx = xml.getIntValue(path + "/shape_idx");
    Form form = {
      .track_idx = track_idx, .shape_idx = shape_idx, .assigned = true
    };
    forms.push_back(form);
  }
  
  return forms;
}
  
Graphics* loadGraphics(int track_idx, const std::string& xpath, ofXml& xml) {
  xml.reset();
  if (!xml.exists(xpath)) return new Graphics(track_idx);
  
  // shapes
  const std::string shapes_path = xpath + "/shapes";
  if (!xml.exists(shapes_path)) return new Graphics(track_idx);
  xml.setTo(shapes_path);

  std::vector<Shape*> shapes;
  for (int i = 0, len = xml.getNumChildren(); i < len; ++i) {
    const std::string path = "shape[" + ofToString(i) + "]";
    
    // state
    bool state = toBool(xml.getIntValue(path + "/state"));
    
    // shape args
    const ns_shape::ShapeArgs args = {
      .type = toShapeTypes(xml.getIntValue(path + "/type")),
      .center = ofPoint(xml.getFloatValue(path + "/center_x"),
                        xml.getFloatValue(path + "/center_y")),
      .color = ofColor(xml.getIntValue(path + "/color_r"),
                       xml.getIntValue(path + "/color_g"),
                       xml.getIntValue(path + "/color_b"),
                       xml.getIntValue(path + "/color_a")),
      .size = xml.getFloatValue(path + "/size"),
      .width = xml.getFloatValue(path + "/width"),
      .height = xml.getFloatValue(path + "/height"),
      .angle = xml.getFloatValue(path + "/angle"),
      .filling = toBool(xml.getIntValue(path + "/filling"))
    };

    // layer alpha
    const float layer_alpha = xml.getFloatValue(path + "/layer_alpha");

    Shape* shape(new Shape(state, args, layer_alpha));

    shapes.push_back(shape);
  }
 
  // shape index manager
  const std::string shape_index_manager_path = xpath + "/shape_index_manager";

  return new Graphics(track_idx, shapes,
                      loadShapeIndexManager(shape_index_manager_path, xml));
}

ShapeIndexManager* loadShapeIndexManager(const std::string& xpath, ofXml& xml) {
  xml.reset();
  if (!xml.exists(xpath)) new ShapeIndexManager();
  
  // indices
  const std::string indices_path = xpath + "/indices";
  if (!xml.exists(indices_path)) return new ShapeIndexManager();
  xml.setTo(indices_path);
  std::deque<int> indices;
  for (int i = 0, len = xml.getNumChildren(); i < len; ++i) {
    const std::string path = "index[" + ofToString(i) + "]";
    indices.push_back(xml.getIntValue(path));
  }
  
  // logs
  const std::string logs_path = xpath + "/logs";
  xml.reset();
  if (!xml.exists(xpath)) return new ShapeIndexManager();
  xml.setTo(logs_path);
  std::vector<TimeDiff> timestamps;
  for (int i = 0, len = xml.getNumChildren(); i < len; ++i) {
    const std::string timestamp_path = "timestamp[" + ofToString(i) + "]";
    timestamps.push_back(toTimeDiff(xml.getValue(timestamp_path)));
  }
  // index log
  IndexLog* index_log(new IndexLog(timestamps));
  
  return new ShapeIndexManager(indices, index_log);
}
  
CARunner* loadCARunner(const std::string& xpath, ofXml& xml, int track_idx,
                       int palette_idx, int scale_idx, bool filling) {
  xml.reset();
  if (!xml.exists(xpath)) {
    return getDefaultCARunner(track_idx, palette_idx, scale_idx, filling);
  }
 
  // trigger time
  TimeDiff trigger_time = toTimeDiff(xml.getValue(xpath + "/trigger_time"));
  
  // ca
  BaseCA* ca = loadCA(xpath + "/ca", xml, track_idx);

  // pace
  const CARunner::Pace pace = loadPace(xpath + "/scope", xml,
                                       track_idx, palette_idx, filling);

  return new CARunner(track_idx, trigger_time, ca, scale_idx, pace);
}

BaseCA* loadCA(const std::string& xpath, ofXml& xml, int track_idx) {
  xml.reset();
  if (!xml.exists(xpath)) return getDefaultCA(track_idx);

  // rule number
  const int rule_number = xml.getIntValue(xpath + "/rule_number");
  
  // cell sequence number
  const int cell_sequence_number =
      xml.getIntValue(xpath + "/cell_sequence_number");

  if (track_idx == KT::kUserTrackIndex) {
    return new UserCA(rule_number, cell_sequence_number);
  } else {
    return new PlayerCA(rule_number, cell_sequence_number);
  }
}

const CARunner::Pace loadPace(const std::string& xpath, ofXml& xml,
                              int track_idx, int palette_idx, bool filling) {
  xml.reset();
  if (!xml.exists(xpath)) {
    return ns_composition::createPace(track_idx, palette_idx, filling);
  }

  return {
    .steps_idx = xml.getIntValue(xpath + "/steps_idx"),
    .holding_steps_idx = xml.getIntValue(xpath + "/holding_steps_idx"),
    .steps_holding = !filling
  };
}

bool loadFilling(const std::string& xpath, ofXml& xml) {
  xml.reset();
  return (!xml.exists(xpath)) ? KD::kDefaultTrackFilling
      : toBool(xml.getIntValue(xpath));
}
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
