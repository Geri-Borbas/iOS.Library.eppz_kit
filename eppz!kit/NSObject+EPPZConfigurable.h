//
//  NSObject+EPPZConfigurable.h
//  tangle!
//
//  Created by Gardrobe on 2/16/14.
//  Copyright (c) 2014 eppz! development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPPZConfiguration.h"


@class EPPZConfiguration;
@protocol EPPZConfigurable <NSObject>

+(instancetype)instanceForConfiguration:(EPPZConfiguration*) configuration;

@end


@interface NSObject (EPPZConfigurable)

@property (nonatomic, strong) EPPZConfiguration *configuration;

+(instancetype)instanceWithConfigurationNamed:(NSString*) configurationPlistName;
+(instancetype)instanceWithConfiguration:(EPPZConfiguration*) configuration;

-(void)configureWithConfigurationNamed:(NSString*) configurationPlistName;
-(void)configure:(EPPZConfiguration*) configuration;

@end
