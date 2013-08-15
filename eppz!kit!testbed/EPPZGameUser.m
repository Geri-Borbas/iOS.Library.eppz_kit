//
//  EPPZGameUser.m
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZGameUser.h"

@implementation EPPZGameUser

+(NSArray*)representablePropertyNames
{
    return @[
             @"gameID",
             @"scores",
             @"progress"
             ];
}

@end
