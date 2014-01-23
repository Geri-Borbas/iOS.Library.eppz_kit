//
//  UIColor+EPPZKit.m
//  eppz!kit
//
//  Created by Gardrobe on 1/23/14.
//  Copyright (c) 2014 eppz!. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface UIColor_EPPZKit : XCTestCase
@end


@implementation UIColor_EPPZKit


-(void)testComponents
{
    UIColor *color = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4];
    
    XCTAssertEqual(color.red, 0.1f, @"Red shoud match.");
    XCTAssertEqual(color.green, 0.2f, @"Green shoud match.");
    XCTAssertEqual(color.blue, 0.3f, @"Blue shoud match.");
    XCTAssertEqual(color.alpha, 0.4f, @"Alpha shoud match.");
}

-(void)testAlpha
{
    UIColor *color = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4];
    UIColor *opaque = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:1.0];
    UIColor *processed =[color colorWithAlpha:1.0];
    
    XCTAssertEqualObjects(opaque, processed, @"Alpha values should match.");
}

-(void)testBlend
{
    UIColor *one = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4];
    UIColor *other = [UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:0.6];
    UIColor *blended =[ UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:0.5];
    
    XCTAssertEqualObjects([one blendWithColor:other amount:0.5],
                          blended,
                          @"Blended color should match.");
}

-(void)testMacros
{
    UIColor *opaque = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    UIColor *color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    
    XCTAssertEqualObjects(RGB(51, 51, 51),
                          opaque,
                          @"Color created with macro should match.");
    
    XCTAssertEqualObjects(RGBA(51, 51, 51, 0.5),
                          color,
                          @"Color created with macro should match.");
    
    XCTAssertEqualObjects(RGB_(0.2, 0.2, 0.2),
                          opaque,
                          @"Color created with macro should match.");
    
    XCTAssertEqualObjects(RGBA_(0.2, 0.2, 0.2, 0.5),
                          color,
                          @"Color created with macro should match.");
}


@end
