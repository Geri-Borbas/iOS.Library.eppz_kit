//
//  UIColor+EPPZKit.m
//  eppz!kit
//
//  Created by Gardrobe on 11/25/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
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
