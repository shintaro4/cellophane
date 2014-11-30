//
//  BaseCellularAutomata.h
//

#pragma once

#include "ofMain.h"


namespace cellophane {
  
namespace ns_composition {
    
    
class BaseCellularAutomata {
      
public:
      
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kCellSequenceSize;
  static const int kMaxCellSequenceNumber;  // = 2^kCellSequenceSize - 1
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  virtual ~BaseCellularAutomata() {};
  
  virtual void update() = 0;

  void reverse();
  void shuffle();
  void rotate(int degree);
  void invert();
  
  virtual int getLiveCellIndex();
  virtual int getLiveCellIndexInRange(int range);
  virtual float getLiveRatio();
  virtual float getLiveRatioInRange(int range);
  virtual float getLiveRatioWithRandomRange();
  
  int getRuleNumber();
  void setRuleByNumber(int rule_number);
  int getCellSequenceNumber();
  void setCellSequenceByNumber(int mask_sequence_number);
  
  int getRepeatTimes() const;
  
protected:
  
  //--------------------------------------------------------------
  // constants
  //--------------------------------------------------------------
  
  static const int kRuleSequenceSize;
  static const int kMaxRuleNumber;          // = 2^kRuleSequenceSize - 1
  static const int kDefaultCellSequenceNumber;
  static const int kMaxCellSequenceRepeatTimes;
  
  //--------------------------------------------------------------
  // protected methods
  //--------------------------------------------------------------

  explicit BaseCellularAutomata(int rule_number);
  BaseCellularAutomata(int rule_number, int cell_sequence_number);

  void resetRuleSequence(int ignore_number);
  void resetCellSequence(int ignore_number);
  
  void initRuleSequence(int rule_number);
  void initCellSequence(int cell_sequence_number);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  std::deque<bool> rule_sequence_;
  std::deque<bool> cell_sequence_;
  
  int repeat_times_;
  
  ofMutex mutex_;
  
private:
  
  BaseCellularAutomata(const BaseCellularAutomata&);
  BaseCellularAutomata& operator=(const BaseCellularAutomata&);

};
  
  
}  // namespace ns_composition
  
}  // namespace cellophane
