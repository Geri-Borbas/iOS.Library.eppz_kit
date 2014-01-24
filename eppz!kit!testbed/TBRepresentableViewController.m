//
//  TBRepresentableViewController.m
//  eppz!kit
//
//  Created by Gardrobe on 1/23/14.
//  Copyright (c) 2014 eppz!. All rights reserved.
//

#import "TBRepresentableViewController.h"


@interface TBRepresentableViewController ()
@property (nonatomic, strong) TBGameUser *gameUser;
@end


@implementation TBRepresentableViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self createUser];
    [EPPZRepresentableInspectorViewController presentInViewController:self
                                                    withRepresentable:self.gameUser];
}

-(void)createUser
{
    self.gameUser = [TBGameUser new];
    
    // TBUser properties.
    self.gameUser.name = @"John Doe";
    self.gameUser.registrationDate = [NSDate date];
    
        // TBGameProgress.
        TBGameProgress *gameProgress = [TBGameProgress new];
        gameProgress.progress = 12;
        gameProgress.level = 4;
    
    // TBGameUser properties.
    self.gameUser.gameID = @"_john_";
    self.gameUser.scores = @[ @10, @20, @30, @40, @50 ];
    self.gameUser.runtimeData = @"blue";
    self.gameUser.view = nil;
    self.gameUser.label = nil;
    self.gameUser.progress = gameProgress;
    
}

@end
