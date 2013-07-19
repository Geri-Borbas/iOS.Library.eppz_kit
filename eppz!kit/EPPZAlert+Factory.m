//
//  EPPZAlert+Factory.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/15/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "EPPZAlert+Factory.h"

@implementation EPPZAlert (Factory)


+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
         buttonTitles:(NSArray*) buttonTitles
{ [self alertWithTitle:title message:message buttonTitles:buttonTitles completition:nil]; }

+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
{ [self alertWithTitle:title message:message buttonTitles:@[ @"Ok" ] completition:nil]; }

+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
         completition:(EPPZAlertCompletition) completition;
{ [self alertWithTitle:title message:message buttonTitles:@[ @"Ok" ] completition:completition]; }

+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
                  yes:(EPPZAlertExplicitCompletition) yesCompletition
                   no:(EPPZAlertExplicitCompletition) noCompletition
               cancel:(EPPZAlertExplicitCompletition) cancelCompletition
{
    [self alertWithTitle:title
                 message:message
            buttonTitles:@[ @"Yes", @"No", @"Cancel" ]
            completition:^(NSString *selectedButtonTitle)
     {
         if ([selectedButtonTitle isEqualToString:@"Yes"])
             if (yesCompletition) yesCompletition();
         
         if ([selectedButtonTitle isEqualToString:@"No"])
             if (noCompletition) noCompletition();
         
         if ([selectedButtonTitle isEqualToString:@"Cancel"])
             if (cancelCompletition) cancelCompletition();
     }];
}


@end
