//
//  Grid.h
//

#pragma once

#include "Environment.h"
#include "Settings.h"


namespace cellophane {
  
namespace ns_graphics {

  
class Grid {
  
public:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
  
  struct Form {
    int track_idx;
    int shape_idx;
    ofPoint grid_point;
    float size;
    float angle;
    bool assigned;
  };

  struct Assignment {
    bool result;
    ofPoint center;
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Grid();
  
  void addForm(const Form& form);
  void removeForm(int track_idx, int idx);
  bool isAcceptablePoint(const ofPoint& center) const;
  
  const Assignment assign();
  int getShapeCenterSize();
  void clear();

  // for setting xml methods
  void addToSettings(const std::string& xpath, Settings* settings);
  void mergeForms(const std::deque<Form>& forms);
  
  // (for debug) drawing methods
  void drawAssignedCenters();
  void drawNeighbors();
  void drawAllGridPoints();
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  Grid(const Grid&);
  Grid& operator=(const Grid&);

  int findAssignableFormIndex() const;
  std::deque<Form>::iterator findForm(int track_idx, int shape_idx);
  std::vector<ofPoint> collectNeighbors(int idx) const;

  const std::string formsToXmlString() const;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  std::deque<Form> forms_;
  ofMutex mutex_;
  
};


}  // namespace ns_graphics
  
}  // namespace cellophane
