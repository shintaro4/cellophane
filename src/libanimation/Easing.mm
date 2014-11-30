//
//  Easing.mm
//

#include "Easing.h"

// EasingBack
float easing::easeInBack(float t, float b, float c, float d) {
	float s = 1.70158f;
	float postFix = t/=d;
	return c*(postFix)*t*((s+1)*t - s) + b;
}
float easing::easeOutBack(float t, float b, float c, float d) {
  /*
  float s = 1.70158f;
	return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
   */
	float s = 1.70158f;
  t=t/d-1;
	return c*(t*t*((s+1)*t + s) + 1) + b;
}
float easing::easeInOutBack(float t, float b, float c, float d) {
  /*
  float s = 1.70158f;
	if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525f))+1)*t - s)) + b;
	float postFix = t-=2;
	return c/2*((postFix)*t*(((s*=(1.525f))+1)*t + s) + 2) + b;
   */
	float s = 1.70158f;
  t/=d/2;
  s*=1.525f;
	if (t < 1) return c/2*(t*t*((s+1)*t - s)) + b;
	float postFix = t-=2;
  s*=1.525f;
	return c/2*((postFix)*t*((s+1)*t + s) + 2) + b;
}

// EasingBounce
float easing::easeInBounce(float t, float b, float c, float d) {
	return c - easeOutBounce(d-t, 0, c, d) + b;
}
float easing::easeOutBounce(float t, float b, float c, float d) {
	if ((t/=d) < (1/2.75f)) {
		return c*(7.5625f*t*t) + b;
	} else if (t < (2/2.75f)) {
		float postFix = t-=(1.5f/2.75f);
		return c*(7.5625f*(postFix)*t + .75f) + b;
	} else if (t < (2.5/2.75)) {
			float postFix = t-=(2.25f/2.75f);
		return c*(7.5625f*(postFix)*t + .9375f) + b;
	} else {
		float postFix = t-=(2.625f/2.75f);
		return c*(7.5625f*(postFix)*t + .984375f) + b;
	}
}
float easing::easeInOutBounce(float t, float b, float c, float d) {
	if (t < d/2) return easeInBounce(t*2, 0, c, d) * .5f + b;
	else return easeOutBounce(t*2-d, 0, c, d) * .5f + c*.5f + b;
}

// EasingCirc
float easing::easeInCirc(float t, float b, float c, float d) {
  /*
	return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
   */
  t/=d;
  return -c * (sqrt(1 - t*t) - 1) + b;
}
float easing::easeOutCirc(float t, float b, float c, float d) {
  /*
	return c * sqrt(1 - (t=t/d-1)*t) + b;
   */
  t=t/d-1;
  return c * sqrt(1 - t*t) + b;
}
float easing::easeInOutCirc(float t, float b, float c, float d) {
  /*
	if ((t/=d/2) < 1) return c/2 * (1 - sqrt(1 - t*t)) + b;
	return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
  */
  t/=d/2;
  if (t < 1) return c/2 * (1 - sqrt(1 - t*t)) + b;
  t-=2;
	return c/2 * (sqrt(1 - t*t) + 1) + b;
}

// EasingCubic
float easing::easeInCubic(float t, float b, float c, float d) {
  /*
	return c*(t/=d)*t*t + b;
   */
  t/=d;
  return c*t*t*t + b;
}
float easing::easeOutCubic(float t, float b, float c, float d) {
  /*
	return c*((t=t/d-1)*t*t + 1) + b;
   */
  t=t/d-1;
  return c*(t*t*t + 1) + b;
}
float easing::easeInOutCubic(float t, float b, float c, float d) {
  /*
	if ((t/=d/2) < 1) return c/2*t*t*t + b;
	return c/2*((t-=2)*t*t + 2) + b;
   */
  t/=d/2;
  if (t < 1) return c/2*t*t*t + b;
  t-=2;
	return c/2*(t*t*t + 2) + b;
}

