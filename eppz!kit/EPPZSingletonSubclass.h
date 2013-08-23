//
//  EPPZSingletonSubclass.h
//  EPPZKit
//
//  Created by Borbás Geri on 5/26/12.
//  Copyright (c) 2011 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "EPPZSingleton.h"


extern NSMutableDictionary *_sharedEPPZSingletonInstances;


@interface EPPZSingleton (Protected)

+(NSString*)className;

-(void)messageDelegates:(SEL) selector;
-(void)messageDelegates:(SEL) selector withObject:(id) object;
-(void)messageDelegates:(SEL) selector withObject:(id) object withObject:(id) anotherObject;

-(id)queryLastDelegate:(SEL) selector;
-(id)queryLastDelegate:(SEL) selector withObject:(id) object;
-(id)queryLastDelegate:(SEL) selector withObject:(id) object withObject:(id) anotherObject;


@end
