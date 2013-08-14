//
//  EPPZTagFinder.h
//  eppz!kit
//
//  Created by Carnation on 8/8/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 
    EPPZTagFinder *tagFinder = [EPPZTagFinder findTags:@"<strong>" inString:@"This string contains a <strong>strong</strong> tag."];
    It gives you the stripped string (tagFinder.strippedString) with ranges (tagFinder.ranges) that points to the tagged ranges in it.

*/


@interface EPPZTagFinder : NSObject


@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSString *strippedString;
@property (nonatomic, readonly) NSString *tag;

+(id)findTags:(NSString*) tag inString:(NSString*) string;
@property (nonatomic, readonly) NSArray *rangeValuesOfTag; //Array of NSValues storing NSRanges.


@end
