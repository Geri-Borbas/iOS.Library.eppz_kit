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


@implementation UIColor (EPPZKit)


-(UIColor*)colorWithAlpha:(CGFloat) alpha
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat R, G, B, A;
    R = components[0];
    G = components[1];
    B = components[2];
    A = components[3];
    
    return RGBA_(R, G, B, alpha);
}

-(UIColor*)blendWithColor:(UIColor*) color amount:(CGFloat) amount
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat R, G, B, A;
    R = components[0];
    G = components[1];
    B = components[2];
    A = components[3];
    
    const CGFloat *otherComponents = CGColorGetComponents(color.CGColor);
    CGFloat r, g, b, a;
    r = otherComponents[0];
    g = otherComponents[1];
    b = otherComponents[2];
    a = otherComponents[3];
    
    CGFloat i = (fabsf(amount) > 1.0) ? 1.0 : fabsf(amount); // Clamp to 0.0 - 1.0
    CGFloat j = 1.0 - amount;
    
    return RGBA_(R * j + r * i,
                 G * j + g * i,
                 B * j + b * i,
                 A * j + a * i);
}


@end
