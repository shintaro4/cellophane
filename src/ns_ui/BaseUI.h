//
//  BaseUI.h
//


#pragma once

#include "ofMain.h"
#include "KU.h"
#include "KG.h"


namespace cellophane {
  
namespace ns_ui {
  
  
class BaseUI {

public:

  //--------------------------------------------------------------
  // events
  //--------------------------------------------------------------
  
  ofEvent<KU::UIEventArgs> uiEvent;

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  virtual ~BaseUI();

  virtual void update(const TimeDiff current_time) {};
  virtual void draw() = 0;
  virtual void touchDown(const ofTouchEventArgs& touch) {};
  virtual void touchUp(const ofTouchEventArgs& touch) {};
  virtual void setLayerAlpha(float layer_alpha);
  virtual bool inside(const ofTouchEventArgs& touch) const = 0;
  
  KU::Options getOption() const;
  
protected:
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------

  explicit BaseUI(KU::Options option);
  BaseUI(KU::Options option, int member_id);
  
  //--------------------------------------------------------------
  // protected members
  //--------------------------------------------------------------

  KU::Options option_;
  int member_id_;
  float layer_alpha_;
  
private:
  
  BaseUI(const BaseUI&);
  BaseUI& operator=(const BaseUI&);
  
};


}  // namespace ns_ui
  
}  // namespace cellophane
