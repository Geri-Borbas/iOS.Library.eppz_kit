//
//  EPPZBoolTools.m
//  eppz!kit
//
//  Created by Borbás Geri on 1/21/14.
//  Copyright (c) 2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>


@interface EPPZBoolTools : XCTestCase
@end


@implementation EPPZBoolTools


-(void)test
{
    XCTAssertEqual(0, intFromBool(NO), @"intFromBool(NO) should be 0.");
    XCTAssertEqual(1, intFromBool(YES), @"intFromBool(YES) should be 1.");
    
    XCTAssertEqual(1.0f, floatFromBool(YES), @"floatFromBool(YES) should be 1.0f.");
    XCTAssertEqual(0.0f, floatFromBool(NO), @"floatFromBool(NO) should be 0.0f.");
    
    XCTAssertEqual(YES, toggle(NO), @"toggle(NO) should be YES.");
    XCTAssertEqual(NO, toggle(YES), @"toggle(YES) should be NO.");
    
    XCTAssertEqualObjects(@"YES", stringFromBool(YES), @"stringFromBool(YES) should be @\"NO\".");
    XCTAssertEqualObjects(@"NO", stringFromBool(NO), @"stringFromBool(NO) should be @\"YES\".");

    XCTAssertEqual(0.9f, inverseFloat(0.1f), @"inverseFloat(0.1) should be 0.9.");
    XCTAssertEqual(0.5f, inverseFloat(0.5f), @"inverseFloat(0.5) should be 0.5.");    
}


@end
