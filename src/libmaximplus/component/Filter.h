//
//  Filter.h
//

#pragma once


namespace lib_maximplus {


class Filter {
  
public:

  //--------------------------------------------------------------
  // types
  //--------------------------------------------------------------

  enum Types {
    kLowPass, kHighPass
  };

  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------

  Filter();
  
  float apply(float input);
  float apply(float input, float cutoff);

  Types getType() const;
  void  setType(Types type);
  float getCutoff() const;
  void  setCutoff(float cutoff);
  
private:

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------

  float lowPass(float input, float cutoff);
  float highPass(float input, float cutoff);
  
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------

  Types type_;
  float cutoff_;
  float buffer_;
  
};

  
}  // namespace lib_maximplus
