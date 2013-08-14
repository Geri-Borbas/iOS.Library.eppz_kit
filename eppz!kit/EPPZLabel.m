//
//  EPPZLabel.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/8/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZLabel.h"


@interface EPPZLabel ()
@property (nonatomic, strong) NSString *htmlText;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) NSDictionary *normalTextAttributes;
@property (nonatomic, strong) NSDictionary *boldTextAttributes;
NSString *const CAAlignmentFromNSTextAlignment(NSTextAlignment textAlignment);
@end



@implementation EPPZLabel

-(UIFont*)boldFont
{ return [UIFont boldSystemFontOfSize:self.font.pointSize]; }

-(CATextLayer*)textLayer
{
    if (_textLayer == nil)
    {
        _textLayer = [CATextLayer new];

        //Copy.
        _textLayer.foregroundColor = self.textColor.CGColor;
        _textLayer.backgroundColor = self.backgroundColor.CGColor;
        _textLayer.frame = self.bounds;
        _textLayer.alignmentMode = CAAlignmentFromNSTextAlignment(self.textAlignment);
        
        //Copy shadow.
        _textLayer.shadowColor = self.shadowColor.CGColor;
        _textLayer.shadowOffset = self.shadowOffset;

        //Default.
        _textLayer.shadowRadius = 0.0;
        _textLayer.shadowOpacity = 1.0;
        _textLayer.wrapped = NO;
        _textLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        //Hide native text.
        self.textColor = [UIColor clearColor];
        self.shadowColor = [UIColor clearColor];
        
        //Add.
        [self.layer addSublayer:_textLayer];
    }
    
    return _textLayer;
}

NSString *const CAAlignmentFromNSTextAlignment(NSTextAlignment textAlignment)
{
    NSString *alignmentMode;
    switch (textAlignment)
    {
        case NSTextAlignmentLeft: alignmentMode = kCAAlignmentLeft; break;            
        case NSTextAlignmentCenter: alignmentMode = kCAAlignmentCenter; break;            
        case NSTextAlignmentRight: alignmentMode = kCAAlignmentRight; break;            
        case NSTextAlignmentJustified: alignmentMode = kCAAlignmentJustified; break;
        case NSTextAlignmentNatural: alignmentMode = kCAAlignmentNatural; break;
            
        default: alignmentMode = kCAAlignmentLeft; break;
    }
    return alignmentMode;
}

-(NSDictionary*)normalTextAttributes
{
    if (_normalTextAttributes == nil)
    {
        UIFont *normalFont = self.font;
        CTFontRef normalFontRef = CTFontCreateWithName((__bridge CFStringRef)normalFont.fontName, normalFont.pointSize, NULL);
        _normalTextAttributes = @{
                                  (__bridge id)kCTFontAttributeName : (__bridge id)normalFontRef,
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
        UIFont *boldFont = self.boldFont;
        CTFontRef boldFontRef = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName, boldFont.pointSize, NULL);
        _boldTextAttributes = @{
                                (__bridge id)kCTFontAttributeName : (__bridge id)boldFontRef,
                                (__bridge id)kCTForegroundColorAttributeName : (__bridge id)self.textColor.CGColor
                                };
        CFRelease(boldFontRef);
    }
    return _boldTextAttributes;
}


#pragma mark - Hooks

-(void)setText:(NSString*) text
{
    //Skip assign normal text.
    self.htmlText = text;
    [self render];
}

-(NSString*)text
{ return self.htmlText; }

-(void)setBoldRange:(NSRange) boldRange
{
    _boldRange = boldRange;
    [self render];
}


#pragma mark - Feature

-(void)render
{    
    //Compose attributed string.
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text attributes:self.normalTextAttributes];
    [attributedString addAttributes:self.boldTextAttributes range:self.boldRange];
    
    //Apply.
    self.textLayer.string = attributedString;
}


@end
