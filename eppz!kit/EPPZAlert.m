//
//  EPPZAlert.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/14/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZAlert.h"


//EPPZAlert - Private methods.
@class EPPZAlertObserver;
@interface EPPZAlert ()
+(NSMutableDictionary*)alertObservers;
+(EPPZAlertObserver*)alertObserverForAlertView:(UIAlertView*) alertView;
+(void)removeObserverOfAlertView:(UIAlertView*) alertView;
@end

//EPPZAlertObserver - The sole purpose of this class is to recieve a delegate message from a paired UIAlertView.
@interface EPPZAlertObserver : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) EPPZAlertCompletition alertCompletition;
@end

@implementation EPPZAlertObserver
-(void)alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
    //Callback with the clicked button's title.
    NSString *clickedButtonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if (self.alertCompletition) self.alertCompletition(clickedButtonTitle);
    
    //Tear down.
    [EPPZAlert removeObserverOfAlertView:alertView];
}
@end


//Collection for UIAlertView observer objects.
__strong static NSMutableDictionary *_alertObservers = nil;


//EPPZAlert - Implementation.
@implementation EPPZAlert


#pragma mark - Maintain observer collection

+(NSMutableDictionary*)alertObservers
{
    //Allocate collection lazily.
    if (_alertObservers == nil) _alertObservers = [NSMutableDictionary new];
    return _alertObservers;
}

+(EPPZAlertObserver*)alertObserverForAlertView:(UIAlertView*) alertView
{
    //Corresponding observers tracked with UIAlertView's memory adress.
    NSString *key = @(alertView.hash).stringValue;
    
    //Allocate alert observer lazily (retain it in the collection).
    if ([[self alertObservers] objectForKey:key] == nil) [[self alertObservers] setObject:[EPPZAlertObserver new] forKey:key];

    return [[self alertObservers] objectForKey:key];
}

+(void)removeObserverOfAlertView:(UIAlertView*) alertView
{
    //Corresponding observers tracked with UIAlertView's memory adress.
    NSString *key = @(alertView.hash).stringValue;
    
    //Remove from collection if any (gets released since no other references maintained)
    if ([self alertObserverForAlertView:alertView])
        [[self alertObservers] removeObjectForKey:key];
}


#pragma mark - Public features

+(void)alertWithTitle:(NSString*) title
              message:(NSString*) message
         buttonTitles:(NSArray*) buttonTitles
         completition:(EPPZAlertCompletition) completition;
{
    //Allocate UIAlertView.
    UIAlertView *alertView = [UIAlertView alloc];
    
    //Create paired observer, add completition block to it.
    [[self alertObserverForAlertView:alertView] setAlertCompletition:completition];
    
    //Configure UIAlertView.
    alertView = 
    [alertView initWithTitle:title
                     message:message
                    delegate:[self alertObserverForAlertView:alertView]
           cancelButtonTitle:[buttonTitles lastObject]
           otherButtonTitles:nil];
    
    //Add button titles.
    for (NSString* eachButtonTitle in buttonTitles)
    {
        BOOL notTheLastButtonTitle = [eachButtonTitle isEqual:[buttonTitles lastObject]] == NO;
        if (notTheLastButtonTitle) [alertView addButtonWithTitle:eachButtonTitle];
    }
    
    //Show.
    [alertView show];
}


@end
