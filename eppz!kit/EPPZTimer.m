//
//  EPPZTimer.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/11/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZTimer.h"


@interface EPPZTimer ()
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, strong) NSTimer *timer_;
@end


@implementation EPPZTimer


#pragma mark - Creation

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval) interval
                             target:(id) target
                           selector:(SEL) selector
                           userInfo:(id) userInfo
                            repeats:(BOOL) repeat
{
    return [[self alloc] initWithTimeInterval:interval
                                       target:target
                                     selector:selector
                                     userInfo:userInfo
                                      repeats:repeat];
}

-(id)initWithTimeInterval:(NSTimeInterval) interval
                   target:(id) target
                 selector:(SEL) selector
                 userInfo:(id) userInfo
                  repeats:(BOOL) repeat
{
    if (self = [super init])
    {
        self.target = target;
        self.selector = selector;
        self.timer_ = [NSTimer scheduledTimerWithTimeInterval:interval
                                                      target:self
                                                    selector:@selector(tick:)
                                                    userInfo:userInfo
                                                     repeats:repeat];
    }
    return self;
}

-(void)tick:(NSTimer*) timer
{
    if (self.target != nil)
    {
        if ([self.target respondsToSelector:self.selector])
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector withObject:self.timer];
            #pragma clang diagnostic pop
        }
    }
    
    else
    {
        [self.timer_ invalidate];
        //That will release EPPZTimer instance as well.
    }
}

-(NSTimer*)timer { return _timer_; }

-(void)invalidate
{
    [self.timer_ invalidate];
    //EPPZTimer is not retined by the NSTimer anymore (will release along owner).
}


@end
