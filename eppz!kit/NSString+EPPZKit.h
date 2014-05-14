//
//  NSString+EPPZKit.h
//  EPPZKit
//
//  Created by Borbás Geri on 1/19/12.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>


//Extend NSString with some smart functions.
@interface NSString (EPPZKit)


-(BOOL)isEqualToStringIgnoringCase:(NSString*) string;
-(NSString*)firstFiveCharacter;
-(NSString*)firstTenCharacter;


#pragma mark - MD5

-(NSString*)md5; // lowercase result
+(NSString*)md5HashFromString:(NSString*) source; // UPPERCASE result
+(NSString*)uniqueIDFromString:(NSString*) source; //Alias for the above


#pragma mark - URL encoding

-(NSString*)urlEncode;
-(NSString*)urlDecode;


#pragma mark - Date detector

-(NSDate*)dateValue;


#pragma mark - (NSStringDrawing) compatibility

-(CGSize)_sizeWithFont:(UIFont*) font;


#pragma mark - (UIStringDrawing) compatibility

-(void)_drawAtPoint:(CGPoint) point withFont:(UIFont*) font foregroundColor:(UIColor*) color;
-(void)_drawInRect:(CGRect) frame withFont:(UIFont*) font foregroundColor:(UIColor*) color;


@end