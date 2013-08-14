//
//  EPPZTagFinder.m
//  eppz!kit
//
//  Created by Carnation on 8/8/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZTagFinder.h"

@implementation EPPZTagFinder

+(id)findTags:(NSString*) tag inString:(NSString*) string
{ return [[self alloc] initWithTag:tag string:string]; }

-(id)initWithTag:(NSString*) tag string:(NSString*) string
{
    if (self = [super init])
    {
        _tag = tag;
        _string = string;
        
        [self find];
    }
    return self;
}

-(void)find
{
    NSScanner *scanner = [NSScanner scannerWithString:self.string];
    
    NSString *scannedString;

    //Do.
    [scanner scanUpToString:self.tag intoString:&scannedString];
    
    while (scannedString != nil)
    {
        NSLog(@"scannedString '%@'", scannedString);
        
        //Reset.
        //scannedString = nil;
        
        //Do.
        [scanner scanUpToString:self.tag intoString:&scannedString];
    }
}


@end
