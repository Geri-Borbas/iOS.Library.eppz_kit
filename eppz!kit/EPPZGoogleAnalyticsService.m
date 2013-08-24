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
#import "GAI.h"


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

-(void)page:(NSString*) pageName
{
    GALog(@"EPPZGoogleAnalyticsService page:%@", pageName);
    [self.tracker trackView:pageName];
}

-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label value:(int) value;
{
    GALog(@"EPPZGoogleAnalyticsService event:%@ action:%@ label:%@ value:%i", event, action, label, value);
    [self.tracker trackEventWithCategory:event
                              withAction:action
                               withLabel:label
                               withValue:[NSNumber numberWithInteger:value]];
}

-(void)setCustom:(NSInteger) index dimension:(NSString*) dimension
{
    GALog(@"EPPZGoogleAnalyticsService setCustom:%i dimension:%@", index, dimension);
    [self.tracker setCustom:index dimension:dimension];
}

-(void)setCustom:(NSInteger) index metric:(NSNumber*) metric
{
    GALog(@"EPPZGoogleAnalyticsService setCustom:%i metric:%@", index, metric);
    [self.tracker setCustom:index metric:metric];
}

-(void)sendTimingWithCategory:(NSString*) category
                    withValue:(NSTimeInterval) interval
                     withName:(NSString*) name
                    withLabel:(NSString*) label
{
    GALog(@"EPPZGoogleAnalyticsService sendTimingWithCategory:%@ withValue:%.2f withName:%@ withLabel:%@", category, interval, name, label);
    [self.tracker sendTimingWithCategory:category withValue:interval withName:name withLabel:label];
}


@end
