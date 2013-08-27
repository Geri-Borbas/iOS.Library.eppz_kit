//
//  UIColor+EPPZRepresenter.m
//  eppz!kit
//
//  Created by Carnation on 8/27/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "UIColor+EPPZRepresenter.h"


@implementation UIColor (EPPZRepresenter)


NSString *NSStringFromUIColor(UIColor *color)
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"[%f, %f, %f, %f]",
            components[0],
            components[1],
            components[2],
            components[3]];
}

UIColor *UIColorFromNSString(NSString *string)
{
    NSString *componentsString = [[string stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray *components = [componentsString componentsSeparatedByString:@", "];
    return [UIColor colorWithRed:[(NSString*)components[0] floatValue]
                           green:[(NSString*)components[1] floatValue]
                            blue:[(NSString*)components[2] floatValue]
                           alpha:[(NSString*)components[3] floatValue]];
}


@end
