//
//  EPPZAnalyticsTimer.m
//  Gardrobe
//
//  Created by Gardrobe on 2/12/13.
//
//

#import "EPPZAnalyticsTimer.h"

@implementation EPPZAnalyticsTimer


#pragma mark - Creation

+(id)timerWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label
{ return [[self alloc] initWithCategory:category name:name label:label]; }

-(id)initWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label
{
    if (self = [super init])
    {
        self.category = category;
        self.name = name;
        self.label = label;
        
        self.startTimestamp = [NSDate new];
    }
    return self;
}


#pragma mark - Comparison

-(BOOL)isEqual:(id) object
{
    if ([object isKindOfClass:[EPPZAnalyticsTimer class]])
    {
        EPPZAnalyticsTimer *timerObject = (EPPZAnalyticsTimer*)object;
        
        BOOL namesAreEqual = [self.name isEqualToString:timerObject.name];
        if (self.name == nil && timerObject.name == nil) namesAreEqual = YES;
        
        BOOL labelsAreEqual = [self.label isEqualToString:timerObject.label];
        if (self.label == nil && timerObject.label == nil) labelsAreEqual = YES;
        
        if ([self.category isEqualToString:timerObject.category] &&
            namesAreEqual &&
            labelsAreEqual)
            return YES;
    }
    
    return NO;
}


#pragma mark - Measure

-(void)stop
{
    self.endTimestamp = [NSDate new];
    self.interval = [self.endTimestamp timeIntervalSinceDate:self.startTimestamp];
}


@end

