//
//  UIColor+EPPZRepresenter.m
//  eppz!kit
//
//  Created by Gardrobe on 2/15/14.
//  Copyright (c) 2014 eppz!. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface _UIColor_EPPZRepresenter : XCTestCase
@end


@implementation _UIColor_EPPZRepresenter

-(void)test
{
    XCTAssertEqualObjects([UIColor redColor],
                          UIColorFromNSString(@"[1, 0, 0, 1]"),
                          @"Red should equal red.");
    
    XCTAssertEqualObjects([UIColor redColor],
                          UIColorFromNSString(@"redColor"),
                          @"Red should equal red.");
    
    XCTAssertEqualObjects([UIColor redColor],
                          UIColorFromNSString(@"red"),
                          @"Red should equal red.");
    }

@end
