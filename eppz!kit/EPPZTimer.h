//
//  EPPZTimer.h
//  eppz!kit
//
//  Created by Borbás Geri on 8/11/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPPZTimer : NSObject

@property (nonatomic, readonly) NSTimer *timer;
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval) interval
                             target:(id) target
                           selector:(SEL) selector
                           userInfo:(id) userInfo
                            repeats:(BOOL) repeat;

@end
