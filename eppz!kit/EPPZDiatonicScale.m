//
//  EPPZDiatonicScale.m
//  eppz!kit
//
//  Created by Borbás Geri on 10/30/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZDiatonicScale.h"


@interface EPPZDiatonicScale ()
@property (nonatomic, strong) NSArray *majorScale;
@property (nonatomic, strong) NSArray *minorScale;
@property (nonatomic, weak) NSArray *scale;
@end


@implementation EPPZDiatonicScale

-(id)init
{
    if (self = [super init])
    {
        [self defaults];
    }
    return self;
}

-(void)defaults
{
    // Scales.
    self.majorScale = @[ @(0), @(2), @(4), @(5), @(7), @(9), @(11), @(12) ];
    self.minorScale = @[ @(0), @(2), @(3), @(5), @(7), @(8), @(10), @(12) ];
    
    // Key.
    self.key = EPPZMajorKey;
}

-(void)setKey:(EPPZScaleKey) key
{
    _key = key;
    
    // Set scale.
    self.scale = (key == EPPZMajorKey) ? self.majorScale : self.minorScale;
}

-(float)pitch
{ return [self pitchForSemitone:self.semitone]; }

-(float)pitchForSemitone:(NSUInteger) semitone
{ return pow(2, (semitone / 12.0)); }

-(float)pitchForNote:(NSUInteger) note
{
    NSUInteger octave = floor(note / 7.0);
    NSUInteger noteInOctave = note % 7;
    NSUInteger semitonesBeforeOctave = octave * 12;
    NSUInteger semitone = semitonesBeforeOctave + [self.scale[noteInOctave] integerValue];
    
    float pitch = pow(2, (semitone / 12.0));
    return pitch;
}


@end
