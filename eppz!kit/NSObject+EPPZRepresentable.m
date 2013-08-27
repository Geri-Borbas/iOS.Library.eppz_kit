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


__strong static NSMutableDictionary *_objectPools;


static NSString *const kEPPZRepresentableHashKey = @"__eppz.representable.id"; //@"EPPZRepresentableHash";
static NSString *const kEPPZRepresentableClassNameKey = @"__eppz.representable.class";


@interface NSObject (EPPZRepresentable_private)

-(NSArray*)propertyNames;
+(NSArray*)propertyNamesOfObject:(NSObject*) object;
+(NSArray*)propertyNamesOfClass:(Class) class;
+(NSArray*)collectRepresentablePropertyNames;

-(NSDictionary*)dictionaryRepresentationWithObjectPool:(NSMutableArray*) objectPool;
+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation objectPool:(NSMutableArray*) objectPool;

@end


@implementation NSObject (EPPZRepresentable)


#pragma mark - Feature management

+(BOOL)isRepresentableClass { return [self conformsToProtocol:@protocol(EPPZRepresentable)]; }
-(BOOL)isRepresentableObject { return [self.class conformsToProtocol:@protocol(EPPZRepresentable)]; }


#pragma mark - Object pools

-(NSString*)representableID
{ return @(self.hash).stringValue; }

+(NSMutableArray*)objectPoolForRepresentable:(NSObject*) representable
{
    if ([[_objectPools allKeys] containsObject:representable.representableID])
    { return [_objectPools objectForKey:representable.representableID]; }
    return nil;
}

+(void)addObjectPoolForRepresentable:(NSObject*) representable
{
    if (_objectPools == nil)
    { _objectPools = [NSMutableDictionary new]; }
    
    if ([[_objectPools allKeys] containsObject:representable.representableID] == NO)
    { [_objectPools setObject:[NSMutableArray new] forKey:representable.representableID]; }
}

+(void)removeObjectPoolForRepresentable:(NSObject*) representable
{
    if ([[_objectPools allKeys] containsObject:representable.representableID])
    { [_objectPools removeObjectForKey:representable.representableID]; }
}

+(void)addObject:(id) object toPool:(NSMutableArray*) objectPool
{
    if ([objectPool containsObject:object] == NO)
        [objectPool addObject:object];
}


#pragma mark - Create dictionary representation

-(NSDictionary*)dictionaryRepresentation
{
    //Top-level dictionary.
    NSDictionary *dictionaryRepresentation = [self dictionaryRepresentationWithObjectPool:nil];
    
    //Release representations in pool after process.
    [NSObject removeObjectPoolForRepresentable:self];
    
    return dictionaryRepresentation;
}

-(NSDictionary*)dictionaryRepresentationWithObjectPool:(NSMutableArray*) objectPool
{ _LOG
    
    NSLog(@"_objectPools %@", _objectPools);
    
    //Collection.
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary new];
    
    //Add class name.
    [dictionaryRepresentation setObject:NSStringFromClass([self class]) forKey:kEPPZRepresentableClassNameKey];
    
    //Add hash.
    [dictionaryRepresentation setObject:@(self.hash).stringValue forKey:kEPPZRepresentableHashKey];
    
    //Ensure to represent references only once.
    if (objectPool != nil)
    {
        //Store only __eppz.representable.id if already represented in this run.
        if ([objectPool containsObject:self])
        {
            //Return immutable.
            return [NSDictionary dictionaryWithDictionary:dictionaryRepresentation];
        }
    }
    
    else
    {
        //Create object pool (asserting this object is the top-level object).
        [NSObject addObjectPoolForRepresentable:self];
        
    }
    
    //Collect (non-nil) values.
    for (NSString *eachPropertyName in [self.class collectRepresentablePropertyNames])
    {
        id value = [self representationValueForPropertyName:eachPropertyName
                                                 objectPool:[NSObject objectPoolForRepresentable:self]];
        if (value != nil)
            [dictionaryRepresentation setObject:value
                                         forKey:eachPropertyName];
    }
    
    //Return immutable.
    return [NSDictionary dictionaryWithDictionary:dictionaryRepresentation];
}

-(id)representationValueForPropertyName:(NSString*) propertyName objectPool:(NSMutableArray*) objectPool
{   
    ERLog(@"%@ representationValueForPropertyName:%@", NSStringFromClass(self.class), propertyName);
    
    //Get the actual (runtime) value for this key.
    
        id runtimeValue = [self valueForKeyPath:propertyName];
        
    //EPPZRepresentable.
    
        if ([runtimeValue conformsToProtocol:@protocol(EPPZRepresentable)])
        {
            NSDictionary *dictionaryRepresentation = [(NSObject<EPPZRepresentable>*)runtimeValue dictionaryRepresentationWithObjectPool:objectPool];
            [NSObject addObject:dictionaryRepresentation toPool:objectPool];
            return dictionaryRepresentation;
        }
        
    //The rest.
    return [EPPZRepresenter representationValueFromRuntimeValue:runtimeValue];
}


#pragma mark - Initialize with dictionary representation

+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation
{ _LOG
    
    //Determine class.
    NSString *className = [dictionaryRepresentation objectForKey:kEPPZRepresentableClassNameKey];
    Class class = NSClassFromString(className);
    
    //No such class.
    if (class == nil) return nil;
        
    //Allocate instance.
    NSObject <EPPZRepresentable> *instance = [class new];
    
    ERLog(@"Reconstruct <%@> %@ from dictionary", className, instance);
    
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
{ _LOG
    
    id runtimeValue;
    
    //Look for <EPPZRepresentable> or NSDictionary
    if ([representationValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *representationValueDictionary = (NSDictionary*)representationValue;
        Class class = class = [NSDictionary class];
        
        //Create custom class if present.
        if ([[representationValueDictionary allKeys] containsObject:kEPPZRepresentableClassNameKey])
        {
            NSString *className = [representationValueDictionary objectForKey:kEPPZRepresentableClassNameKey];
            class = NSClassFromString(className);
        }
        
        //Create representable.
        runtimeValue = [class representableWithDictionaryRepresentation:representationValueDictionary];
    }
    
    //Simply return arbitrary value.
    else
    {
        runtimeValue = [EPPZRepresenter runtimeValueFromRepresentationValue:representationValue];
    }
    
    ERLog(@"runtimeValue %@", runtimeValue);
    
    return runtimeValue;
    
}

#pragma mark - Property names

-(NSArray*)propertyNames
{ return [self.class propertyNamesOfObject:self]; }

+(NSArray*)propertyNamesOfObject:(NSObject*) object
{ return [self propertyNamesOfClass:object.class]; }

+(NSArray*)propertyNamesOfClass:(Class) class
{ _LOG
    
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
{ _LOG
    
    //Default behaviour is collect every property.
    return nil;
}

+(NSArray*)collectRepresentablePropertyNames
{ _LOG
    
    //User-defined property names if any.
    if ([self respondsToSelector:@selector(representablePropertyNames)])
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
