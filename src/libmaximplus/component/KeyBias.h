//
//  KeyBias.h
//

#pragma once


namespace lib_maximplus {
  

class KeyBias {
  
public:
  
  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------
  enum Types {
    kUpperBias, kLowerBias, kUpperAndLowerBias, kAllBias
  };
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  KeyBias();
  
  float getBias() const;
  void setBias(int note_number);
  
  int getBiasPoint() const;
  void setBiasPoint(int bias_point);
  float getBiasLevel() const;
  void setBiasLevel(float bias_level);
  Types getBiasType() const;
  void setBiasType(Types bias_type);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  float calculateBias(int note_number) const;
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  float bias_;
  int bias_point_;
  float bias_level_;
  Types bias_type_;
  
};


}  // namespace lib_maximplus
