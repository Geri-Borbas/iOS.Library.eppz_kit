//
//  EPPZAnalyticsService.h
//  camera
//
//  Created by Carnation on 11/14/12.
//
//

#import <Foundation/Foundation.h>

@interface EPPZAnalyticsService : NSObject

-(void)land;

-(void)page:(NSString*) pageName;
-(void)event:(NSString*) event;
-(void)event:(NSString*) event action:(NSString*) action;
-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label;
-(void)event:(NSString*) event action:(NSString*) action label:(NSString*) label value:(int) value;

-(void)setCustom:(NSInteger) index dimension:(NSString*) dimension;
-(void)setCustom:(NSInteger) index metric:(NSNumber*) metric;

-(void)sendTimingWithCategory:(NSString*) category
                    withValue:(NSTimeInterval) interval
                     withName:(NSString*) name
                    withLabel:(NSString*) label;


@end
