//
//  EPPZTagFinder.h
//  eppz!kit
//
//  Created by Borbás Geri on 8/8/13.
//  Copyright (c) 2013 eppz! development, LLC.
//  http://twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


/*
 
    EPPZTagFinder *tagFinder = [EPPZTagFinder findTags:@"<strong>" inString:@"This string contains a <strong>strong</strong> tag."];
    It gives you the stripped string (tagFinder.strippedString) with ranges (tagFinder.ranges) that points to the tagged ranges in it.

*/


@interface EPPZTagFinder : NSObject


@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSString *strippedString;
@property (nonatomic, readonly) NSString *tag;

+(id)tagFinderForFindTags:(NSString*) tag inString:(NSString*) string;
@property (nonatomic, readonly) NSArray *rangeValuesOfTag; //Array of NSValues storing NSRanges.

+(NSArray*)findTags:(NSString*) tag inString:(NSString*) string;


@end
