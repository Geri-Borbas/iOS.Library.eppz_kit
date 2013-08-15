//
//  EPPZLabel.h
//  eppz!kit
//
//  Created by Borbás Geri on 8/8/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "EPPZTagFinder.h"
#import "EPPZDevice.h"


/*
 
    Now only iOS 6.0+ feature (iOS detection encapsulated).
 
    Usage 1.
    Simply set boldRange to have a range bold.
 
    Usage 2.
    Simply set boldRanges (NSArray of NSRange NSValues) to have the ranges bold.
 
    Usage 3.
    Even more simply assign htmlString property that uses non overlapping <strong> tags.
 
*/

@interface EPPZLabel : UILabel

@property (nonatomic) NSRange boldRange;
@property (nonatomic, strong) NSArray *boldRanges;
@property (nonatomic, strong) NSString *htmlString;

-(UIFont*)boldFont; //Override in a subclass to use custom font.
@end
