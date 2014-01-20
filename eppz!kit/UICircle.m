//
//  UICircle.m
//  eppz!kit
//
//  Created by Borbás Geri on 11/24/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UICircle.h"


@interface EPPZCircleLayer : CALayer
@property (nonatomic, strong) UIColor *color;
@end


@implementation EPPZCircleLayer

-(void)drawInContext:(CGContextRef) context
{
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillEllipseInRect(context, self.bounds);
}

@end


@implementation UICircle


#pragma mark - Creation

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(instancetype)initWithFrame:(CGRect) frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    // Setup circle layer.
    EPPZCircleLayer *layer = [EPPZCircleLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.frame = self.bounds;
    layer.color = self.backgroundColor;
    [layer setNeedsDisplay];
    
    // Add.
    [self.layer addSublayer:layer];
    
    // Hide background.
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Layout

-(void)setRadius:(CGFloat) radius
{
    _radius = radius;
    
    // Layout.
    self.frame = (CGRect){
        self.center.x - radius,
        self.center.y - radius,
        radius * 2.0,
        radius * 2.0
    };
    
    // Render.
    [self setNeedsDisplay];
}


@end
