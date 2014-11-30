//
//  Environment.mm
//

#include "Environment.h"


namespace cellophane {

  
//--------------------------------------------------------------
// static methods
//--------------------------------------------------------------
Environment& Environment::getInstance() {
  static Environment instance;
  return instance;
}

//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Environment::Environment() : is_retina_(true), display_width_(640.0f),
      display_height_(1136.0f), lang_(kEnglish), grid_resolution_(48.0f),
      grid_margin_(24.0f), window_margin_(48.0f) {}

//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Environment::init(bool is_retina, float display_width,
                       float display_height, Languages lang) {
  is_retina_ = is_retina;
  display_width_ = display_width;
  display_height_ = display_height;
  lang_ = lang;
  
  if (!is_retina_) {
    grid_resolution_ *= 0.5f;
    grid_margin_ = grid_resolution_ * 0.5f;
    window_margin_ *= 0.5f;
  }

  initShapeSizes();
}

bool Environment::isRetina() const {
  return is_retina_;
}
  
float Environment::getGridResolution() const {
  return grid_resolution_;
}

float Environment::getGridMargin() const {
  return grid_margin_;
}

int Environment::getHorizontalGridSize() const {
  return (display_width_ - grid_margin_) / grid_resolution_ + 1;
}

int Environment::getVerticalGridSize() const {
  return (display_height_ - grid_margin_) / grid_resolution_ + 1;
}
  
float Environment::getWindowMargin() const {
  return window_margin_;
}

float Environment::getShapeSize(int idx) const {
  if (idx < 0) idx = 0;
  if (idx >= shape_sizes_.size()) idx = shape_sizes_.size() - 1;
  return shape_sizes_[idx];
}

int Environment::getShapeSizeIndex(float size) const {
  for (int i = 0; i < shape_sizes_.size(); ++i) {
    if (size == shape_sizes_[i]) return i;
  }
  return -1;
}
  
int Environment::findGridPosition(float value) const {
  const float positionf = (value - grid_margin_) / grid_resolution_;
  const int position = static_cast<int>(positionf);
  return (positionf - position >= 0.5f) ? position + 1 : position;
}
  
float Environment::convertToGridValue(float value) const {
  const int position = findGridPosition(value);
  return position * grid_resolution_ + grid_margin_;
}

void Environment::showEnvironment() {
ofLog(OF_LOG_NOTICE) << "{is_retina:" << is_retina_ <<
  ", display_width:" << display_width_ <<
  ", display_height:" << display_height_ <<
  ", lang:" << lang_ << "}";
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
void Environment::initShapeSizes() {
  shape_sizes_.resize(kNumberOfShapeSize);
  float shape_size = grid_resolution_;
  for (int i = 0; i < kNumberOfShapeSize; ++i) {
    shape_sizes_[i] = shape_size;
    shape_size *= 2;
  }
}
  
  
}  // namespace cellophane
