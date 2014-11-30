//
//  Environment.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {

  
class Environment {

public:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kNumberOfShapeSize = 3;
  
  //--------------------------------------------------------------
  // type
  //--------------------------------------------------------------
  enum Languages {
    kEnglish, kJapanese
  };

  //--------------------------------------------------------------
  // inaterface
  //--------------------------------------------------------------

  static Environment& getInstance();
  
  void init(bool is_retina, float display_width, float display_height,
            Languages lang);
  
  bool isRetina() const;
  float getGridResolution() const;
  float getGridMargin() const;
  int getHorizontalGridSize() const;
  int getVerticalGridSize() const;
  float getWindowMargin() const;
  float getShapeSize(int idx) const;
  int getShapeSizeIndex(float size) const;
  
  int findGridPosition(float value) const;
  float convertToGridValue(float value) const;
  
  void showEnvironment();

private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Environment();
  Environment(const Environment&);
  
  void initShapeSizes();
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  bool is_retina_;
  float display_width_;
  float display_height_;
  Languages lang_;
  
  float grid_resolution_;
  float grid_margin_;
  float window_margin_;

  std::vector<float> shape_sizes_;
  
};

  
}  // namespace cellophane
