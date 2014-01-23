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


-(void)testIsEqualToStringIgnoringCase
{
    NSString *capitalized = @"EPPZKit";
    NSString *camelCase = @"eppzKit";
    
    XCTAssertTrue([capitalized isEqualToStringIgnoringCase:camelCase],
                  @"Capitalized string should be equal (ignoring case) to lowercase string");
}

-(void)testMd5
{
    NSString *string = @"Details matter, it’s worth waiting to get it right."; // Steve Jobs.
    NSString *md5 = @"C4DC18AD70DCFFC74AE333F335D6BD20";
    
    XCTAssertTrue([string.md5 isEqualToStringIgnoringCase:md5],
                  @"MD5 sting should match.");
    
    XCTAssertTrue([string.md5 isEqualToStringIgnoringCase:[NSString md5HashFromString:string]],
                  @"MD5 aliases should be the same.");
    
    XCTAssertTrue([string.md5 isEqualToStringIgnoringCase:[NSString uniqueIDFromString:string]],
                  @"MD5 aliases should be the same.");
}

-(void)testUrl
{
    NSString *string = @"Az emberek gyakran nem tudják, hogy mit akarnak, amíg meg nem mutatod nekik."; // Steve Jobs.
    NSString *encoded = @"Az%20emberek%20gyakran%20nem%20tudj%C3%A1k%2C%20hogy%20mit%20akarnak%2C%20am%C3%ADg%20meg%20nem%20mutatod%20nekik.";
    
    XCTAssertEqualObjects(string.urlEncode,
                          encoded,
                          @"URL encoded string should match.");
    
    XCTAssertEqualObjects(string.urlEncode.urlDecode,
                          string,
                          @"URL encoded / decoded string should match original string.");
    
    NSString *exoticCharacters = @"!@#$%^&*()_+= öüóőúéáűí ÖÜÓŐÚÉÁŰÍ";
    
    XCTAssertEqualObjects(exoticCharacters.urlEncode.urlDecode,
                          exoticCharacters,
                          @"URL encoded / decoded string should match original string.");
}

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
    
    XCTAssertEqualObjects(@"01-22-2014 17:05:05 UTC".dateValue,
                          afternoon,
                          @"Dates should be equal.");
    
    XCTAssertEqualObjects(@"22 January 2014 17:05:05 +0000".dateValue,
                          afternoon,
                          @"Dates should be equal.");
        
}


@end
