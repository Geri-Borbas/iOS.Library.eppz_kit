//
//  EPPZAnalyticsTimer.h
//  Gardrobe
//
//  Created by Gardrobe on 2/12/13.
//
//

#import <Foundation/Foundation.h>

@interface EPPZAnalyticsTimer : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic, strong) NSDate *endTimestamp;
@property (nonatomic) NSTimeInterval interval;

+(id)timerWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label;
-(id)initWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label;

-(void)stop;

@end
