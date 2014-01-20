//
//  EPPZPropertyMapper.m
//  Totoya parenting
//
//  Created by Carnation on 20/01/14.
//  Copyright (c) 2014 Pangalaktik. All rights reserved.
//

#import "EPPZPropertySynchronizator.h"


@interface EPPZPropertySynchronizator ()

@property (nonatomic, weak) NSObject *one;
@property (nonatomic, weak) NSObject *other;
@property (nonatomic, weak) NSDictionary *otherKeyPathsForOneKeyPaths;
@property (nonatomic, weak) NSDictionary *oneKeyPathsForOtherKeyPaths;

@end


@implementation EPPZPropertySynchronizator


#pragma mark - Creation

+(id)mapperWithInstance:(NSObject*) one
               instance:(NSObject*) other
            propertyMap:(NSDictionary*) propertyMap
{ return [[self alloc] initWithInstance:one instance:other propertyMap:propertyMap]; }

-(id)initWithInstance:(NSObject*) one
             instance:(NSObject*) other
          propertyMap:(NSDictionary*) propertyMap
{
    if (self = [super init])
    {
        self.one = one;
        self.other = other;
        self.otherKeyPathsForOneKeyPaths = propertyMap;
        self.oneKeyPathsForOtherKeyPaths = [propertyMap dictionaryBySwappingKeysAndValues];
        [self setupInstanceObservers];
    }
    return self;
}


#pragma mark - KeyPath mapping

-(NSString*)otherKeyPathForOneKeypath:(NSString*) oneKeyPath
{
    if (oneKeyPath == nil) return nil;
    if ([[self.otherKeyPathsForOneKeyPaths allKeys] containsObject:oneKeyPath] == NO) return nil;
    return [self.otherKeyPathsForOneKeyPaths objectForKey:oneKeyPath];
}

-(NSString*)oneKeyPathForOtherKeypath:(NSString*) otherKeyPath
{
    if (otherKeyPath == nil) return nil;
    if ([[self.oneKeyPathsForOtherKeyPaths allKeys] containsObject:otherKeyPath] == NO) return nil;
    return [self.oneKeyPathsForOtherKeyPaths objectForKey:otherKeyPath];
}


#pragma mark - Observe / sync

-(void)setupInstanceObservers
{
    // Observe one.
    [[self.otherKeyPathsForOneKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.one addObserver:self
                   forKeyPath:eachKeyPath
                      options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                      context:NULL];
    }];
    
    // Observe other.
    [[self.oneKeyPathsForOtherKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.other addObserver:self
                     forKeyPath:eachKeyPath
                        options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                        context:NULL];
    }];
}

-(void)tearDownInstanceObservers
{
    // Observe one.
    [[self.otherKeyPathsForOneKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    { [self.one removeObserver:self forKeyPath:eachKeyPath]; }];
    
    // Observe other.
    [[self.oneKeyPathsForOtherKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    { [self.other removeObserver:self forKeyPath:eachKeyPath]; }];
}

-(void)dealloc
{ [self tearDownInstanceObservers]; }

-(void)observeValueForKeyPath:(NSString*) keyPath
                     ofObject:(id) object
                       change:(NSDictionary*) change
                      context:(void*) context
{
    id value = [change objectForKey:NSKeyValueChangeNewKey];
    
    BOOL forward = (object == self.one);
    if (forward)
    {
        // Get keyPath.
        NSString *otherKeyPath = [self otherKeyPathForOneKeypath:keyPath];
        
        // Set value on other.
        @try { [self.other setValue:value forKey:otherKeyPath]; }
        @catch (NSException *exception) { }
        @finally { }
    }
    else
    {
        // Get keyPath.
        NSString *oneKeyPath = [self oneKeyPathForOtherKeypath:keyPath];
        
        // Set value on other.
        @try { [self.one setValue:value forKey:oneKeyPath]; }
        @catch (NSException *exception) { }
        @finally { }
    }
}


@end
