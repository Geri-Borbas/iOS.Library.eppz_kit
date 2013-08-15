//
//  EPPZDevice.m
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZDevice.h"


@interface EPPZDevice ()
@property (nonatomic, readonly) NSUInteger iOSversionInteger;
@end


@implementation EPPZDevice

+(EPPZDevice*)sharedDevice { return (EPPZDevice*)[self sharedInstance]; }

#pragma mark - iOS version detect

-(float)iOSversion { return [[[UIDevice currentDevice] systemVersion] floatValue]; }
-(NSUInteger)iOSversionInteger { return floor(self.iOSversion); }
-(BOOL)iOS5 { return (self.iOSversionInteger == 5); }
-(BOOL)iOS6 { return (self.iOSversionInteger == 6); }
-(BOOL)iOS7 { return (self.iOSversionInteger == 7); }


@end
