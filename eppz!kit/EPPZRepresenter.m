//
//  EPPZRepresenter.m
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

#import "EPPZRepresenter.h"


static NSString *const kEPPZRepresentationTypeNameDelimiter = @":";


@interface EPPZRepresenter ()

BOOL isCGRect(id value);
BOOL isCGPoint(id value);
BOOL isCGSize(id value);
BOOL isCGAffineTransform(id value);

CGRect rectValue(id value);
CGPoint pointValue(id value);
CGSize sizeValue(id value);
CGAffineTransform affineTransformValue(id value);

@end



@implementation EPPZRepresenter


#pragma mark - Representation

+(id)representationValueFromRuntimeValue:(id) runtimeValue
{
    //Default is to represent as is.
    id representationValue = runtimeValue;
    
    NSString *typeName;
    
    if (isCGRect(runtimeValue))
    {
        typeName = @"CGRect";
        representationValue = [NSString stringWithFormat:@"%@%@%@",
                               typeName, kEPPZRepresentationTypeNameDelimiter,
                               NSStringFromCGRect(rectValue(runtimeValue))];
    }
    
    if (isCGPoint(runtimeValue))
    {
        typeName = @"CGPoint";
        representationValue = [NSString stringWithFormat:@"%@%@%@",
                               typeName, kEPPZRepresentationTypeNameDelimiter,
                               NSStringFromCGPoint(pointValue(runtimeValue))];
    }
    
    if (isCGSize(runtimeValue))
    {
        typeName = @"CGSize";
        representationValue = [NSString stringWithFormat:@"%@%@%@",
                               typeName, kEPPZRepresentationTypeNameDelimiter,
                               NSStringFromCGSize(sizeValue(runtimeValue))];
    }
    
    if (isCGAffineTransform(runtimeValue))
    {
        typeName = @"CGAffineTransform";
        representationValue = [NSString stringWithFormat:@"%@%@%@",
                               typeName, kEPPZRepresentationTypeNameDelimiter,
                               NSStringFromCGAffineTransform(affineTransformValue(runtimeValue))];
    }
    
    if ([runtimeValue isKindOfClass:[UIColor class]])
    {
        typeName = @"UIColor";
        representationValue = [NSString stringWithFormat:@"%@%@%@",
                               typeName, kEPPZRepresentationTypeNameDelimiter,
                               NSStringFromUIColor(runtimeValue)];
        
    }
    
    return representationValue;
}


#pragma mark - Reconstruction

+(id)runtimeValueFromRepresentationValue:(id) representationValue
{
    //Default is to return as is.
    id runtimeValue = representationValue;
   
    //NSString.
    if ([representationValue isKindOfClass:[NSString class]])
    {
        //Look for delimiter.
        NSString *representationString = (NSString*)representationValue;
        NSArray *components = [representationString componentsSeparatedByString:kEPPZRepresentationTypeNameDelimiter];
        
        //Only if delimited.
        if (components.count > 1)
        {
            NSString *typeName = components[0];
            NSString *stringValue = components[1];
            #define TYPE_IS typeName isEqualToString
            
            if ([TYPE_IS:@"CGRect"])
            { runtimeValue = [NSValue valueWithCGRect:CGRectFromString(stringValue)]; }
            
            if ([TYPE_IS:@"CGPoint"])
            { runtimeValue = [NSValue valueWithCGPoint:CGPointFromString(stringValue)]; }
            
            if ([TYPE_IS:@"CGSize"])
            { runtimeValue = [NSValue valueWithCGSize:CGSizeFromString(stringValue)]; }
            
            if ([TYPE_IS:@"CGAffineTransform"])
            { runtimeValue = [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(stringValue)]; }
            
            if ([TYPE_IS:@"UIColor"])
            { runtimeValue = UIColorFromNSString(stringValue); }
        }
    }
    
    return runtimeValue;
}


#pragma mark - Core Graphics types

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


@end
