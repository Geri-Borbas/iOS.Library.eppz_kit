//
//  EPPZGANWrapper.m
//  MoquuHD
//
//  Created by Borbás Geri on 4/2/12.
//  Copyright (c) 2012 eppz! development, LLC. All rights reserved.
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
