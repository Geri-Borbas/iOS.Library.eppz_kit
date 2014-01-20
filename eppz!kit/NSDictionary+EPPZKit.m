//
//  NSDictionary+EPPZKit.m
//  Totoya parenting
//
//  Created by Carnation on 20/01/14.
//  Copyright (c) 2014 Pangalaktik. All rights reserved.
//

#import "NSDictionary+EPPZKit.h"


@implementation NSDictionary (EPPZKit)


-(NSDictionary*)dictionaryBySwappingKeysAndValues
{
    NSMutableDictionary *mutable = [NSMutableDictionary new];
    [self enumerateKeysAndObjectsUsingBlock:^(id eachKey, id eachValue, BOOL *stop)
    {
        // Check if value is suitable to be a key.
        if ([eachValue conformsToProtocol:@protocol(NSCopying)])
        {
            // Set.
            id <NSCopying> eachObject = (id<NSCopying>)eachValue;
            [mutable setObject:eachKey forKey:eachObject];
        }
    }];
    
    // Return immutable.
    return [NSDictionary dictionaryWithDictionary:mutable];
}


@end
