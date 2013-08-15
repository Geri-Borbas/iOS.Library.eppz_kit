//
//  EPPZDevice.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EPPZSingletonSubclass.h"



#define DEVICE [EPPZDevice sharedDevice]


@interface EPPZDevice : EPPZSingleton

+(EPPZDevice*)sharedDevice;

@property (nonatomic, readonly) float iOSversion;
@property (nonatomic, readonly) BOOL iOS5;
@property (nonatomic, readonly) BOOL iOS6;
@property (nonatomic, readonly) BOOL iOS7;

@end
