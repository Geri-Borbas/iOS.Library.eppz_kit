//
//  NSObject+EPPZConfigurable.m
//  tangle!
//
//  Created by Gardrobe on 2/16/14.
//  Copyright (c) 2014 eppz! development, LLC. All rights reserved.
//

#import "NSObject+EPPZConfigurable.h"


@implementation NSObject (EPPZConfigurable)


#pragma mark - Synthesize `configuration`

-(EPPZConfiguration*)configuration
{ return objc_getAssociatedObject(self, @"configuration"); }

-(void)setConfiguration:(EPPZConfiguration*) configuration
{ objc_setAssociatedObject(self, @"configuration", configuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }


#pragma mark - Creation

+(instancetype)instanceWithConfigurationNamed:(NSString*) configurationPlistName
{ return [self instanceWithConfiguration:[EPPZConfiguration loadFromPlistNamed:configurationPlistName]]; }

+(instancetype)instanceWithConfiguration:(EPPZConfiguration*) configuration
{
    id instance = [self instanceForConfiguration:configuration];
    [instance configure:configuration];
    return instance;
}

-(void)configureWithConfigurationNamed:(NSString*) configurationPlistName
{ [self configure:[EPPZConfiguration loadFromPlistNamed:configurationPlistName]]; }


#pragma mark - Template

+(instancetype)instanceForConfiguration:(EPPZConfiguration*) configuration
{ return [self new]; }


#pragma mark - Configure

-(void)configure:(EPPZConfiguration*) configuration
{
    [configuration.representedPropertyNames enumerateObjectsUsingBlock:^(NSString *eachPropertyName, NSUInteger index, BOOL *stop)
    {
        id configurationValue = [configuration valueForKey:eachPropertyName];
        if (configurationValue != nil)
        {
            // Configure contained objects way down the object graph.
            if ([configurationValue isKindOfClass:[EPPZConfiguration class]])
            {
                if ([self respondsToSelector:NSSelectorFromString(eachPropertyName)])
                { [[self valueForKey:eachPropertyName] configure:configurationValue]; }
            }
        
            // Or try to set configuration value directly if there is a value.
            @try { [self setValue:configurationValue forKey:eachPropertyName]; }
            @catch (NSException *exception)
            { NSLog(@"Could not set `%@` for `%@` on `%@`", configurationValue, eachPropertyName, self); }
            @finally { }
        }
    }];
    
    self.configuration = configuration;
}



@end
