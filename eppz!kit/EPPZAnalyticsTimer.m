//
//  EPPZAnalyticsTimer.m
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

#import "EPPZAnalyticsTimer.h"

@implementation EPPZAnalyticsTimer


#pragma mark - Creation

+(id)timerWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label
{ return [[self alloc] initWithCategory:category name:name label:label]; }

-(id)initWithCategory:(NSString*) category name:(NSString*) name label:(NSString*) label
{
    if (self = [super init])
    {
        self.category = category;
        self.name = name;
        self.label = label;
        
        self.startTimestamp = [NSDate new];
    }
    return self;
}


#pragma mark - Comparison

-(BOOL)isEqual:(id) object
{
    if ([object isKindOfClass:[EPPZAnalyticsTimer class]])
    {
        EPPZAnalyticsTimer *timerObject = (EPPZAnalyticsTimer*)object;
        
        BOOL namesAreEqual = [self.name isEqualToString:timerObject.name];
        if (self.name == nil && timerObject.name == nil) namesAreEqual = YES;
        
        BOOL labelsAreEqual = [self.label isEqualToString:timerObject.label];
        if (self.label == nil && timerObject.label == nil) labelsAreEqual = YES;
        
        if ([self.category isEqualToString:timerObject.category] &&
            namesAreEqual &&
            labelsAreEqual)
            return YES;
    }
    
    return NO;
}


#pragma mark - Measure

-(void)stop
{
    self.endTimestamp = [NSDate new];
    self.interval = [self.endTimestamp timeIntervalSinceDate:self.startTimestamp];
}


@end

