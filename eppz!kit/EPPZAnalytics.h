//
//  EPPZAnalytics.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> //For Google Analytics iOS SDK.

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
