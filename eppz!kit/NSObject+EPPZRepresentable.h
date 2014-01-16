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

#define EPPZ_REPRESENTABLE_DEBUG_LOGGING YES
#define ERDLog if (EPPZ_REPRESENTABLE_DEBUG_LOGGING) NSLog



static NSString *const kEPPZRepresentableErrorDomain = @"__eppz.representable";


@protocol EPPZRepresentable <NSObject>
@optional

+(id)instance;

+(NSArray*)representablePropertyNames;
+(NSDictionary*)propertyNamesForRepresentedPropertyNames;

+(Class)classForRepresentedClassName:(NSString*) representedClassName; // Template to return classes for represented class names.
+(NSString*)representedClassNameForClass:(Class) class; // Template to return represented class names for classes.

+(NSString*)representedClassNameKey; // Key for value that match classes upon reconstruction / representation.

+(BOOL)representID;
+(BOOL)representClass;
+(BOOL)representType;

+(BOOL)reconstructID;
+(BOOL)reconstructClass;
+(BOOL)reconstructType;

+(id)representedValueForValue:(id) value;
+(id)valueForRepresentedValue:(id) representedValue;


@end


@interface NSObject (EPPZRepresentable)

#pragma mark - General features
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;
+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation;
-(Class)classOfPropertyNamed:(NSString*) propertyName;

#pragma mark - Subclass templates

// Deprecated.
-(void)willStore;
-(void)didStore;
-(void)willLoad;
-(void)didLoad;

-(void)willRepresented; //Before represent into a dictionary.
-(void)didRepresented; //After represent into a dictionary.
-(void)willReconstructed; //Before populate values from a dictionary.
-(void)didReconstructed; //After populated values from a dictionary.

@end


#import "NSObject+EPPZRepresentable_Plist.h"
#import "NSObject+EPPZRepresentable_Archive.h"

