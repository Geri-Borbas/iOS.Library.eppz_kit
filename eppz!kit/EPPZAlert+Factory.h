//
//  EPPZAlert+Factory.h
//  eppz!tools
//
//  Created by Borbás Geri on 6/15/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZAlert.h"


typedef void (^EPPZAlertExplicitCompletition)();


//EPPZAlert (Factory) - You can easily extend base class this way, resulting cool alert presets for your application context.
@interface EPPZAlert (Factory)


//Alert whithout callback.
+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
         buttonTitles:(NSArray*) buttonTitles;

//A simple "Ok" alert.
+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message;

//A simple "Ok" alert (with completition).
+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
         completition:(EPPZAlertCompletition) completition;

//A simple "Yes/No/Cancel" alert (with explicit completitions).
+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
                  yes:(EPPZAlertExplicitCompletition) yesCompletition
                   no:(EPPZAlertExplicitCompletition) noCompletition
               cancel:(EPPZAlertExplicitCompletition) cancelCompletition;


@end
