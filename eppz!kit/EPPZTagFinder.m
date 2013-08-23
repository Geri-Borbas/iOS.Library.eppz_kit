//
//  EPPZTagFinder.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/8/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZTagFinder.h"


@interface EPPZTagFinder ()
@property (nonatomic, strong) NSString *unscannedString;
@property (nonatomic, strong) NSString *openingTag;
@property (nonatomic, strong) NSString *closingTag;
@end



@implementation EPPZTagFinder

+(id)tagFinderForFindTags:(NSString*) tag inString:(NSString*) string
{ return [[self alloc] initWithTag:tag string:string]; }

-(id)initWithTag:(NSString*) tag string:(NSString*) string
{
    if (self = [super init])
    {
        _tag = tag;
        self.openingTag = [NSString stringWithFormat:@"<%@>", tag];
        self.closingTag = [NSString stringWithFormat:@"</%@>", tag];
        _string = string;
        
        [self find];
    }
    return self;
}

-(void)find
{    
    NSUInteger cursor = 0;
    NSRange cursorRange = NSMakeRange(0, 0);
    
    NSMutableArray *rangeValuesOfTag = [NSMutableArray new];
    NSMutableString *strippedString = [NSMutableString new];
    
    //Separate by opening tag.
    NSArray *openingComponenets = [self.string componentsSeparatedByString:self.openingTag];
    for (NSString *eachComponent in openingComponenets)
    {
        //Separate by closing tag.
        NSArray *closingComponents = [eachComponent componentsSeparatedByString:self.closingTag];
        
        //Have no closing component.
        if (closingComponents.count == 1)
        {
            //Have nothing to mark with range.
            cursor += eachComponent.length; //so step over.
            
            //Collect string.
            [strippedString appendString:eachComponent];
        }
        
        //We have a closing component.
        if (closingComponents.count == 2)
        {
            //We have something to mark.
            cursorRange = NSMakeRange(cursor, [closingComponents[0] length]);
            cursor += [closingComponents[0] length] + [closingComponents[1] length];
            
            //Collect range.
            [rangeValuesOfTag addObject:[NSValue valueWithRange:cursorRange]];
            
            //Collect strings.
            [strippedString appendFormat:@"%@%@", closingComponents[0], closingComponents[1]];
        }
        
        if (closingComponents.count > 2)
        {
            //Semantic error, do nothing.
        }
    }
    
    //Save (immutable).
    _strippedString = [NSString stringWithString:strippedString];
    _rangeValuesOfTag = [NSArray arrayWithArray:rangeValuesOfTag];
}

+(NSArray*)findTags:(NSString*) tag inString:(NSString*) string
{
    EPPZTagFinder *tagFinder = [self tagFinderForFindTags:tag inString:string];
    return tagFinder.rangeValuesOfTag;
}


@end
