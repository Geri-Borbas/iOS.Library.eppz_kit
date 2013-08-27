//
//  EPPZAnalytics.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/24/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZAnalytics.h"
#import "EPPZAnalyticsTimer.h"


@interface EPPZAnalytics ()
@property (nonatomic, strong) NSString *analyticsPropertyListPath;
@property (nonatomic, strong) NSDictionary *analyticsProperties;
@property (nonatomic, strong) NSMutableArray *timers;
@end


static NSString *kGoogleAnalyticsPropertyIDKeyPath = @"GoogleAnalytics.propertyID";
static NSString *kGoogleAnalyticsDispatchPeriodKeyPath = @"GoogleAnalytics.dispatchPeriod";


@implementation EPPZAnalytics


#pragma mark - Typecast helper

+(EPPZAnalytics*)sharedAnalytics { return (EPPZAnalytics*)[self sharedInstance]; }


#pragma mark - User permission

@synthesize enabled = _enabled;

-(BOOL)isEnabled
{ return YES; }


#pragma mark - Creation

-(void)takeOff
{
    [self takeOffWithPropertyList:NSStringFromClass(self.class)];
}

-(void)applicationDidFinishLaunching
{
    [self.google startSession];
    [self setUserDimensions];
    [self setSessionDimensions];
}

-(void)applicationWillEnterForeground
{
    [self.google startSession];
    [self setUserDimensions];
    [self setSessionDimensions];
}

-(void)applicationDidEnterBackground
{
    [self.google stopSession];
    [self removeEveryTimer];
}


-(void)takeOffWithPropertyList:(NSString*) propertyListName
{
    NSBundle *bundle = [NSBundle mainBundle];
    self.analyticsPropertyListPath = [bundle pathForResource:propertyListName ofType:@"plist"];
    self.analyticsProperties = [NSDictionary dictionaryWithContentsOfFile:self.analyticsPropertyListPath];
    
    self.timers = [NSMutableArray new];
    
    NSLog(@"EPPZAnalytics analyticsProperties: %@", self.analyticsProperties);
    
    NSLog(@"Analytics enabled: (%i)", [self isEnabled]);
    
    if ([self isEnabled])
    {
        BOOL hasGoogleSetup = ([self.analyticsProperties valueForKeyPath:kGoogleAnalyticsPropertyIDKeyPath] != nil);
        
        if (hasGoogleSetup)
        {
            self.google = [EPPZGoogleAnalyticsService new];
            [self.google takeOffWithPropertyID:[self.analyticsProperties valueForKeyPath:kGoogleAnalyticsPropertyIDKeyPath]
                                dispatchPeriod:[self.analyticsProperties valueForKeyPath:kGoogleAnalyticsDispatchPeriodKeyPath]];
            [self registerCustomDimensions];
        }
    }
}

-(void)land
{
    if ([self isEnabled])
    {
        [self.google land];
    }
}


#pragma mark - Features

-(void)registerCustomDimensions { }

-(void)registerCustomDimension:(NSString*) dimension forIndex:(NSUInteger) index
{
    if ([self isEnabled])
    {
        [self.google registerCustomDimension:dimension forIndex:index];
    }
}

-(void)setSessionDimensions { }

-(void)setUserDimensions { }

-(void)setHitDimensions { }

-(void)page:(NSString*) pageName
{
    if ([self isEnabled])
    {
        [self setHitDimensions];
        [self.google page:pageName];
    }
}

-(void)event:(NSString*) event
{ [self event:event action:nil]; }

-(void)event:(NSString*) event action:(NSString*) action
{ [self event:event action:action label:nil]; }

-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label
{ [self event:event action:action label:label value:0]; }

-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label value:(int) value
{
    if ([self isEnabled])
    {
        [self setHitDimensions];
        [self.google event:event action:action label:label value:value];
    }
}

-(void)setCustom:(NSInteger) index dimension:(NSString*) dimension
{
    if ([self isEnabled])
    {
        [self.google setCustom:index dimension:dimension];
    }
}

-(void)setCustom:(NSInteger) index metric:(NSNumber*) metric
{
    if ([self isEnabled])
    {
        [self.google setCustom:index metric:metric];
    }
}


#pragma mark - Feratures (timers)

-(void)startTimerForCategory:(NSString*) category name:(NSString*) name
{ [self startTimerForCategory:category name:name label:nil]; }

-(void)stopTimerForCategory:(NSString*) category name:(NSString*) name
{ [self stopTimerForCategory:category name:name label:nil]; }

-(void)startTimerForCategory:(NSString *)category name:(NSString *)name label:(NSString *)label
{
    EPPZAnalyticsTimer *timer = [EPPZAnalyticsTimer timerWithCategory:category
                                                                 name:name
                                                                label:label];
    [self.timers addObject:timer];
}

-(void)stopTimerForCategory:(NSString *)category name:(NSString *)name label:(NSString *)label
{
    GALog(@"EPPZAnalytics stopTimerForCategory:%@ name:%@ label:%@", category, name, label);
    EPPZAnalyticsTimer *timer = [self timerForCategory:category name:name label:label];
    
    if (timer != nil)
    {
        [timer stop];
        
        //Send hit.
        GALog(@"EPPZAnalytics timer found. interval:(%f)", timer.interval);
        [self.google sendTimingWithCategory:timer.category
                                  withValue:timer.interval
                                   withName:timer.name
                                  withLabel:timer.label];
        
        [self.timers removeObject:timer];
    }
    
    else
    {
        GALog(@"EPPZAnalytics timer not found.");
    }
}

-(void)removeEveryTimer
{
    [self.timers removeAllObjects];
}

-(EPPZAnalyticsTimer*)timerForCategory:(NSString*) category name:(NSString*) name label:(NSString*) label
{
    EPPZAnalyticsTimer *timerLookingFor = [EPPZAnalyticsTimer timerWithCategory:category name:name label:label];
    EPPZAnalyticsTimer *timerFound;
    
    for (EPPZAnalyticsTimer *eachTimer in self.timers)
    {
        if ([eachTimer isEqual:timerLookingFor])
            timerFound = eachTimer;
    }
    
    return timerFound;
}


@end
