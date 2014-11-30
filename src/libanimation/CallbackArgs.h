//
//  CallbackArgs.h
//

#pragma once

#include "ofMain.h"


namespace lib_animation {
  
  
template <class T>
class CallbackArgs {
  
public:
  
  //--------------------------------------------------------------
  // interface
  //--------------------------------------------------------------
  
  CallbackArgs() {};
  
  std::pair<int, T> pop(int idx);
  void push(int idx, T arg);
  void clear();
  
private:
  
  CallbackArgs(const CallbackArgs&);
  CallbackArgs& operator=(const CallbackArgs&);

  //--------------------------------------------------------------
  // methods
  //--------------------------------------------------------------
  
  typename std::deque<std::pair<int, T> >::iterator find(int idx);
  void print();
  //--------------------------------------------------------------
  // members
  //--------------------------------------------------------------
  
  std::deque<std::pair<int, T> > args_;
  ofMutex mutex_;
  
};
  
  
//--------------------------------------------------------------
// public method implementations
//--------------------------------------------------------------
template <class T>
std::pair<int, T> CallbackArgs<T>::pop(int idx) {
  int i = -1;
  T arg;
  
  mutex_.lock();
  typename std::deque<std::pair<int, T> >::iterator iter = find(idx);
  if (iter != args_.end()) {
    i = (*iter).first;
    arg = (*iter).second;
    args_.erase(iter);
  }
  
  mutex_.unlock();
  return std::make_pair(i, arg);
}

template <class T>
void CallbackArgs<T>::push(int idx, T arg) {
  mutex_.lock();

  typename std::deque<std::pair<int, T> >::iterator iter = find(idx);
  if (iter != args_.end()) {
    arg = (*iter).second;
    args_.erase(iter);
  }

  args_.push_back(std::make_pair(idx, arg));
  mutex_.unlock();
}
  
template <class T>
void CallbackArgs<T>::clear() {
  mutex_.lock();
  args_.clear();
  mutex_.unlock();
}

//--------------------------------------------------------------
// private method implementations
//--------------------------------------------------------------
template <class T>
typename std::deque<std::pair<int, T> >::iterator
CallbackArgs<T>::find(int idx) {
  typename std::deque<std::pair<int, T> >::iterator iter = args_.begin();
  while (iter != args_.end()) {
    if ((*iter).first == idx) return iter;
    ++iter;
  }
  return iter;
}

  
}  // namespace lib_animation