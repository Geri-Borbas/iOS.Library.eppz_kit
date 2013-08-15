//
//  EPPZEntity.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPPZEntity : EPPZRepresentable

@property (nonatomic, strong) NSString *ID;
@property (nonatomic) NSUInteger serialNumber;
@property (nonatomic) NSDate *lastModificationDate;

@end
