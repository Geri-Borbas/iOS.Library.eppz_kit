//
//  EPPZCoreGraphicsTools.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/22/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZCoreGraphicsTools.h"


BOOL isCGRect(id value)
{
    if ([value isKindOfClass:[NSValue class]] == NO) return NO;
    if(strcmp([(NSValue*)value objCType], @encode(CGRect)) != 0) return NO;
    return YES;
}

BOOL isCGPoint(id value)
{
    if ([value isKindOfClass:[NSValue class]] == NO) return NO;
    if(strcmp([(NSValue*)value objCType], @encode(CGPoint)) != 0) return NO;
    return YES;
}

BOOL isCGSize(id value)
{
    if ([value isKindOfClass:[NSValue class]] == NO) return NO;
    if(strcmp([(NSValue*)value objCType], @encode(CGSize)) != 0) return NO;
    return YES;
}

BOOL isCGAffineTransform(id value)
{
    if ([value isKindOfClass:[NSValue class]] == NO) return NO;
    if(strcmp([(NSValue*)value objCType], @encode(CGAffineTransform)) != 0) return NO;
    return YES;
}

BOOL isCGType(id value)
{ return (isCGRect(value) || isCGPoint(value) || isCGSize(value) || isCGAffineTransform(value)); }


CGRect rectValue(id value)
{
    if (isCGRect(value) == NO) return CGRectZero;
    
    CGRect rectValue;
    [(NSValue*)value getValue:&rectValue];
    return rectValue;
}

CGPoint pointValue(id value)
{
    if (isCGPoint(value) == NO) return CGPointZero;
    
    CGPoint pointValue;
    [(NSValue*)value getValue:&pointValue];
    return pointValue;
}

CGSize sizeValue(id value)
{
    if (isCGSize(value) == NO) return CGSizeZero;
    
    CGSize sizeValue;
    [(NSValue*)value getValue:&sizeValue];
    return sizeValue;
}

CGAffineTransform affineTransformValue(id value)
{
    if (isCGAffineTransform(value) == NO) return CGAffineTransformIdentity;
    
    CGAffineTransform affineTransformValue;
    [(NSValue*)value getValue:&affineTransformValue];
    return affineTransformValue;
}


NSString *stringValueOfCGValue(id value)
{
    if ([value isKindOfClass:[NSValue class]] == NO) return nil;
    
    if (isCGRect(value))
        return NSStringFromCGRect(rectValue(value));
    
    if (isCGPoint(value))
        return NSStringFromCGPoint(pointValue(value));
    
    if (isCGSize(value))
        return NSStringFromCGSize(sizeValue(value));
    
    if (isCGAffineTransform(value))
        return NSStringFromCGAffineTransform(affineTransformValue(value));
    
    return nil;
}
