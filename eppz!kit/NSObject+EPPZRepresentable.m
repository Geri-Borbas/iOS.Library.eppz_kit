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


//Temporary object pools Keyed by top-level objects representableId.
__strong static NSMutableDictionary *__objectPools;


static NSString *const kEPPZRepresentableIDKey = @"__eppz.representable.id";
static NSString *const kEPPZRepresentableClassKey = @"__eppz.representable.class";


@interface NSObject (EPPZRepresentable_private)

@property (nonatomic, readonly) NSString *representableID;

-(NSArray*)propertyNames;
+(NSArray*)propertyNamesOfObject:(NSObject*) object;
+(NSArray*)propertyNamesOfClass:(Class) class;
+(NSArray*)collectRepresentablePropertyNames;

+(NSMutableDictionary*)objectPools;
+(NSMutableDictionary*)objectPoolForRepresentable:(NSObject*) representable;
+(NSMutableDictionary*)addObjectPoolForRepresentable:(NSObject*) representable;
+(NSMutableDictionary*)addObjectPoolForRepresentableID:(NSString*) representableID;
+(void)removeObjectPoolForRepresentable:(NSObject*) representable;
+(void)removeObjectPoolForRepresentableID:(NSString*) representableID;
+(void)addRepresentable:(NSObject<EPPZRepresentable>*) representable toPool:(NSMutableDictionary*) objectPool;
+(BOOL)objectPool:(NSMutableDictionary*) objectPool hasRepresentable:(NSObject*) representable;

-(NSDictionary*)dictionaryRepresentationWithObjectPool:(NSMutableDictionary*) objectPool;
+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation objectPool:(NSMutableDictionary*) objectPool;

@end


@implementation NSObject (EPPZRepresentable)


#pragma mark - Subclass templates

-(void)willStore { }
-(void)willLoad { }
-(void)didLoad { }


#pragma mark - Feature management

+(BOOL)isRepresentableClass { return [self conformsToProtocol:@protocol(EPPZRepresentable)]; }
-(BOOL)isRepresentableObject { return [self.class conformsToProtocol:@protocol(EPPZRepresentable)]; }


#pragma mark - Object pools (track references)

-(NSString*)representableID
{ return @(self.hash).stringValue; }

+(NSMutableDictionary*)objectPools
{
    //Lazy.
    if (__objectPools == nil)
    { __objectPools = [NSMutableDictionary new]; }
    return __objectPools;
}

+(NSMutableDictionary*)objectPoolForRepresentable:(NSObject*) representable
{
    if ([[[self objectPools] allKeys] containsObject:representable.representableID])
    { return [[self objectPools] objectForKey:representable.representableID]; }
    return nil;
}

+(NSMutableDictionary*)addObjectPoolForRepresentable:(NSObject*) representable
{ return [self addObjectPoolForRepresentableID:representable.representableID]; }

+(NSMutableDictionary*)addObjectPoolForRepresentableID:(NSString*) representableID
{
    if ([[[self objectPools] allKeys] containsObject:representableID] == NO)
    {
        NSMutableDictionary *objectPool = [NSMutableDictionary new];
        [[self objectPools] setObject:objectPool forKey:representableID];
        return objectPool;
    }
    return nil;
}

+(void)removeObjectPoolForRepresentable:(NSObject*) representable
{ [self removeObjectPoolForRepresentableID:representable.representableID]; }

+(void)removeObjectPoolForRepresentableID:(NSString*) representableID
{
    if ([[[self objectPools] allKeys] containsObject:representableID])
    { [[self objectPools] removeObjectForKey:representableID]; }
}

+(void)addRepresentable:(NSObject<EPPZRepresentable>*) representable toPool:(NSMutableDictionary*) objectPool
{ [self addRepresentable:representable forID:representable.representableID toPool:objectPool]; }

+(void)addRepresentable:(NSObject<EPPZRepresentable>*) representable forID:(NSString*) representableID toPool:(NSMutableDictionary*) objectPool
{
    if ([[objectPool allKeys] containsObject:representableID] == NO)
        [objectPool setObject:representable forKey:representableID];
}

+(BOOL)objectPool:(NSMutableDictionary*) objectPool hasRepresentable:(NSObject<EPPZRepresentable>*) representable
{ return [self objectPool:objectPool hasRepresentableID:representable.representableID]; }

+(BOOL)objectPool:(NSMutableDictionary*) objectPool hasRepresentableID:(NSString*) representableID
{ return [[objectPool allKeys] containsObject:representableID]; }


#pragma mark - Represent

-(NSDictionary*)dictionaryRepresentation
{
    //Subclass template.    
    [self willStore];
    
    //Top-level dictionary.
    NSDictionary *dictionaryRepresentation = [self dictionaryRepresentationWithObjectPool:nil];
    
    //Release representations in pool after process.
    [NSObject removeObjectPoolForRepresentable:self];
    
    return dictionaryRepresentation;
}

