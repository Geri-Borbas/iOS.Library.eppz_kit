//
//  _NSArray+EPPZKit.m
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


@interface _NSArray_EPPZKit : XCTestCase
@end


@implementation _NSArray_EPPZKit


-(void)testNSArray_EPPZKit
{
    NSArray *array = @[ @0, @1, @2, @3, @4, @5];
    __block NSNumber *pick;
    __block BOOL comparison;
    
    XCTAssertEqualObjects([array nextObjectAfterObject:@1],
                          @2,
                          @"Next object after @1 should be @2.");
    
    XCTAssertEqualObjects([array nextObjectAfterObject:@3],
                          @4,
                          @"Next object after @3 should be @4.");
    
    
    XCTAssertEqualObjects([array nextObjectAfterObject:@5],
                          @0,
                          @"Next object after @5 should be @0.");
    
    [self repeat:100 :^
     {
         pick = [array randomObject];
         comparison = (pick.integerValue < array.count);
         XCTAssertTrue(comparison, @"Random pick %i should be in range 0-5.", pick.integerValue);
     }];
}


@end
