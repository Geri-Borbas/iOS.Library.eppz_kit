//
//  EPPZGoogleAnalyticsService.m
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

#import "EPPZGoogleAnalyticsService.h"


@interface EPPZGoogleAnalyticsService ()
@property (nonatomic, strong) NSString *googleAnalitycsPropertyID;
@property (nonatomic, strong) id <GAITracker> tracker;
@end


@implementation EPPZGoogleAnalyticsService


#pragma mark - Creation

-(void)takeOffWithPropertyID:(NSString*) googleAnalitycsPropertyID dispatchPeriod:(NSNumber*) dispatchPeriodSeconds
{
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    //[GAI sharedInstance].dispatchInterval = dispatchPeriodSeconds.doubleValue;
    
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    
    // Create tracker instance.
    self.googleAnalitycsPropertyID = googleAnalitycsPropertyID;
}

-(void)land { }

-(id<GAITracker>)tracker
{ return [[GAI sharedInstance] trackerWithTrackingId:self.googleAnalitycsPropertyID]; }


#pragma mark - Features

-(void)startSession
{ [self.tracker set:kGAISessionControl value:@"start"]; }

-(void)stopSession
{ [self.tracker set:kGAISessionControl value:@"stop"]; }

-(void)registerCustomDimension:(NSString*) dimension forIndex:(NSUInteger) index
{
    GALog(@"EPPZGoogleAnalyticsService registerCustomDimension:%@ forIndex:%i", dimension, index);
    [self.tracker set:[GAIFields customDimensionForIndex:index] value:dimension];
}

-(void)setCustom:(NSInteger) index dimension:(NSString*) dimension
{
    GALog(@"EPPZGoogleAnalyticsService setCustom:%i dimension:%@", index, dimension);
    [self.tracker set:[GAIFields customDimensionForIndex:index] value:dimension];
}

-(void)setCustom:(NSInteger) index metric:(NSNumber*) metric
{
    GALog(@"EPPZGoogleAnalyticsService setCustom:%i metric:%@", index, metric);
    [self.tracker set:[GAIFields customMetricForIndex:index] value:metric.stringValue];
}



-(void)page:(NSString*) pageName
{
    GALog(@"EPPZGoogleAnalyticsService page:%@", pageName);
    [self.tracker set:kGAIScreenName value:pageName];
    [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label value:(int) value;
{
    GALog(@"EPPZGoogleAnalyticsService event:%@ action:%@ label:%@ value:%i", event, action, label, value);
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:event
                                                               action:action
                                                                label:label
                                                                value:@(value)] build]];
}

-(void)sendTimingWithCategory:(NSString*) category
                    withValue:(NSTimeInterval) interval
                     withName:(NSString*) name
                    withLabel:(NSString*) label
{
    GALog(@"EPPZGoogleAnalyticsService sendTimingWithCategory:%@ withValue:%.2f withName:%@ withLabel:%@", category, interval, name, label);
    [self.tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category
                                                              interval:@(interval)
                                                                  name:name
                                                                 label:label] build]];
}


@end
