//
//  EPPZRepresentable.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@protocol EPPZRepresentable <NSObject>
@optional
+(NSArray*)representablePropertyNames;
@end


@interface NSObject (EPPZRepresentable)

@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;
+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation;

@end


#import "NSObject+EPPZRepresentable_Plist.h"

