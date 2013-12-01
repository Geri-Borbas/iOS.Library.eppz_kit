//
//  UIFont+EPPZKit.m
//  eppz!kit
//
//  Created by Gardrobe on 11/26/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "UIFont+EPPZKit.h"


@implementation UIFont (EPPZKit)


+(void)logFontList
{
    for (NSString *eachFamiliyName in [UIFont familyNames])
    {
        NSLog(@"Family: %@", eachFamiliyName);
        for (NSString *eachFontName in [UIFont fontNamesForFamilyName:eachFamiliyName])
        { NSLog(@"  Font: %@", eachFontName); }
    }
}


@end
