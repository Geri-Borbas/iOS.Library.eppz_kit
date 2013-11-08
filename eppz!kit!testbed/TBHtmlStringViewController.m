//
//  EPPZViewController.m
//  eppz!kit!testbed
//
//  Created by Borbás Geri on 7/15/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TBHtmlStringViewController.h"
#import "EPPZGameUser.h"


@implementation TBHtmlStringViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self testFiles];
    [self testDateExtensions];
    [self testTagFinder];
    [self testModelTools];
}

-(void)testFiles
{ NSLog(@"%@", FILES.documentsDirectory); }

-(void)testDateExtensions
{ [NSDate testDisplayStringOfInterval]; }

-(void)testTagFinder
{
    self.label_1.htmlString = @"Something really <strong>useful</strong> with tons of <strong>strong</strong> tags to be able to test this harmless <strong>tag finder</strong> snippet.";
    self.label_2.htmlString = @"<strong>Something</strong> really <strong>useful</strong> with tons of <strong>strong</strong> tags to be able to test this harmless <strong>tag finder</strong> snippet.";
    self.label_3.htmlString = @"Something really <strong>useful</strong> with actually only one strong tags.";
    self.label_4.htmlString = @"Something really useful without any strong tags.";
    self.labelThatMustWork.boldRange = NSMakeRange(0, 5);
}

-(void)testModelTools
{
    EPPZGameUser *user;
    
    BOOL store = NO;
    BOOL create = !store;
    
    if (store)
    {
        //Create a model object.
        
        //A view.
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0.0, 0.0, 100.0, 100.0}];
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        view.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.6];
        view.tag = 21;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"Bloomberg";
        
        //A game user.
        user = [EPPZGameUser new];
        user.ID = @"A1FF321FED64";
        user.serialNumber = 12;
        user.name = @"Bruce";
        user.lastModificationDate = [NSDate new];
        user.registrationDate = [NSDate new];
        user.gameID = @"2";
        user.scores = @[ @(23), @(27), @(22), @(28), @(32) ];
        user.view = view;
        user.label = label;
        
        EPPZGameProgress *progress = [EPPZGameProgress new];
        progress.progress = 5;
        progress.level = 5;
        progress.view = view;
        user.progress = progress;
        
        user.runtimeData = @"Awaiting";
        
        //Save.
        BOOL storeSuccess = [user storeAsPlistNamed:@"user"];
        NSLog(@"storeSuccess: %@", stringFromBool(storeSuccess));
    }
    
    if (create)
    {
        //Create a model object.
        user = [EPPZGameUser loadFromPlistNamed:@"user"];
        [self.view addSubview:user.progress.view];
    }
    
}


@end