-(NSDictionary*)dictionaryRepresentationWithObjectPool:(NSMutableDictionary*) objectPool
{
    ERLog(@"EPPZRepresentable dictionaryRepresentation '%@'", NSStringFromClass(self.class));
    
    //Collection.
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary new];
    
    // Representable properties.
    
        //__eppz.representable.class.
        [dictionaryRepresentation setObject:NSStringFromClass([self class]) forKey:kEPPZRepresentableClassKey];
    
        //__eppz.representable.id.
        [dictionaryRepresentation setObject:@(self.hash).stringValue forKey:kEPPZRepresentableIDKey];
    
    // Ensure to represent references only once.
    
        BOOL isTopLevelObject = (objectPool == nil);    
        if (isTopLevelObject)
        {
            //Create object pool (assuming this object is the top-level object).
            objectPool = [NSObject addObjectPoolForRepresentable:self];
        }
        
        else
        {
            //Store only __eppz.representable.id if already represented in this run.
            if ([NSObject objectPool:objectPool hasRepresentable:self])
            {
                //Return dictionary we have so far (without the values).
                return [NSDictionary dictionaryWithDictionary:dictionaryRepresentation];
            }
        }
    
    // Track that this object is being represented already.
    
        [NSObject addRepresentable:(NSObject<EPPZRepresentable>*)self toPool:objectPool];
    
    // Collect represented values.
    
        ERLog(@"EPPZRepresentable collectRepresentablePropertyNames of '%@' %@", NSStringFromClass(self.class), [self.class collectRepresentablePropertyNames]);
    
        for (NSString *eachPropertyName in [self.class collectRepresentablePropertyNames])
        {
            id representedProperty = [self representationValueForPropertyName:eachPropertyName
                                                     objectPool:objectPool];
            
            // Catch errors.
            if (representedProperty == nil) { [EPPZRepresentableException object:self couldNotRepresentPropertyNamed:eachPropertyName]; }
            
            // Collect.
            [dictionaryRepresentation setObject:representedProperty forKey:eachPropertyName];
        }
    
    //Return immutable.
    return [NSDictionary dictionaryWithDictionary:dictionaryRepresentation];
}

