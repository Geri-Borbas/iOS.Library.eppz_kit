//
//  _NSDictionary+EPPZKit.m
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


@interface _NSDictionary_EPPZKit : XCTestCase
@end


@implementation _NSDictionary_EPPZKit


-(void)test
{
    NSDictionary *dictionary = @{
                                 @"this" : @"that",
                                 @"here" : @"there",
                                 @1 : @2,
                                 };
    
    NSDictionary *inverse = @{
                              @"that" : @"this",
                              @"there" : @"here",
                              @2 : @1,
                              };
    
    XCTAssertEqualObjects([dictionary dictionaryBySwappingKeysAndValues],
                          inverse,
                          @"Directory an swapped inverse should be equal.");
}


@end
