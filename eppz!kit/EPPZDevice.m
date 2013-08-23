//
//  EPPZDevice.m
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

#import "EPPZDevice.h"


@interface EPPZDevice ()
@property (nonatomic, readonly) NSUInteger iOSversionInteger;
@end


@implementation EPPZDevice

+(EPPZDevice*)sharedDevice { return (EPPZDevice*)[self sharedInstance]; }

#pragma mark - iOS version detect

-(float)iOSversion { return [[[UIDevice currentDevice] systemVersion] floatValue]; }
-(NSUInteger)iOSversionInteger { return floor(self.iOSversion); }
-(BOOL)iOS5 { return (self.iOSversionInteger == 5); }
-(BOOL)iOS6 { return (self.iOSversionInteger == 6); }
-(BOOL)iOS7 { return (self.iOSversionInteger == 7); }


@end
