//
//  UIColor+EPPZRepresenter.h
//  eppz!kit
//
//  Created by Borbás Geri on 8/28/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@interface UIColor (EPPZRepresenter)

/*!
 
 Return with the string representation of the given color.
 
 @discussion
 [UIColor whiteColor] converts to @"[1.000000, 1.000000, 1.000000, 1.000000]".
 
 */
NSString *NSStringFromUIColor(UIColor *color);

/*!
 
 Returns a UIColor instance configured with the given string representation.
 
 @discussion
 If the string is given in a components format, function returns [UIColor whiteColor] for "[1, 1, 1, 1]".
 Alternatively you can reconstruct colors from class factory method names.
 Function returns [UIColor whiteColor] for both "whiteColor" and "white".
 
 */
UIColor *UIColorFromNSString(NSString *string);

@end
