//
//  BaseShape.mm
//

#include "BaseShape.h"
#include "shape_helper.h"
#include "graphics_helper.h"


namespace cellophane {
  
namespace ns_shape {

  
//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
BaseShape::BaseShape() : state_(false), type_(KG::kSquareShape),
      center_(ofPoint()), color_(ofColor()), size_(0.0f), width_(0.0f),
      height_(0.0f), angle_(0.0f), filling_(true),
      layer_alpha_(1.0f), animation_(new Animation(KG::kParamSize)) {}

BaseShape::BaseShape(bool state, const ShapeArgs& args, float layer_alpha)
    : state_(state), type_(args.type), center_(args.center), color_(args.color),
      size_(args.size), width_(args.width), height_(args.height),
      angle_(args.angle), filling_(args.filling),
      layer_alpha_(layer_alpha),
      animation_(new Animation(KG::kParamSize)) {}

BaseShape::~BaseShape() {
  delete animation_;
}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void BaseShape::update(const TimeDiff current_time) {
  const std::vector<Motion> motions = animation_->update(current_time);
  updateParams(motions);
}

void BaseShape::draw() {
  ofPushStyle();
  ofPushMatrix();

  ofTranslate(center_);
  ofRotateZ(angle_);
  
  if (filling_) {
    ofFill();
  } else {
    ofNoFill();
  }
  ofSetLineWidth(KG::kShapeLineWidth);
  ofSetColor(color_, color_.a * layer_alpha_);
  
  ns_shape::draw(type_, width_, height_);
  
  ofPopMatrix();
  ofPopStyle();
}

void BaseShape::reset() {
  state_ = false;
  animation_->stopTransitions();
}

void BaseShape::set(const ShapeArgs& args) {
  reset();
  type_ = args.type;
  center_ = args.center;
  color_ = args.color;
  size_ = args.size;
  width_ = args.width;
  height_ = args.height;
  angle_ = args.angle;
  filling_ = args.filling;
}

void BaseShape::adjustTime(const TimeDiff timestamp, int duration) {
  animation_->adjustTransitions(timestamp, duration);
}

//--------------------------------------------------------------
// gettter/setter
//--------------------------------------------------------------
bool BaseShape::getState() const {
  return state_;
}

void BaseShape::setState(bool state) {
  state_ = state;
}

KG::ShapeTypes BaseShape::getType() const {
  return type_;
}

void BaseShape::setType(KG::ShapeTypes type) {
    type_ = type;
}

const ofPoint& BaseShape::getCenter() const {
  return center_;
}

void BaseShape::setCenter(const ofPoint& center) {
  center_ = center;
}
  
const ofColor& BaseShape::getColor() const {
  return color_;
}
  
void BaseShape::setColor(const ofColor& color) {
  color_ = color;
}
  
void BaseShape::invertColor() {
  color_.invert();
}
  
float BaseShape::getSize() const {
  return size_;
}

bool BaseShape::getFilling() const {
  return filling_;
}
  
void BaseShape::setFilling(bool filling) {
  filling_ = filling;
}

float BaseShape::getLayerAlpha() const {
  return layer_alpha_;
}
  
void BaseShape::setLayerAlpha(float layer_alpha) {
  layer_alpha_ = layer_alpha;
}

float BaseShape::getCurrentValue(KG::Params param) const {
  float value = 0.0f;
  if (param == KG::kXParam) {
    value = center_.x;
  } else if (param == KG::kYParam) {
    value = center_.y;
  } else if (param == KG::kWidthParam) {
    value = width_;
  } else if (param == KG::kHeightParam) {
    value = height_;
  } else if (param == KG::kAngleParam) {
    value = angle_;
  } else if (param == KG::kAlphaParam) {
    value = color_.a;
  } else if (param == KG::kHueParam) {
    value = color_.getHue();
  } else if (param == KG::kSaturationParam) {
    value = color_.getSaturation();
  } else if (param == KG::kBrightnessParam) {
    value = color_.getBrightness();
  }
  return value;
}

float BaseShape::getEndValue(KG::Params param) const {
  if (animation_->getTransitionTrigger(param)) {
    return animation_->getTransitionEnd(param);
  } else {
    return getCurrentValue(param);
  }
}

void BaseShape::setTransition(KG::Params param, Transition trans) {
  animation_->setTransition(param, trans);
}

const Form BaseShape::getForm(int track_idx, int shape_idx) const {
  Form form = {
    .track_idx = track_idx, .shape_idx = shape_idx,
    .grid_point = ns_graphics::convertToGridPoint(center_),
    .size = size_, .angle = angle_, .assigned = false
  };
  return form;
}
  
//--------------------------------------------------------------
// animation methods
//--------------------------------------------------------------
void BaseShape::updateParams(const std::vector<Motion>& motions) {
  for (int i = 0; i < motions.size(); ++i) {
    if (motions[i].changed) updateParam(static_cast<KG::Params>(i),
                                        motions[i].value);
  }
}

void BaseShape::updateParam(KG::Params param, float value) {
  if (param == KG::kXParam) {
    center_.x = value;
  } else if (param == KG::kYParam) {
    center_.y = value;
  } else if (param == KG::kWidthParam) {
    width_ = value;
  } else if (param == KG::kHeightParam) {
    height_ = value;
  } else if (param == KG::kAngleParam) {
    angle_ = value;
  } else if (param == KG::kAlphaParam) {
    color_.a = value;
  } else if (param == KG::kHueParam) {
    color_.setHue(value);
  } else if (param == KG::kSaturationParam) {
    color_.setSaturation(value);
  } else if (param == KG::kBrightnessParam) {
    color_.setBrightness(value);
  }
}

  
}  // namespace ns_shape

}  // namespace cellophane
