//
//  UIColor+EPPZKit.m
//  eppz!kit
//
//  Created by Borbás Geri on 11/25/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIColor+EPPZKit.h"


typedef enum { R, G, B, A } UIColorComponentIndices;


@implementation UIColor (EPPZKit)


-(CGFloat)red
{ return CGColorGetComponents(self.CGColor)[R]; }

-(CGFloat)green
{ return CGColorGetComponents(self.CGColor)[G]; }

-(CGFloat)blue
{ return CGColorGetComponents(self.CGColor)[B]; }

-(CGFloat)alpha
{ return CGColorGetComponents(self.CGColor)[A]; }

-(UIColor*)colorWithAlpha:(CGFloat) alpha
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat _R, _G, _B, _A;
    _R = components[R];
    _G = components[G];
    _B = components[B];
    _A = components[A];
    
    return RGBA_(_R, _G, _B, alpha);
}

-(UIColor*)blendWithColor:(UIColor*) color amount:(CGFloat) amount
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat _R, _G, _B, _A;
    _R = components[R];
    _G = components[G];
    _B = components[B];
    _A = components[A];
    
    const CGFloat *otherComponents = CGColorGetComponents(color.CGColor);
    CGFloat _r, _g, _b, _a;
    _r = otherComponents[R];
    _g = otherComponents[G];
    _b = otherComponents[B];
    _a = otherComponents[A];
    
    CGFloat i = (fabsf((float)amount) > 1.0) ? 1.0 : fabsf((float)amount); // Clamp to 0.0 - 1.0
    CGFloat j = 1.0 - amount;
    
    return RGBA_(_R * j + _r * i,
                 _G * j + _g * i,
                 _B * j + _b * i,
                 _A * j + _a * i);
}


@end
