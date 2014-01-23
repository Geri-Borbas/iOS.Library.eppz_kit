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

@property (nonatomic) BOOL leftIsObserved;
@property (nonatomic) BOOL rightIsObserved;

@property (nonatomic, strong) NSDictionary *rightKeyPathsForLeftKeyPaths;
@property (nonatomic, strong) NSDictionary *leftKeyPathsForRightKeyPaths;

@property (nonatomic, strong) NSDictionary *leftFormattersForLeftKeyPaths;
@property (nonatomic, strong) NSDictionary *rightFormattersForRightKeyPaths;

@end


@implementation EPPZBinding


#pragma mark - Creation

+(id)bindObject:(NSObject*) left
     withObject:(NSObject*) right
    propertyMap:(NSDictionary*) propertyMap
{ return [self bindObject:left withObject:right propertyMap:propertyMap leftFormatters:nil rightFormatters:nil]; }

+(id)bindObject:(NSObject*) left
     withObject:(NSObject*) right
    propertyMap:(NSDictionary*) propertyMap
 leftFormatters:(NSDictionary*) leftFormatters
rightFormatters:(NSDictionary*) rightFormatters
{ return [[self alloc] initWithLeft:left right:right propertyMap:propertyMap leftFormatters:leftFormatters rightFormatters:rightFormatters]; }

-(id)initWithLeft:(NSObject*) left
            right:(NSObject*) right
      propertyMap:(NSDictionary*) propertyMap
   leftFormatters:(NSDictionary*) leftFormatters
  rightFormatters:(NSDictionary*) rightFormatters
{
    if (self = [super init])
    {
        self.left = left;
        self.right = right;
        
        self.rightKeyPathsForLeftKeyPaths = propertyMap;
        self.leftKeyPathsForRightKeyPaths = [propertyMap dictionaryBySwappingKeysAndValues];
        
        self.leftFormattersForLeftKeyPaths = leftFormatters;
        self.rightFormattersForRightKeyPaths = rightFormatters;
        
        [self setupObservers];
    }
    return self;
}


#pragma mark - KeyPath mapping

-(NSString*)rightKeyPathForLeftKeypath:(NSString*) oneKeyPath
{
    if (oneKeyPath == nil) return nil;
    if ([[self.rightKeyPathsForLeftKeyPaths allKeys] containsObject:oneKeyPath] == NO) return nil;
    return [self.rightKeyPathsForLeftKeyPaths objectForKey:oneKeyPath];
}

-(NSString*)leftKeyPathForRightKeypath:(NSString*) otherKeyPath
{
    if (otherKeyPath == nil) return nil;
    if ([[self.leftKeyPathsForRightKeyPaths allKeys] containsObject:otherKeyPath] == NO) return nil;
    return [self.leftKeyPathsForRightKeyPaths objectForKey:otherKeyPath];
}


#pragma mark - Value formatting

-(id)rightValueForKeyPath:(NSString*) keyPath leftValue:(id) leftValue
{
    // Default.
    id rightValue = leftValue;
    
    // Look for formatter.
    EPPZBindingRightValueFormatterBlock formatterBlock;
    if (self.rightFormattersForRightKeyPaths != nil)
        if ([[self.rightFormattersForRightKeyPaths allKeys] containsObject:keyPath])
        {
            // Get formatted value.
            formatterBlock = [self.rightFormattersForRightKeyPaths objectForKey:keyPath];
            rightValue = formatterBlock(leftValue);
        }
    
    // Spit out.
    return rightValue;
}

-(id)leftValueForKeyPath:(NSString*) keyPath rightValue:(id) rightValue
{
    // Default.
    id leftValue = rightValue;
    
    // Look for formatter.
    EPPZBindingLeftValueFormatterBlock formatterBlock;
    if (self.leftFormattersForLeftKeyPaths != nil)
        if ([[self.leftFormattersForLeftKeyPaths allKeys] containsObject:keyPath])
        {
            // Get formatted value.
            formatterBlock = [self.leftFormattersForLeftKeyPaths objectForKey:keyPath];
            leftValue = formatterBlock(rightValue);
        }
    
    // Spit out.
    return leftValue;
}


#pragma mark - Observers

-(void)setupObservers
{
    // Observe left.
    [[self.rightKeyPathsForLeftKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.left addObserver:self
                    forKeyPath:eachKeyPath
                       options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                       context:NULL];
    }];

    self.leftIsObserved = YES; // Flag.
    
    // Observe right.
    [[self.leftKeyPathsForRightKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
    {
        [self.right addObserver:self
                     forKeyPath:eachKeyPath
                        options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                        context:NULL];
    }];
    
    self.rightIsObserved = YES; // Flag.
}

