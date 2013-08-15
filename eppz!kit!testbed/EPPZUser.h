//
//  EPPZUser.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZEntity.h"


@interface EPPZUser : EPPZEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *registrationDate;

@end
