//
//  Grid.mm
//

#include "Grid.h"
#include "graphics_helper.h"


namespace cellophane {
  
namespace ns_graphics {
  
  
// aliases
using Env = Environment;


//--------------------------------------------------------------
// constractor/destructor
//--------------------------------------------------------------
Grid::Grid() {}
  
//--------------------------------------------------------------
// public methods
//--------------------------------------------------------------
void Grid::addForm(const Form& form) {
  if (!isAcceptablePoint(form.grid_point)) return;

  mutex_.lock();
  std::deque<Form>::iterator iter = findForm(form.track_idx, form.shape_idx);
  if (iter == forms_.end()) forms_.push_back(form);
  mutex_.unlock();
}

void Grid::removeForm(int track_idx, int shape_idx) {
  mutex_.lock();
  std::deque<Form>::iterator iter = findForm(track_idx, shape_idx);
  if (iter != forms_.end()) forms_.erase(iter);
  mutex_.unlock();
}

bool Grid::isAcceptablePoint(const ofPoint& center) const {
  const ofPoint grid_point = ns_graphics::convertToGridPoint(center);
  float margin = Env::getInstance().getWindowMargin();

  return (grid_point.x > -margin && grid_point.x < ofGetWidth() + margin &&
          grid_point.y > -margin && grid_point.y < ofGetHeight() - margin);
}

const Grid::Assignment Grid::assign() {
  Assignment assignment;
  assignment.result = false;
  
  if (getShapeCenterSize() <= 0) return assignment;

  mutex_.lock();
  const int idx = findAssignableFormIndex();
                  
  std::vector<ofPoint> neighbors = collectNeighbors(idx);
  std::random_shuffle(neighbors.begin(), neighbors.end());
  for (int i = 0; i < neighbors.size(); ++i) {
    if (isAcceptablePoint(neighbors[i])) {
      assignment.result = true;
      assignment.center = neighbors[i];
      
      // update the form 
      forms_[idx].assigned = true;
      break;
    }
  }
  mutex_.unlock();

  return assignment;
}

int Grid::getShapeCenterSize() {
  mutex_.lock();
  int size = forms_.size();
  mutex_.unlock();
  
  return size;
}

void Grid::clear() {
  mutex_.lock();
  forms_.clear();
  mutex_.unlock();
}

//--------------------------------------------------------------
// setting xml methods
//--------------------------------------------------------------
void Grid::addToSettings(const std::string& xpath, Settings* settings) {
  mutex_.lock();
  const std::string s = formsToXmlString();
  mutex_.unlock();
  if (s.length() != 0) settings->addTo(xpath, s);
}

void Grid::mergeForms(const std::deque<Form>& forms) {
  mutex_.lock();
  for (int i = 0; i < forms.size(); ++i) {
    std::deque<Form>::iterator iter = findForm(forms[i].track_idx,
                                               forms[i].shape_idx);
    if (iter != forms_.end()) (*iter).assigned = true;
  }
  mutex_.unlock();
}
  
//--------------------------------------------------------------
// (for debug) drawing methods
//--------------------------------------------------------------
void Grid::drawAssignedCenters() {
  for (int i = 0; i < forms_.size(); ++i) {
    if (forms_[i].assigned) {
      ofSetColor(192, 0, 0);
      ofCircle(forms_[i].grid_point, 4.0f);
    }
  }
}
  
void Grid::drawNeighbors() {
  for (int i = 0; i < forms_.size(); ++i) {
    const std::vector<ofPoint> neighbors = collectNeighbors(i);
    for (int i = 0; i < neighbors.size(); ++i) {
      ofSetColor(0, 192, 0);
      ofCircle(neighbors[i], 4.0f);
    }
  }
}

void Grid::drawAllGridPoints() {
  float grid_res = Env::getInstance().getGridResolution();
  float start = -Env::getInstance().getGridMargin();
  
  ofPushMatrix();
  ofSetColor(0, 0, 192);
  for (float y = start; y < ofGetHeight(); y += grid_res) {
    for (float x = start; x < ofGetWidth(); x += grid_res) {
      ofCircle(x, y, 1.0f);
    }
  }
  ofPopMatrix();
}

//--------------------------------------------------------------
// private methods
//--------------------------------------------------------------
int Grid::findAssignableFormIndex() const {
  // find a form that is not assigned in user track
  for (int i = 0; i < forms_.size(); ++i) {
    if (forms_[i].track_idx == 0 && !forms_[i].assigned) return i;
  }
  // find a form that is not assigned
  for (int i = 0; i < forms_.size(); ++i) {
    if (!forms_[i].assigned) return i;
  }
  // find a form by random
  return static_cast<int>(ofRandom(forms_.size()));
}
  
std::deque<Grid::Form>::iterator Grid::findForm(int track_idx, int shape_idx) {
  std::deque<Form>::iterator iter = forms_.begin();
  while (iter != forms_.end()) {
    if ((*iter).track_idx == track_idx &&
        (*iter).shape_idx == shape_idx) break;
    ++iter;
  }
  
  return iter;
}

std::vector<ofPoint> Grid::collectNeighbors(int idx) const {
  Form form = forms_[idx];
  const int grid_size = ns_graphics::findGridSize(form.size);
  const ofPoint center = form.grid_point;
  if (static_cast<int>(form.angle) % 90 == 0) {
    return ns_graphics::collectCornerNeighbors(center, grid_size);
  } else {
    return ns_graphics::collectCrossNeighbors(center, grid_size);
  }
}
  
const std::string Grid::formsToXmlString() const {
  std::string s;

  for (int i = 0; i < forms_.size(); ++i) {
    if (forms_[i].assigned) {
      s += "<form>";
      s += "<track_idx>" + ofToString(forms_[i].track_idx) + "</track_idx>";
      s += "<shape_idx>" + ofToString(forms_[i].shape_idx) + "</shape_idx>";
      s += "</form>";
    }
  }

  return (s.length() == 0) ? "" : "<forms>" + s + "</forms>";
}
  
  
}  // namespace ns_graphics
  
}  // namespace cellophane
