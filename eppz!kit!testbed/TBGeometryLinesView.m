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


@interface TBCircle ()
@property (nonatomic, weak) UITouch *touch;
@property (nonatomic) CGVector touchOffset;
-(BOOL)bindTouchIfNeeded:(UITouch*) touch;
-(void)drag;
-(void)unbindTouch;
@end


@implementation TBCircle

-(BOOL)bindTouchIfNeeded:(UITouch*) touch
{
    // Location.
    CGPoint location = [touch locationInView:self.superview];
    
    // Bind if overlap.
    if (distanceBetweenPoints(location, self.center) < self.radius)
    {
        self.touchOffset = vectorBetweenPoints(location, self.center);
        self.touch = touch;
        return YES;
    }
    return NO;
}

-(void)drag
{
    if (self.touch == nil) return;
    
    // Location.
    CGPoint location = [self.touch locationInView:self.superview];
    self.center = addVectorPoints(pointFromVector(self.touchOffset), location);
}

-(void)unbindTouch
{
    self.touch = nil;
}

@end


@interface TBGeometryLinesView ()
{
    CGLine _line;
    CGPoint _point;
}
@end


@implementation TBGeometryLinesView


#pragma mark - Drag

-(void)touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event
{
    // Touch.
    UITouch *touch = [touches anyObject];
    
    // c, b, a.
    if ([self.c bindTouchIfNeeded:touch] == NO)
        if ([self.b bindTouchIfNeeded:touch] == NO)
            [self.a bindTouchIfNeeded:touch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.a drag];
    [self.b drag];
    [self.c drag];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.a unbindTouch];
    [self.b unbindTouch];
    [self.c unbindTouch];
}

-(void)drawRect:(CGRect) rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Geometry.
    _line = CGLineMake(self.a.center.x, self.a.center.y, self.b.center.x, self.b.center.y, self.a.radius * 2.0);
    _point = CGPointMake(self.c.center.x, self.c.center.y);
    
    // Test.
    CGFloat distance = distanceBetweenPointAndLineSegment(_point, _line);
    CGFloat limit = _line.width / 2.0 + self.c.radius;
    BOOL test = (distance < limit);
    UIColor *color = (test) ? [UIColor blueColor] : [UIColor blackColor];
    
    // Color.
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetAlpha(context, 0.5);
    
    // _line
    CGContextSetLineWidth(context, _line.width);
    CGContextMoveToPoint(context, _line.a.x, _line.a.y);
    CGContextAddLineToPoint(context, _line.b.x, _line.b.y);
    CGContextStrokePath(context);
}


@end
