//
//  NSObject+EPPZRepresentable.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/22/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSObject+EPPZRepresentable.h"


static NSString *const kEPPZRepresentableClassNameKey = @"EPPZRepresentableClassName";


@interface NSObject (EPPZRepresentable_private)
-(NSArray*)propertyNames;
+(NSArray*)propertyNamesOfObject:(NSObject*) object;
+(NSArray*)propertyNamesOfClass:(Class) class;
+(NSArray*)collectRepresentablePropertyNames;
@end


@implementation NSObject (EPPZRepresentable)


#pragma mark - Feature management

+(BOOL)isRepresentableClass { return [self conformsToProtocol:@protocol(EPPZRepresentable)]; }
-(BOOL)isRepresentableObject { return [self.class conformsToProtocol:@protocol(EPPZRepresentable)]; }


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
    if ([value conformsToProtocol:@protocol(EPPZRepresentable)])
        value = [(NSObject<EPPZRepresentable>*)value dictionaryRepresentation];
    
    return value;
}


#pragma mark - Initialize with dictionary representation

+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation
{
    
    //Determine class.
    NSString *className = [dictionaryRepresentation objectForKey:kEPPZRepresentableClassNameKey];
    Class class = NSClassFromString(className);
    
    //No such class.
    if (class == nil) return nil;
        
    ERLog(@"Represent an <%@>", className);
    
    //Allocate instance.
    NSObject <EPPZRepresentable> *instance = [class new];
    
    //Set values.
    for (NSString *eachPropertyName in dictionaryRepresentation.allKeys)
    {
        //Exclude class name.
        if ([eachPropertyName isEqualToString:kEPPZRepresentableClassNameKey]) continue;
        
        //Get value.
        id eachRepresentationValue = [dictionaryRepresentation valueForKey:eachPropertyName];
        
        ERLog(@"Read <%@> : <%@>", eachPropertyName, eachRepresentationValue);
        
        //Create runtime value.
        id runtimeValue = [self runtimeValueFromRepresentationValue:eachRepresentationValue];
        
        //Try to set.
        @try { [instance setValue:runtimeValue forKey:eachPropertyName]; }
        @catch (NSException *exception) { NSLog(@"Aw."); }
        @finally { }
    }
    
    return instance;
}

-(id)runtimeValueFromRepresentationValue:(id) representationValue
{
    id runtimeValue;
    
    //Look for <EPPZRepresentable>
    if ([representationValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *representationValueDictionary = (NSDictionary*)representationValue;
        if ([[representationValueDictionary allKeys] containsObject:kEPPZRepresentableClassNameKey])
            runtimeValue = [[runtimeValue class] representableWithDictionaryRepresentation:representationValueDictionary];
    }
    
    //Simply return arbitrary value.
    else
    {
        runtimeValue = representationValue;
    }
    
    return representationValue;
    
}

#pragma mark - Property names

-(NSArray*)propertyNames
{ return [self.class propertyNamesOfObject:self]; }

+(NSArray*)propertyNamesOfObject:(NSObject*) object
{ return [self propertyNamesOfClass:object.class]; }

+(NSArray*)propertyNamesOfClass:(Class) class
{
    ERLog(@"Collecting properties for %@", NSStringFromClass(self));
    
    //Collection.
    NSMutableArray *collectedPropertyNames = [NSMutableArray new];
    
    //Collect properties from superclass (up till EPPZRepresentable).
    Class superclass = [self superclass];
    BOOL superclassPropertiesShouldCollected = [superclass conformsToProtocol:@protocol(EPPZRepresentable)]; //[superclass isSubclassOfClass:[EPPZRepresentable class]] && ([NSStringFromClass(superclass) isEqualToString:@"EPPZRepresentable"] == NO);
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
    //User-defined property names if any.
    if ([self instancesRespondToSelector:@selector(representablePropertyNames)])
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
