//
//  Easing.h
//

/*
 
 TERMS OF USE - EASING EQUATIONS
 
 Open source under the BSD License.
 
 Copyright © 2001 Robert Penner
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Copyright 2007 (c) Erik Sjodin, eriksjodin.net
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Inspired by http://code.google.com/p/tweener/
 * Uses http://www.jesusgollonet.com/blog/2007/09/24/penner-easing-cpp/
 */

#pragma once

namespace easing {

    // EasingBack
    float easeInBack(float t, float b, float c, float d);
    float easeOutBack(float t, float b, float c, float d);
    float easeInOutBack(float t, float b, float c, float d);
    
    // EasingBounce
    float easeInBounce(float t, float b, float c, float d);
    float easeOutBounce(float t, float b, float c, float d);
    float easeInOutBounce(float t, float b, float c, float d);

    // EasingCirc
    float easeInCirc(float t, float b, float c, float d);
    float easeOutCirc(float t, float b, float c, float d);
    float easeInOutCirc(float t, float b, float c, float d);

    // EasingCubic
    float easeInCubic(float t, float b, float c, float d);
    float easeOutCubic(float t, float b, float c, float d);
    float easeInOutCubic(float t, float b, float c, float d);

    // EasingElastic
    float easeInElastic(float t, float b, float c, float d);
    float easeOutElastic(float t, float b, float c, float d);
    float easeInOutElastic(float t, float b, float c, float d);

    // EasingExpo
    float easeInExpo(float t, float b, float c, float d);
    float easeOutExpo(float t, float b, float c, float d);
    float easeInOutExpo(float t, float b, float c, float d);

    // EasingLinear
    float easeNoneLinear(float t, float b, float c, float d);
    float easeInLinear(float t, float b, float c, float d);
    float easeOutLinear(float t, float b, float c, float d);
    float easeInOutLinear(float t, float b, float c, float d);

    // EasingQuad
    float easeInQuad(float t, float b, float c, float d);
    float easeOutQuad(float t, float b, float c, float d);
    float easeInOutQuad(float t, float b, float c, float d);

    // EasingQuart
    float easeInQuart(float t, float b, float c, float d);
    float easeOutQuart(float t, float b, float c, float d);
    float easeInOutQuart(float t, float b, float c, float d);

    // EasingQuint
    float easeInQuint(float t, float b, float c, float d);
    float easeOutQuint(float t, float b, float c, float d);
    float easeInOutQuint(float t, float b, float c, float d);
    
}


