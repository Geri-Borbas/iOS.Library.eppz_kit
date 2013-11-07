//
//  NSArray+EPPZKit.m
//  eppz!kit
//
//  Created by Gardrobe on 10/5/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "NSArray+EPPZKit.h"


@implementation NSArray (EPPZKit)

-(id)nextObjectAfterObject:(id) object
{
    // Have current object at all?
    if ([self containsObject:object] == NO) return nil;
    
    // Seek next available index.
    NSUInteger currentIndex = [self indexOfObject:object];
    NSUInteger lastIndex = self.count - 1;
    NSUInteger nextIndex;
    if (currentIndex == lastIndex) nextIndex = 0;
                              else nextIndex = currentIndex + 1;
    
    // Return object.
    return [self objectAtIndex:nextIndex];
}

@end