// EasingElastic
float easing::easeInElastic(float t, float b, float c, float d) {
	if (t==0) return b;  if ((t/=d)==1) return b+c;
	float p=d*.3f;
	float a=c;
	float s=p/4;
	float postFix =a*pow(2,10*(t-=1)); // this is a fix, again, with post-increment operators
	return -(postFix * sin((t*d-s)*(2*M_PI)/p )) + b;
}
float easing::easeOutElastic(float t, float b, float c, float d) {
	if (t==0) return b;  if ((t/=d)==1) return b+c;
	float p=d*.3f;
	float a=c;
	float s=p/4;
	return (a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b);
}
float easing::easeInOutElastic(float t, float b, float c, float d) {
	if (t==0) return b;  if ((t/=d/2)==2) return b+c;
	float p=d*(.3f*1.5f);
	float a=c;
	float s=p/4;

	if (t < 1) {
		float postFix =a*pow(2,10*(t-=1)); // postIncrement is evil
		return -.5f*(postFix* sin( (t*d-s)*(2*M_PI)/p )) + b;
	}
	float postFix =  a*pow(2,-10*(t-=1)); // postIncrement is evil
	return postFix * sin( (t*d-s)*(2*M_PI)/p )*.5f + c + b;
}

// EasingExpo
float easing::easeInExpo(float t, float b, float c, float d) {
	return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}
float easing::easeOutExpo(float t, float b, float c, float d) {
	return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}
float easing::easeInOutExpo(float t, float b, float c, float d) {
	if (t==0) return b;
	if (t==d) return b+c;
	if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
	return c/2 * (-pow(2, -10 * --t) + 2) + b;
}

// EasingLinear
float easing::easeNoneLinear(float t, float b, float c, float d) {
	return c*t/d + b;
}
float easing::easeInLinear(float t, float b, float c, float d) {
	return c*t/d + b;
}
float easing::easeOutLinear(float t, float b, float c, float d) {
	return c*t/d + b;
}
float easing::easeInOutLinear(float t, float b, float c, float d) {
	return c*t/d + b;
}

// EasingQuad
float easing::easeInQuad(float t, float b, float c, float d) {
  /*
	return c*(t/=d)*t + b;
   */
  t/=d;
  return c*t*t + b;
}
float easing::easeOutQuad(float t, float b, float c, float d) {
  /*
	return -c *(t/=d)*(t-2) + b;
   */
  t/=d;
  return -c *t*(t-2) + b;
}
float easing::easeInOutQuad(float t, float b, float c, float d) {
  /*
	if ((t/=d/2) < 1) return c/2*t*t + b;
	return -c/2 * ((--t)*(t-2) - 1) + b;
   */
  t/=d/2;
	if (t < 1) return c/2*t*t + b;
  --t;
	return -c/2 * (t*(t-2) - 1) + b;
	
	/*
	
	originally return -c/2 * (((t-2)*(--t)) - 1) + b;

	I've had to swap (--t)*(t-2) due to diffence in behaviour in
	pre-increment operators between java and c++, after hours
	of joy
	 
	 James George:: The fix refered to above actually broke the equation, 
	 it would land at 50% all the time at the end
	 copying back the original equation from online fixed it...
	 
	 potentially compiler dependent.
	*/

}

// EasingQuart
float easing::easeInQuart(float t, float b, float c, float d) {
  /*
	return c*(t/=d)*t*t*t + b;
   */
  t/=d;
  return c*t*t*t*t + b;
}
float easing::easeOutQuart(float t, float b, float c, float d) {
  /*
	return -c * ((t=t/d-1)*t*t*t - 1) + b;
   */
  t=t/d-1;
  return -c * (t*t*t*t - 1) + b;
}
float easing::easeInOutQuart(float t, float b, float c, float d) {
  /*
	if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
	return -c/2 * ((t-=2)*t*t*t - 2) + b;
   */
  t/=d/2;
  if (t < 1) return c/2*t*t*t*t + b;
  t-=2;
	return -c/2 * (t*t*t*t - 2) + b;
}

// EasingQuint
float easing::easeInQuint(float t, float b, float c, float d) {
  /*
	return c*(t/=d)*t*t*t*t + b;
   */
  t/=d;
  return c*t*t*t*t*t + b;
}
float easing::easeOutQuint(float t, float b, float c, float d) {
  /*
	return c*((t=t/d-1)*t*t*t*t + 1) + b;
   */
  t=t/d-1;
  return c*(t*t*t*t*t + 1) + b;
}
float easing::easeInOutQuint(float t, float b, float c, float d) {
  /*
	if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
	return c/2*((t-=2)*t*t*t*t + 2) + b;
  */
  t/=d/2;
  if (t < 1) return c/2*t*t*t*t*t + b;
  t-=2;
	return c/2*(t*t*t*t*t + 2) + b;
}