-(id)representationValueForPropertyName:(NSString*) propertyName objectPool:(NSMutableDictionary*) objectPool
{
    // Get the actual (runtime) value for this key.
    
        id runtimeValue;
        @try { runtimeValue = [self valueForKeyPath:propertyName]; }
        @catch (NSException *exception)
        {
            [[EPPZRepresentableException object:self hasNoSuchPropertyNamed:propertyName] raise];
        }
    
        ERLog(@"EPPZRepresentable represent '%@.%@'...", NSStringFromClass(self.class), propertyName);
        
    // EPPZRepresentable .
    
        if ([runtimeValue conformsToProtocol:@protocol(EPPZRepresentable)])
        {
            NSObject <EPPZRepresentable> *runtimeRepresentable = (NSObject<EPPZRepresentable>*)runtimeValue;
            ERLog(@"...an EPPZRepresentable.");
            
            // Represent.
            NSDictionary *dictionaryRepresentation = [runtimeRepresentable dictionaryRepresentationWithObjectPool:objectPool];
            
            return dictionaryRepresentation;
        }
    
    // NSArray
    
        else if ([runtimeValue isKindOfClass:[NSArray class]])
        {
            NSArray *runtimeArray = (NSArray*)runtimeValue;
            ERLog(@"...an NSArray.");
            
            NSMutableArray *representationArray = [NSMutableArray new];
            
            // Enumerate members.
            [runtimeArray enumerateObjectsUsingBlock:^(id eachRuntimeMember, NSUInteger index, BOOL *stop)
            {
                // Represent each.
                id eachRepresentationMember = [eachRuntimeMember dictionaryRepresentationWithObjectPool:objectPool];
                [representationArray addObject:eachRepresentationMember];
            }];
            
            return representationArray;
        }
    
    // NSDictionary
    
        else if ([runtimeValue isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *runtimeDictionary = (NSDictionary*)runtimeValue;
            ERLog(@"...an NSDictionary.");
            
            NSMutableDictionary *representationDictionary = [NSMutableDictionary new];
            
            // Enumerate members.
            [runtimeDictionary enumerateKeysAndObjectsUsingBlock:^(id eachKey, id eachRuntimeMember, BOOL *stop)
            {
                // Represent each.
                id eachRepresentationMember = [eachRuntimeMember dictionaryRepresentationWithObjectPool:objectPool];
                [representationDictionary setObject:eachRepresentationMember forKey:eachKey];
            }];
            
            return representationDictionary;
        }
    
    // Unknown NSObject
    
        else if ([runtimeValue isKindOfClass:[NSObject class]])
        {
            NSObject *runtimeObject = (NSObject*)runtimeValue;
            ERLog(@"...an unknown NSObject <%@>.", NSStringFromClass(runtimeObject.class));
            
            NSObject <EPPZRepresentable> *runtimeRepresentable = (NSObject<EPPZRepresentable>*)runtimeObject;
            
            // Represent.
            NSDictionary *dictionaryRepresentation = [runtimeRepresentable dictionaryRepresentationWithObjectPool:objectPool];
            
            return dictionaryRepresentation;
            
        }
    
    // The rest of the types goes trough representer.
    return [EPPZRepresenter representationValueFromRuntimeValue:runtimeValue];
}


#pragma mark - Reconstruction

+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation
{
    //Reconstruct.
    id representable = [self representableWithDictionaryRepresentation:dictionaryRepresentation objectPool:nil];

    //Flush temporary object pool.
    NSString *representableID = [dictionaryRepresentation objectForKey:kEPPZRepresentableIDKey];
    [NSObject removeObjectPoolForRepresentableID:representableID];
    
    return representable;
}

+(id)representableWithDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation objectPool:(NSMutableDictionary*) objectPool
{ _LOG
    
    //Get representable properties.
    
        //Determine class.
        NSString *className = [dictionaryRepresentation objectForKey:kEPPZRepresentableClassKey];
        Class class = NSClassFromString(className);
    
        //No such class.
        if (class == nil) return nil;
    
        //Get ID.
        NSString *representableID = [dictionaryRepresentation objectForKey:kEPPZRepresentableIDKey];
    
    //If reconstructed already, return object reference, else allocate a new.
    
        NSObject <EPPZRepresentable> *instance;
    
        BOOL isTopLevelObject = (objectPool == nil);
        if (isTopLevelObject)
        {
            //Create object pool (assuming this object is the top-level object).
            objectPool = [NSObject addObjectPoolForRepresentableID:representableID];
            
            //Create a new instance (for top-level object).
            instance = [class new];
        }
        
        else
        {
            //Store only __eppz.representable.id if already represented in this run.
            if ([NSObject objectPool:objectPool hasRepresentableID:representableID])
            {
                //Return the representable we have so far.
                instance = [objectPool objectForKey:representableID];
            }
            
            else
            {
                //Or go on with allocate a new instance.
                instance = [class new];
            }
        }
    
    //Subclass template.
    [instance willLoad];
    
    //Set values.
    for (NSString *eachPropertyName in dictionaryRepresentation.allKeys)
    {
        //Exclude class name.
        if ([eachPropertyName isEqualToString:kEPPZRepresentableClassKey]) continue;
        
        //Get value.
        id eachRepresentationValue = [dictionaryRepresentation valueForKey:eachPropertyName];
        
        //Create runtime value.
        id runtimeValue = [self runtimeValueFromRepresentationValue:eachRepresentationValue objectPool:objectPool];
        
        //Try to set.
        @try { [instance setValue:runtimeValue forKeyPath:eachPropertyName]; }
        @catch (NSException *exception) { }
        @finally { }
    }
    
    //Subclass template.
    [instance didLoad];
    
    return instance;
}

-(id)runtimeValueFromRepresentationValue:(id) representationValue objectPool:(NSMutableDictionary*) objectPool
{ _LOG
    
    id runtimeValue;
    
    //Look for <EPPZRepresentable> or NSDictionary
    if ([representationValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *representationValueDictionary = (NSDictionary*)representationValue;
        Class class = class = [NSDictionary class];
        
        //Create custom class if present.
        if ([[representationValueDictionary allKeys] containsObject:kEPPZRepresentableClassKey])
        {
            NSString *className = [representationValueDictionary objectForKey:kEPPZRepresentableClassKey];
            class = NSClassFromString(className);
        }
        
        //Create representable.
        runtimeValue = [class representableWithDictionaryRepresentation:representationValueDictionary objectPool:objectPool];
        
        //Track that this object have reconstructed already (with the stored ID).
        [NSObject addRepresentable:runtimeValue
                             forID:[representationValueDictionary objectForKey:kEPPZRepresentableIDKey]
                            toPool:objectPool];
    }
    
    //Simply return arbitrary value.
    else
    {
        runtimeValue = [EPPZRepresenter runtimeValueFromRepresentationValue:representationValue];
    }
    
    return runtimeValue;
    
}

#pragma mark - Property names

-(NSArray*)propertyNames
{ return [self.class propertyNamesOfObject:self]; }

+(NSArray*)propertyNamesOfObject:(NSObject*) object
{ return [self propertyNamesOfClass:object.class]; }

+(NSArray*)propertyNamesOfClass:(Class) class
{
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