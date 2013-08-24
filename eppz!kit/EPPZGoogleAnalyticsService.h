//
//  EPPZGANWrapper.h
//  MoquuHD
//
//  Created by Borbás Geri on 4/2/12.
//  Copyright (c) 2012 eppz! development, LLC. All rights reserved.
//


#import "EPPZAnalyticsService.h"


#define GOOGLE_ANALYTICS_LOGGING YES
#define GALog if (GOOGLE_ANALYTICS_LOGGING) NSLog


@interface EPPZGoogleAnalyticsService : EPPZAnalyticsService

-(void)takeOffWithPropertyID:(NSString*) googleAnalitycsPropertyID dispatchPeriod:(NSNumber*) dispatchPeriodSeconds;

@end
