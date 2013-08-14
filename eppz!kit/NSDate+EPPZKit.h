//
//  NSDate+EPPZKit.h
//  eppz!kit
//
//  Created by Borbás Geri on 7/29/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (EPPZKit)

+(NSString*)diplayStringOfInterval:(NSTimeInterval) interval;
+(NSString*)displayStringOfIntervalFromDate:(NSDate*) from toDate:(NSDate*) to;
-(NSString*)diplayStringOfIntervalSinceDate:(NSDate*) date;

+(void)testDisplayStringOfInterval;

@end