-(void)tearDownObservers
{
    // Remove observers for left if any.
    if (self.leftIsObserved)
    {
        [[self.rightKeyPathsForLeftKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
        { [self.left removeObserver:self forKeyPath:eachKeyPath]; }];
        self.leftIsObserved = NO;
    }
    
    // Remove osbservers for right if any.
    if (self.rightIsObserved)
    {
        [[self.leftKeyPathsForRightKeyPaths allKeys] enumerateObjectsUsingBlock:^(id eachKeyPath, NSUInteger index, BOOL *stop)
        { [self.right removeObserver:self forKeyPath:eachKeyPath]; }];
        self.rightIsObserved = NO;
    }
}

-(void)dealloc
{ [self tearDownObservers]; }


#pragma mark - Target object setters

-(void)setLeft:(NSObject*) left
{
    [self tearDownObservers];
    _left = left;
    [self updateRight];
    [self setupObservers];
}

-(void)setRight:(NSObject*) right
{
    [self tearDownObservers];
    _right = right;
    [self updateLeft];
    [self setupObservers];
}


#pragma mark - Bindings

-(void)observeValueForKeyPath:(NSString*) keyPath
                     ofObject:(id) object
                       change:(NSDictionary*) change
                      context:(void*) context
{    
    id value = [change objectForKey:NSKeyValueChangeNewKey];
    
    // Work around redundant (endless) settings with these flags.
    static NSString *skipLeftKeyPath = nil;
    static NSString *skipRightKeyPath = nil;
    
    BOOL leftChanged = (object == self.left);
    
    // Left changed, set right.
    if (leftChanged)
    {
        // Skip if set during a synchronizing set.
        if ([keyPath isEqualToString:skipLeftKeyPath])
        {
            skipLeftKeyPath = nil;
            return;
        }
        
        // Get keyPath.
        NSString *rightKeyPath = [self rightKeyPathForLeftKeypath:keyPath];
        
        // Get value.
        id rightValue = [self rightValueForKeyPath:rightKeyPath leftValue:value];
        
        // Set value on other.
        skipRightKeyPath = rightKeyPath; // Skip this set.
        @try
        {
            dispatch_async(dispatch_get_main_queue(),^
            {
                EBLog(@"Set <%@> on right `%@` for `%@`", rightValue, self.right, rightKeyPath);
                [self.right setValue:rightValue forKeyPath:rightKeyPath];
            });
        }
        @catch (NSException *exception) { }
        @finally { }
    }
    
    // Right changed, set left.
    else
    {
        // Skip if set during a synchronizing set.
        if ([keyPath isEqualToString:skipRightKeyPath])
        {
            skipRightKeyPath = nil;
            return;
        }
        
        // Get keyPath.
        NSString *leftKeyPath = [self leftKeyPathForRightKeypath:keyPath];
        
        // Get value.
        id leftValue = [self leftValueForKeyPath:leftKeyPath rightValue:value];
        
        // Set value on left.
        skipLeftKeyPath = keyPath; // Skip this set.
        @try
        {
            dispatch_async(dispatch_get_main_queue(),^
            {
                EBLog(@"Set <%@> on left `%@` for `%@`", leftValue, self.left, leftKeyPath);
                [self.left setValue:leftValue forKeyPath:leftKeyPath];
            });
        }
        @catch (NSException *exception) { }
        @finally { }
    }
}

-(void)updateLeft
{
    [self.leftKeyPathsForRightKeyPaths enumerateKeysAndObjectsUsingBlock:^(id rightKeyPath, id leftKeyPath, BOOL *stop)
    {
        id rightValue = [self.right valueForKeyPath:rightKeyPath];
        @try
        {
            dispatch_async(dispatch_get_main_queue(),^
            { [self.left setValue:rightValue forKeyPath:leftKeyPath]; });
        }
        @catch (NSException *exception) { }
        @finally { }
    }];
}

-(void)updateRight
{
    [self.rightKeyPathsForLeftKeyPaths enumerateKeysAndObjectsUsingBlock:^(id leftKeyPath, id rightKeyPath, BOOL *stop)
    {
        id leftValue = [self.left valueForKeyPath:leftKeyPath];
        @try
        {
            dispatch_async(dispatch_get_main_queue(),^
            { [self.right setValue:leftValue forKeyPath:rightKeyPath]; });
        }
        @catch (NSException *exception) { }
        @finally { }
    }];
}


@end
