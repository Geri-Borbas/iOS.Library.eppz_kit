//
//  EPPZUserDefault.m
//  eppz!tools
//
//  Created by Borbás Geri on 7/11/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZUserDefaults.h"


@interface EPPZUserDefaults ()
@property (nonatomic, weak) NSUserDefaults *userDefaults;
@property (nonatomic, strong, readonly) NSArray *propertyNames;
@property (nonatomic) BOOL saveOnEveryChange;
@end


@implementation EPPZUserDefaults


#pragma mark - Creation

-(id)init
{
    if (self = [super init])
    {        
        //Aliasing sugar.
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        
        //Register defaults.
        NSString *defaultsPlistPath = [[NSBundle mainBundle] pathForResource:self.className ofType:@"plist"];
        NSDictionary *defaultProperties = [NSDictionary dictionaryWithContentsOfFile:defaultsPlistPath];
        NSDictionary *defaults = (defaultProperties != nil) ? @{ self.className : defaultProperties } : nil;
        [self.userDefaults registerDefaults:defaults];
        
        //Populate properties.
        [self load];
        
        //Turn on saving.
        [self observePersistableProperties];
        self.saveOnEveryChange = YES;
    }
    return self;
}

-(void)dealloc
{
    //Tear down observers.
    [self finishObservingPersistableProperties];
}


#pragma mark - Archiving

+(NSString*)name { return NSStringFromClass(self); }
-(NSString*)className { return [self.class name]; }
-(NSString*)prefixedKeyForKey:(NSString*) key { return [NSString stringWithFormat:@"%@.%@", self.className, key]; }

-(void)load
{
    for (NSString *eachPropertyName in [self.class persistablePropertyNames])
    {
        //Get value (from NSUserDefaults dictionary).
        id value = [self.userDefaults valueForKeyPath:[self prefixedKeyForKey:eachPropertyName]];
        
        //Set property safely.
        @try { [self setValue:value forKey:eachPropertyName]; }
        @catch (NSException *exception) { }
        @finally { }
    }
}

-(void)observeValueForKeyPath:(NSString*) keyPath ofObject:(id)object change:(NSDictionary*) change context:(void*) context
{
    //Save to store if asked to (if need to represent at all).
    id value = [change objectForKey:NSKeyValueChangeNewKey];
    if (self.saveOnEveryChange)
        if (value != nil)
            if ([[self.class persistablePropertyNames] containsObject:keyPath])
            {
                //Set value (to NSUserDefaults).
                NSMutableDictionary *dictionaryRepresentation = [[self.userDefaults objectForKey:self.className] mutableCopy];
                if (dictionaryRepresentation == nil) dictionaryRepresentation = [NSMutableDictionary new];
                [dictionaryRepresentation setObject:value forKey:keyPath];
                [self.userDefaults setObject:dictionaryRepresentation forKey:self.className];
                
                //Syncronize.
                [self.userDefaults synchronize];
            }
}


#pragma mark - Observe propery changes

-(void)observePersistableProperties
{
    for (NSString *eachPropertyName in [self.class persistablePropertyNames])
        [self addObserver:self forKeyPath:eachPropertyName options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

-(void)finishObservingPersistableProperties
{
    for (NSString *eachPropertyName in [self.class persistablePropertyNames])
        [self removeObserver:self forKeyPath:eachPropertyName];
}


#pragma mark - Properties to represent

+(NSArray*)persistablePropertyNames { return self.propertyNames; }

+(NSArray*)propertyNames
{ return [self propertyNamesOfClass:self]; }

+(NSArray*)propertyNamesOfClass:(Class) class
{
    NSMutableArray *propertyNamesArray = [NSMutableArray new];
    
    NSUInteger propertyCount;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    
    for (int index = 0; index < propertyCount; index++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[index])];
        [propertyNamesArray addObject:key];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:propertyNamesArray];
}


@end
