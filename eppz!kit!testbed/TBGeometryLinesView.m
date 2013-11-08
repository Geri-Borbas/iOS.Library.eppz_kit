//
//  TBGeometryLinesView.m
//  eppz!kit
//
//  Created by Borbás Geri on 11/8/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TBGeometryLinesView.h"


@interface TBGeometryLinesView ()
{
    CGLine _one;
    CGLine _other;
}
@end


@implementation TBGeometryLinesView


-(void)awakeFromNib
{
    [super awakeFromNib];
        
    // Setup.
    _one = CGLineMake(50, 50, 200, 200, 20);
    _other = CGLineMake(50, 350, 200, 200, 60);
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Adjust.
    CGPoint location = [[touches anyObject] locationInView:self];
    _other.b = location;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect) rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Test.
    BOOL test = areLinesIntersectingConsideringWidth(_one, _other);
    UIColor *color = (test) ? [UIColor blueColor] : [UIColor blackColor];
    
    // Color.
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetAlpha(context, 0.5);
    
    // _one
    CGContextSetLineWidth(context, _one.width);
    CGContextMoveToPoint(context, _one.a.x, _one.a.y);
    CGContextAddLineToPoint(context, _one.b.x, _one.b.y);
    CGContextStrokePath(context);
    
    // _other
    CGContextSetLineWidth(context, _other.width);
    CGContextMoveToPoint(context, _other.a.x, _other.a.y);
    CGContextAddLineToPoint(context, _other.b.x, _other.b.y);
    CGContextStrokePath(context);
    
    // Calculate circles.
    calculateCirclesForLine(&(_one));
    calculateCirclesForLine(&(_other));
    
    // _one
    CGContextFillEllipseInRect (context, boundingBoxOfCircle(_one.circleA));
    CGContextFillEllipseInRect (context, boundingBoxOfCircle(_one.circleB));
    
    // _other
    CGContextFillEllipseInRect (context, boundingBoxOfCircle(_other.circleA));
    CGContextFillEllipseInRect (context, boundingBoxOfCircle(_other.circleB));
}


@end
