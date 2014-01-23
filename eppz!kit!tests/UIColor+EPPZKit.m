//
//  _UIColor+EPPZKit.m
//  eppz!kit
//
//  Created by Borbás Geri on 1/23/12.
//  Copyright (c) 2012 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>


@interface _UIColor_EPPZKit : XCTestCase
@end


@implementation _UIColor_EPPZKit


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
