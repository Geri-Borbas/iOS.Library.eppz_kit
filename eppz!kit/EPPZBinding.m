//
//  EPPZPropertyMapper.m
//  eppz!kit
//
//  Created by Borbás Geri on 20/01/14.
//  Copyright (c) 2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZBinding.h"


@interface EPPZBinding ()

@property (nonatomic, strong) NSDictionary *otherKeyPathsForOneKeyPaths;
@property (nonatomic, strong) NSDictionary *oneKeyPathsForOtherKeyPaths;

@end


@implementation EPPZBinding


#pragma mark - Creation

+(id)bindObject:(NSObject*) one
     withObject:(NSObject*) other
    propertyMap:(NSDictionary*) propertyMap
{ return [[self alloc] initWithObject:one object:other propertyMap:propertyMap]; }

-(id)initWithObject:(NSObject*) one
             object:(NSObject*) other
        propertyMap:(NSDictionary*) propertyMap
{
    if (self = [super init])
    {
        self.one = one;
        self.other = other;
        self.otherKeyPathsForOneKeyPaths = propertyMap;
        self.oneKeyPathsForOtherKeyPaths = [propertyMap dictionaryBySwappingKeysAndValues];
        [self setupObservers];
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

-(void)setupObservers
{
    // Observe one.
    [[self.otherKeyPathsForOneKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.one addObserver:self
                   forKeyPath:eachKeyPath
                      options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                      context:NULL];
    }];
    
    [self.one addObserver:self
               forKeyPath:@"dealloc"
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                  context:NULL];
    
    // Observe other.
    [[self.oneKeyPathsForOtherKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.other addObserver:self
                     forKeyPath:eachKeyPath
                        options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                        context:NULL];
    }];
}

-(void)tearDownObservers
{
    // Observe one.
    [[self.otherKeyPathsForOneKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    { [self.one removeObserver:self forKeyPath:eachKeyPath]; }];
    
    // Observe other.
    [[self.oneKeyPathsForOtherKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    { [self.other removeObserver:self forKeyPath:eachKeyPath]; }];
}

-(void)dealloc
{ [self tearDownObservers]; }

-(void)setOne:(NSObject*) one
{
    _one = one;
    [self tearDownObservers];
    [self setupObservers];
}

-(void)setOther:(NSObject*) other
{
    _other = other;
    [self tearDownObservers];
    [self setupObservers];
}

-(void)observeValueForKeyPath:(NSString*) keyPath
                     ofObject:(id) object
                       change:(NSDictionary*) change
                      context:(void*) context
{
    NSLog(@"Observe %@", keyPath);
    
    id value = [change objectForKey:NSKeyValueChangeNewKey];
    
    static NSString *skipOneKeyPath = nil;
    static NSString *skipOtherKeyPath = nil;
    
    BOOL forward = (object == self.one);
    
    // One.
    if (forward)
    {
        // Skip if set during a synchronizing set.
        if ([keyPath isEqualToString:skipOneKeyPath])
        {
            skipOneKeyPath = nil;
            return;
        }
        
        // Get keyPath.
        NSString *otherKeyPath = [self otherKeyPathForOneKeypath:keyPath];
        
        // Set value on other.
        skipOtherKeyPath = otherKeyPath; // Skip this set.
        @try { [self.other setValue:value forKey:otherKeyPath]; }
        @catch (NSException *exception) { }
        @finally { }
    }
    
    // Other.
    else
    {
        // Skip if set during a synchronizing set.
        if ([keyPath isEqualToString:skipOtherKeyPath])
        {
            skipOtherKeyPath = nil;
            return;
        }
        
        // Get keyPath.
        NSString *oneKeyPath = [self oneKeyPathForOtherKeypath:keyPath];
        
        // Set value on one.
        skipOneKeyPath = keyPath; // Skip this set.
        @try { [self.one setValue:value forKey:oneKeyPath]; }
        @catch (NSException *exception) { }
        @finally { }
    }
}


@end
