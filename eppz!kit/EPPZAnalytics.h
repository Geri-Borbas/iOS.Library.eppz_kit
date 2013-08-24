//
//  EPPZAnalytics.h
//  camera
//
//  Created by Carnation on 11/14/12.
//
//


#import "EPPZSingletonSubclass.h"
#import "EPPZGoogleAnalyticsService.h"


//The big switch.
#define ANALYTICS_IS_ENABLED [ANALYTICS isEnabled]


#define ANALYTICS_ [EPPZAnalytics sharedAnalytics]


@interface EPPZAnalytics : EPPZSingleton

@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;
@property (nonatomic, strong) NSString *UDID;

@property (nonatomic, strong) EPPZGoogleAnalyticsService *google;

+(EPPZAnalytics*)sharedAnalytics;

-(void)takeOff;
-(void)takeOffWithPropertyList:(NSString*) propertyListName;
-(void)applicationWillEnterForeground;
-(void)applicationDidEnterBackground;
-(void)land;

-(void)setSessionDimensions;
-(void)setUserDimensions;
-(void)setHitDimensions;

-(void)page:(NSString*) pageName;
-(void)event:(NSString*) event;
-(void)event:(NSString*) event action:(NSString*) action;
-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label;
-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label value:(int) value;
-(void)setCustom:(NSInteger) index dimension:(NSString*) dimension;
-(void)setCustom:(NSInteger) index metric:(NSNumber*) metric;

-(void)startTimerForCategory:(NSString*) category name:(NSString*) name;
-(void)stopTimerForCategory:(NSString*) category name:(NSString*) name;
-(void)startTimerForCategory:(NSString*) category name:(NSString*) name label:(NSString*) label;
-(void)stopTimerForCategory:(NSString*) category name:(NSString*) name label:(NSString*) label;
-(void)removeEveryTimer;


@end
