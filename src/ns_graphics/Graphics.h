//
//  Graphics.h
//

#pragma once

#include "BaseGraphics.h"
#include "Grid.h"
#include "ShapeIndexManager.h"


namespace cellophane {
  
namespace ns_graphics {

  
// aliases
using Shape = cellophane::ns_shape::Shape;
using ShapeArgs = cellophane::ns_shape::ShapeArgs;
  
  
class Graphics : public BaseGraphics<ns_shape::Shape> {
  
public:

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  explicit Graphics(int track_idx);
  Graphics(int track_idx, const std::vector<ns_shape::Shape*>& shapes,
           ShapeIndexManager* shape_index_manager);
  ~Graphics();
  
  void update(const TimeDiff current_time, Grid* grid);
  void clear();
  
  void setupShape(const TimeDiff timestamp, int duration,
                  const ShapeArgs& args, Grid* grid);

  bool getShapeState(int idx) const;
  ShapeIndexManager* getShapeIndexManager();

  void setHoldingShapeIndex(int shape_idx);
  void resetHoldingShapeIndex();
  
  void rotateShapes(int duration, bool filling, Grid* grid);
  void rotateShape(int idx, int duration, bool filling, Grid* grid);
  void moveShape(int idx, int duration, const ofPoint& grid_point, Grid* grid);

  void handleChangeColorEvent(const ofColor& color);

  void clearShape(int idx, const TimeDiff timestamp, int duration, Grid* grid);
  
private:

  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------

  static const int kUndeployDuration;
  static const int kClearDuration;
  
  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Graphics(const Graphics&);
  Graphics& operator=(const Graphics&);

  void deployShape(int idx, const TimeDiff timestamp, int duration,
                   const ShapeArgs& args);
  void undeployShape(int idx, const TimeDiff timestamp, Grid* grid);
  void undeployShape(int idx, const TimeDiff timestamp, int duration,
                     Grid* grid);
  void removeShape(int idx, Grid* grid);
  void resetShape(int idx);
  
  void handleCallback(int idx, const TimeDiff current_time, Grid* grid);
  void handleDeployCallback(int idx, Grid* grid);
  void handleUndeployCallback(int idx);
  void handleMovedCallback(int idx, Grid* grid);
  
  void initShapes();
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::vector<KG::CallbackTypes> callback_types_;
  ShapeIndexManager* shape_index_manager_;
  
};


}  // namespace ns_graphics
  
}  // namespace cellophane
