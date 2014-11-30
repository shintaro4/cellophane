//
//  Shape.mm
//

#include "Shape.h"
#include "helper.h"
#include "shape_helper.h"


namespace cellophane {
  
namespace ns_shape {


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Shape::Shape() {
  initCallbackTimer();
}

Shape::Shape(bool state, const ShapeArgs& args, float layer_alpha)
    : BaseShape(state, args, layer_alpha) {
  resetVertices();
  initCallbackTimer();
}

Shape::~Shape() {
  delete callback_timer_;
}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Shape::reset() {
  state_ = false;
  animation_->stopTransitions();
  callback_timer_->reset();
}

bool Shape::inside(const ofTouchEventArgs &touch) const {
  if (!state_) return false;
  
  if (type_ == KG::kCircleShape) {
    return recognizeByDistance(touch);
  } else {
    return recognizeByCross2D(touch);
  }
}

void Shape::adjustTime(const TimeDiff timestamp, int duration) {
  animation_->adjustTransitions(timestamp, duration);
  callback_timer_->adjustTime(timestamp, duration);
}

bool Shape::isCenter(const ofPoint& center) const {
  if (!state_ || callback_timer_->getState(KG::kMovedCallback)) return false;

  return (center_ == center);
}
  
void Shape::set(const ShapeArgs& args) {
  reset();
  type_ = args.type;
  center_ = args.center;
  color_ = args.color;
  size_ = args.size;
  width_ = 0.0f;
  height_ = 0.0f;
  angle_ = args.angle;
  filling_ = args.filling;
  resetVertices();
}

void Shape::resetVertices() {
  std::vector<ofPoint> vertices = collectVertices();
  vertices_.swap(vertices);
}

//--------------------------------------------------------------
// callback timer methods
//--------------------------------------------------------------
bool Shape::triggerCallback(KG::CallbackTypes type,
                            const TimeDiff current_time) const {
  return callback_timer_->trigger(type, current_time);
}
  
bool Shape::getCallbackState(KG::CallbackTypes type) const {
  return callback_timer_->getState(type);
}

void Shape::setCallbackState(KG::CallbackTypes type, bool trigger) {
  callback_timer_->setState(type, trigger);
}
  
void Shape::setCallback(KG::CallbackTypes type, const TimeDiff timestamp) {
  callback_timer_->setCallbackTimer(type, timestamp);
}

bool Shape::isCallbackScheduling() const {
  return callback_timer_->isScheduling();
}
  
//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
std::vector<ofPoint> Shape::collectVertices() const {
  float angle = angle_;
  std::vector<ofPoint> vertices;
  for (int i = 0, number_of_vertices = getNumberOfVertices(type_);
       i < number_of_vertices; ++i) {
    ofVec3f vec = getVertexVector(type_, angle, size_, i);
    ofPoint point(center_ + vec);
    vertices.push_back(point);
  }
  return vertices;
}
  
//--------------------------------------------------------------
// touch recognizers
//--------------------------------------------------------------
bool Shape::recognizeByCross2D(const ofTouchEventArgs& touch) const {
  std::vector<ofPoint> vertices = collectVertices();
  ofPoint point(touch.x, touch.y);
  for (int i = 0; i < vertices.size(); ++i) {
    int j = (i == 0) ? vertices.size() - 1 : i - 1;
    ofVec3f a(point - vertices[j]);
    ofVec3f b(vertices[i] - vertices[j]);
    float cross_product_2d = a.x * b.y - a.y * b.x;
    
    // Note: In openFrameworks, The "origin" of the coordinate system is in the
    // upper left. So, a x b > 0 indicates the point is outside of the triangle.
    if (cross_product_2d > 0.0f) return false;
  }
  return true;
}
  
bool Shape::recognizeByDistance(const ofTouchEventArgs& touch) const {
  float radius = (width_ < height_) ? width_ * 0.5f : height_ * 0.5f;
  float dist = center_.squareDistance(ofPoint(touch.x, touch.y));
  return (dist < radius * radius);
}

//--------------------------------------------------------------
// initialize methods
//--------------------------------------------------------------
void Shape::initCallbackTimer() {
  callback_timer_ = new CallbackTimer(toVector(KG::kCallbackTypeSize,
                                               KG::kCallbackTypeList));
}
  
  
}  // namespace ns_shape

}  // namespace cellophane
