//
//  UIColor+EPPZRepresenter.h
//  eppz!kit
//
//  Created by Carnation on 8/27/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (EPPZRepresenter)

NSString *NSStringFromUIColor(UIColor *color);
UIColor *UIColorFromNSString(NSString *string);

@end
