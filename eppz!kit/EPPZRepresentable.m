//
//  EPPZRepresentable.m
//  eppz!kit
//
//  Created by Carnation on 8/15/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZRepresentable.h"


static NSString *const kEPPZRepresentableClassNameKey = @"EPPZRepresentableClassName";


@interface EPPZRepresentable ()
+(NSArray*)collectRepresentablePropertyNames;
@end


@implementation EPPZRepresentable


#pragma mark - Create dictionary representation

-(NSDictionary*)dictionaryRepresentation
{
    //Collection.
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary new];
    
    //Add class name.
    [dictionaryRepresentation setObject:NSStringFromClass([self class]) forKey:kEPPZRepresentableClassNameKey];
    
    //Collect values.
    for (NSString *eachPropertyName in self.propertyNames)
    { [dictionaryRepresentation setObject:[self valueForPropertyName:eachPropertyName] forKey:eachPropertyName]; }
    
    //Return immutable.
    return [NSDictionary dictionaryWithDictionary:dictionaryRepresentation];
}

-(id)valueForPropertyName:(NSString*) propertyName
{
    //Return value or representation.
    id value = [self valueForKeyPath:propertyName];
    if ([value isKindOfClass:[EPPZRepresentable class]])
        value = [(EPPZRepresentable*)value dictionaryRepresentation];
    
    return value;
}


#pragma mark - Initialize with dictionary representation

+(EPPZRepresentable*)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation
{
    #warning To be implemented.
    return nil;
}


#pragma mark - Property names

-(NSArray*)propertyNames
{ return [self.class propertyNamesOfObject:self]; }

+(NSArray*)propertyNamesOfObject:(NSObject*) object
{ return [self propertyNamesOfClass:object.class]; }

+(NSArray*)propertyNamesOfClass:(Class) class
{
    NSLog(@"Collecting properties for %@", NSStringFromClass(self));
    
    //Collection.
    NSMutableArray *collectedPropertyNames = [NSMutableArray new];
    
    //Collect properties from superclass (up till EPPZRepresentable).
    Class superclass = [self superclass];
    BOOL superclassPropertiesShouldCollected = [superclass isSubclassOfClass:[EPPZRepresentable class]] && ([NSStringFromClass(superclass) isEqualToString:@"EPPZRepresentable"] == NO);
    if (superclassPropertiesShouldCollected) { [collectedPropertyNames addObjectsFromArray:[superclass propertyNamesOfClass:[self superclass]]]; }
    
    //Collect properties from this class.
    [collectedPropertyNames addObjectsFromArray:[self collectRepresentablePropertyNames]];
    
    //Return immutable copy.
    return [NSArray arrayWithArray:collectedPropertyNames];
}

+(NSArray*)representablePropertyNames
{
    //Default behaviour is collect every property.
    return nil;
}

+(NSArray*)collectRepresentablePropertyNames
{
    if ([self representablePropertyNames] != nil)
        return [self representablePropertyNames];
    
    //Collection.
    NSMutableArray *propertyNames = [NSMutableArray new];
    
    //Collect for this class.
    NSUInteger propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    
    for (int index = 0; index < propertyCount; index++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[index])];
        [propertyNames addObject:key];
    }
    
    free(properties);
    
    //Return immutable copy.
    return [NSArray arrayWithArray:propertyNames];
}


@end
