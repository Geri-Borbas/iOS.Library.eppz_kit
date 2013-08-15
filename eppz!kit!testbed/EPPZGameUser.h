//
//  EPPZGameUser.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZUser.h"
#import "EPPZGameProgress.h"


@interface EPPZGameUser : EPPZUser

@property (nonatomic, strong) NSString *gameID;
@property (nonatomic, strong) NSArray *scores;
@property (nonatomic, strong) NSString *runtimeData;
@property (nonatomic, strong) EPPZGameProgress *progress;

@end
