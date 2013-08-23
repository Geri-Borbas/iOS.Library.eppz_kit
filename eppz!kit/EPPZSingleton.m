//
//  EPPZSingleton.m
//  EPPZKit
//
//  Created by Borbás Geri on 1/23/12.
//  Copyright (c) 2012 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "EPPZSingleton.h"


NSMutableDictionary *_sharedEPPZSingletonInstances = nil;


@implementation EPPZSingleton


#pragma mark - Delegate weak messaging

-(void)addDelegate:(id) object
{
    [_delegates addObject:object];
}

-(void)removeDelegate:(id) object
{   
    [_delegates removeObject:object];
}

-(void)messageDelegates:(SEL) selector
{
    [self messageDelegates:selector withObject:nil];    
}

-(void)messageDelegates:(SEL) selector withObject:(id) object;
{    
    [self messageDelegates:selector withObject:object withObject:nil];
}

-(void)messageDelegates:(SEL) selector withObject:(id) object withObject:(id) anotherObject;
{
    for (id eachDelegate in _delegates)
    {
        if ([eachDelegate respondsToSelector:selector])
            [eachDelegate performSelector:selector withObject:object withObject:anotherObject];    
    }
}

-(id)queryLastDelegate:(SEL) selector
{
    return [self queryLastDelegate:selector withObject:nil];
}

-(id)queryLastDelegate:(SEL)selector withObject:(id)object
{
    return [self queryLastDelegate:selector withObject:object withObject:nil];
}

-(id)queryLastDelegate:(SEL)selector withObject:(id) object withObject:(id) anotherObject
{
    id delegate = [_delegates lastObject];
    
    if (delegate != nil)
        if ([delegate respondsToSelector:selector])
            return [delegate performSelector:selector withObject:object withObject:anotherObject];
    
    return nil;
}


#pragma mark - Lifecycle

-(id)init
{
    NSLog(@"<%@> INIT.", NSStringFromClass(self.class));
    
    if (self = [super init])
    {
        _delegates = [NSMutableArray new];
    }
    return self;
}

-(void)dealloc
{
    [self.class.sharedInstances removeObjectForKey:self.class.className];    
    
    [_delegates removeAllObjects];
    [_delegates release], _delegates = nil;
    
    [super dealloc];
}


#pragma mark - Singleton class setup

+(NSString*)className
{
    return NSStringFromClass(self);
}

+(NSMutableDictionary*)sharedInstances
{
    if (_sharedEPPZSingletonInstances == nil) _sharedEPPZSingletonInstances = [NSMutableDictionary new];
    return _sharedEPPZSingletonInstances;
}

+(id)sharedInstance
{    
    id soleInstanceForClass = [self.sharedInstances objectForKey:self.className];
    
    if (soleInstanceForClass == nil )
    {
        soleInstanceForClass = [NSAllocateObject([self class], 0, NULL) init]; //via Carlo Chung.
        [self.sharedInstances setObject:soleInstanceForClass forKey:self.className];
    } 
    
	return soleInstanceForClass;
}

+(id)allocWithZone:(NSZone*) zone { return [[self sharedInstance] retain]; }
-(id)copyWithZone:(NSZone*) zone { return self; }
-(id)retain { return self; }
-(NSUInteger)retainCount { return NSUIntegerMax; }
-(oneway void)release { }
-(id)autorelease { return self; }


@end
