//
//  EPPZEntity.h
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//


@interface EPPZEntity : NSObject <EPPZRepresentable>

@property (nonatomic, strong) NSString *ID;
@property (nonatomic) NSUInteger serialNumber;
@property (nonatomic) NSDate *lastModificationDate;

@end
