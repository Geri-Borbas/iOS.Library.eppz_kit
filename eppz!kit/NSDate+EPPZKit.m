//
//  NSDate+EPPZKit.m
//  eppz!kit
//
//  Created by Borbás Geri on 7/29/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "NSDate+EPPZKit.h"


@implementation NSDate (EPPZKit)


+(NSString*)diplayStringOfInterval:(NSTimeInterval) interval
{
    NSDate *now = [NSDate date];
    NSDate *nowPlusInterval = [[NSDate alloc] initWithTimeInterval:interval sinceDate:now];
    return [self displayStringOfIntervalFromDate:now toDate:nowPlusInterval];
}

+(NSString*)displayStringOfIntervalFromDate:(NSDate*) from toDate:(NSDate*) to
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int units = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:from toDate:to options:0];
    
    NSString *dayUnitString = (components.day > 1) ? @"days" : @"day";
    NSString *daysString = (components.day > 0) ? [NSString stringWithFormat:@"%li %@ ", (long)components.day, dayUnitString] : @"";
    
    NSString *hourLeadingZero = (components.hour < 10) ? @"0" : @"";
    NSString *minuteLeadingZero = (components.minute < 10) ? @"0" : @"";
    NSString *secondLeadingZero = (components.second < 10) ? @"0" : @"";
    
    NSString *displayString = [NSString stringWithFormat:@"%@%@%li:%@%li:%@%li",
                               daysString,
                               hourLeadingZero, (long)components.hour,
                               minuteLeadingZero, (long)components.minute,
                               secondLeadingZero, (long)components.second];
    
    return displayString;
}

-(NSString*)diplayStringOfIntervalSinceDate:(NSDate*) date
{ return [NSDate displayStringOfIntervalFromDate:self toDate:date]; }

+(void)testDisplayStringOfInterval
{
    NSArray *intervals = @[
                           @(5),
                           @(15),
                           @(150),
                           @(1500),
                           @(15000),
                           @(150000),
                           @(1500000)
                           ];
                            
    for (NSNumber *eachIntervalNumber in intervals)
    {
        NSTimeInterval eachInterval = (NSTimeInterval)eachIntervalNumber.floatValue;
        NSLog(@"Display string of <%.2f> is '%@'", eachInterval, [NSDate diplayStringOfInterval:eachInterval]);
        
    }
}


@end
