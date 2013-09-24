//
//  EPPZRepresentable.h
//  eppz!kit
//
//  Created by Borbás Geri on 8/22/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "EPPZTools.h"
#import "EPPZRepresenter.h"

#import "EPPZRepresentableException.h"


#define EPPZ_REPRESENTABLE_LOGGING YES
#define ERLog if (EPPZ_REPRESENTABLE_LOGGING) NSLog


static NSString *const kEPPZRepresentableErrorDomain = @"__eppz.representable";


@protocol EPPZRepresentable <NSObject>
@optional
+(NSArray*)representablePropertyNames;
@end


@interface NSObject (EPPZRepresentable)

#pragma mark - General features
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;
+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation;

#pragma mark - Subclass templates
-(void)willStore; //Before represent into a dictionary.
-(void)willLoad; //Before populate values from a dictionary.
-(void)didLoad; //After populated values from a dictionary.

@end


#import "NSObject+EPPZRepresentable_Plist.h"
#import "NSObject+EPPZRepresentable_Archive.h"
