//
//  _NSString+EPPZKit.m
//  eppz!kit
//
//  Created by Borbás Geri on 1/22/14.
//  Copyright (c) 2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>


@interface _NSString_EPPZKit : XCTestCase
@end


@implementation _NSString_EPPZKit


-(void)testDateValue
{
    // Create a date (date of creating this test).
    NSDateFormatter* gmtDateFormatter = [NSDateFormatter new];
    [gmtDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [gmtDateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss zzz"];
    NSDate *beforenoon = [gmtDateFormatter dateFromString:@"2014.01.22 11:00:00 GMT"];
    NSDate *afternoon = [gmtDateFormatter dateFromString:@"2014.01.22 17:05:05 GMT"];
    
    XCTAssertEqualObjects(@"2014-01-22".dateValue,
                          beforenoon,
                          @"Dates should be equal.");

    XCTAssertEqualObjects(@"2014.01.22".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"2014/01/22".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"2014 Jan 22".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"2014 Jan 22nd".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"20140122".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"01-22-2014".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"01.22.2014".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"01/22/2014".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"22 January 2014".dateValue,
                          beforenoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"01-22-2014 17:05:05 GMT".dateValue,
                          afternoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"01-22-2014 T 17:05:05 UTC".dateValue,
                          afternoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"22 January 2014 17:05:05 +0000".dateValue,
                          afternoon,
                          @"Dates should be equal.");
        
}


@end
