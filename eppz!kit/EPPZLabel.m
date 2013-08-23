//
//  EPPZLabel.m
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

#import "EPPZLabel.h"


#define EPPZ_LABEL_DEBUG_MODE YES


@interface EPPZLabel ()
@property (nonatomic, strong) NSDictionary *normalTextAttributes;
@property (nonatomic, strong) NSDictionary *boldTextAttributes;
@end



@implementation EPPZLabel

-(UIFont*)boldFont
{ return [UIFont boldSystemFontOfSize:self.font.pointSize]; }

-(NSDictionary*)normalTextAttributes
{
    if (_normalTextAttributes == nil)
    {
        UIFont *normalFont = self.font;
        CTFontRef normalFontRef = CTFontCreateWithName((__bridge CFStringRef)normalFont.fontName, normalFont.pointSize, NULL);
        _normalTextAttributes = @{
                                  (__bridge id)kCTFontAttributeName : self.font,
                                  (__bridge id)kCTForegroundColorAttributeName : (__bridge id)self.textColor.CGColor
                                  };
        CFRelease(normalFontRef);
    }
    return _normalTextAttributes;
}

-(NSDictionary*)boldTextAttributes
{
    if (_boldTextAttributes == nil)
    {
        UIColor *boldColor = (EPPZ_LABEL_DEBUG_MODE) ? [UIColor blueColor] : self.textColor;
        CTFontRef boldFontRef = CTFontCreateWithName((__bridge CFStringRef)self.boldFont.fontName, self.boldFont.pointSize, NULL);
        _boldTextAttributes = @{
                                (__bridge id)kCTFontAttributeName : self.boldFont,
                                (__bridge id)kCTForegroundColorAttributeName : (__bridge id)boldColor.CGColor
                                };
        CFRelease(boldFontRef);
    }
    return _boldTextAttributes;
}


#pragma mark - Hooks

-(void)setBoldRange:(NSRange) boldRange
{
    _boldRange = boldRange;
    self.boldRanges = @[[NSValue valueWithRange:boldRange]];
    
    [self renderAttributedText];
}

-(void)setHtmlString:(NSString*) htmlString
{
    //Get <strong> ranges results.
    EPPZTagFinder *tagFinder = [EPPZTagFinder tagFinderForFindTags:@"strong" inString:htmlString];
    self.text = tagFinder.strippedString;
    self.boldRanges = tagFinder.rangeValuesOfTag;
    
    [self renderAttributedText];
}

-(void)renderAttributedText
{
    if (DEVICE.iOS6)
    {    
        //Adjust html or arbitary text.
        NSString *text = (self.htmlString != nil) ? self.htmlString : self.text;
        
        //Compose attributed string.
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:self.normalTextAttributes];
        
        //Apply bold ranges.
        for (NSValue *eachRangeValue in self.boldRanges)
        {
            NSRange eachRange = eachRangeValue.rangeValue;
            [attributedString addAttributes:self.boldTextAttributes range:eachRange];
        }
        
        self.attributedText = attributedString;
    }
}


@end
