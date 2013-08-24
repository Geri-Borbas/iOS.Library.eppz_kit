//
//  EPPZAnalytics.m
//  camera
//
//  Created by Carnation on 11/14/12.
//
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

-(void)applicationWillEnterForeground
{
    #warning Test user dimensions on Google Analytics dashboard if they sent along every hit!
    [self setUserDimensions];
    [self setSessionDimensions];
}

-(void)applicationDidEnterBackground
{
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
