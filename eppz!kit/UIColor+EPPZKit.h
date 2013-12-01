//
//  UIColor+EPPZKit.h
//  eppz!kit
//
//  Created by Gardrobe on 11/25/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]

#define RGB_(r, g, b) [UIColor colorWithRed:r green:g blue:b alpha:1.0]
#define RGBA_(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]


@interface UIColor (EPPZKit)

-(UIColor*)colorWithAlpha:(CGFloat) alpha;
-(UIColor*)blendWithColor:(UIColor*) color amount:(CGFloat) amount;

@end
