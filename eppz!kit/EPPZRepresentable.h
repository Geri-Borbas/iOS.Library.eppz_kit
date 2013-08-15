//
//  EPPZRepresentable.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface EPPZRepresentable : NSObject


@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;

+(NSArray*)representablePropertyNames; //[Optional] subclass template
-(NSArray*)propertyNames;
+(NSArray*)propertyNamesOfObject:(NSObject*) object;
+(NSArray*)propertyNamesOfClass:(Class) class;

+(EPPZRepresentable*)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation;

@end
