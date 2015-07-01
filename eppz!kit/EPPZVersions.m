//
//  EPPZFeatureManager.m
//  eppz!kit
//
//  Created by Borbás Geri on 12/14/12.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZVersions.h"


static NSString *kInstalledBundleVersionsKey = @"__eppz.installedBundleVersions";
static NSString *kLaunchedBundleVersionsKey = @"__eppz.launchedBundleVersions";
static NSString *kLaunchCountKey = @"__eppz.launchCount";



@interface EPPZVersions()

@property (nonatomic, readonly) NSString *bundleVersion;

@property (nonatomic, readonly) NSArray *installedBundleVersions;
@property (nonatomic, readonly) NSArray *launchedBundleVersions;

-(BOOL)isFirstRunForVersion:(NSString*) versionString;
@end



@implementation EPPZVersions


-(id)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)takeOff
{
    [self pushInstalledBundleVersion:self.bundleVersion];
    [self checkFeatures];
}

-(void)checkFeatures { /* Subclass template */ };

-(void)applicationDidFinishLaunching
{ [self incrementLaunchCount]; }

-(void)applicationWillEnterForeground
{ [self incrementLaunchCount]; }

-(void)applicationDidEnterBackground
{ [self markFirstRunIfNeeded]; }

-(void)markFirstRunIfNeeded
{ [self pushLaunchedBundleVersion:self.bundleVersion]; }

#pragma mark - Installed versions

-(NSString*)bundleVersion
{ return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; }

-(NSArray*)installedBundleVersions
{
    NSArray *installedBundleVersions = [self.userDefaults arrayForKey:kInstalledBundleVersionsKey];
    if (installedBundleVersions == nil) installedBundleVersions = [NSArray new];
    return installedBundleVersions;
}

-(void)pushInstalledBundleVersion:(NSString*) bundleVersionString
{
    if (bundleVersionString != nil)
    {
        NSArray* installedVersions = self.installedBundleVersions;
        if ([installedVersions containsObject:bundleVersionString] == NO)
        {        
            NSMutableArray *mutableInstalledBundleVersions = [NSMutableArray arrayWithArray:installedVersions];
            [mutableInstalledBundleVersions addObject:bundleVersionString];
            
            [self.userDefaults setObject:mutableInstalledBundleVersions forKey:kInstalledBundleVersionsKey];
            [self.userDefaults synchronize];
        }
    }
}


#pragma mark - Launched versions

-(NSArray*)launchedBundleVersions
{
    NSArray *launchedBundleVersions = [self.userDefaults arrayForKey:kLaunchedBundleVersionsKey];
    if (launchedBundleVersions == nil) launchedBundleVersions = [NSArray new];
    return launchedBundleVersions;
}

-(void)pushLaunchedBundleVersion:(NSString*) bundleVersionString
{
    if (bundleVersionString != nil)
    {
        NSArray* launchedVersions = self.launchedBundleVersions;
        if ([launchedVersions containsObject:bundleVersionString] == NO)
        {
            NSMutableArray *mutableLaunchedBundleVersions = [NSMutableArray arrayWithArray:launchedVersions];
            [mutableLaunchedBundleVersions addObject:bundleVersionString];
            
            [self.userDefaults setObject:mutableLaunchedBundleVersions forKey:kLaunchedBundleVersionsKey];
            [self.userDefaults synchronize];
        }
    }
}


#pragma mark - App environment

-(BOOL)isFirstRun
{ return (self.launchedBundleVersions.count == 0); }

-(BOOL)isFirstRunCurrentVersion
{ return [self isFirstRunForVersion:self.bundleVersion]; }

-(BOOL)isFirstRunForVersion:(NSString*) versionString
{ return ([self.launchedBundleVersions containsObject:versionString] == NO); }

-(BOOL)isBrandNewInstall
{ return (self.installedBundleVersions.count == 1); }

-(BOOL)hasPreviousBundleVersionInstalled
{ return (self.installedBundleVersions.count > 1); }

-(BOOL)hasBundleVersionEverInstalled:(NSString*) versionString
{ return [self.installedBundleVersions containsObject:versionString]; }


#pragma mark - Launch counter

-(NSString*)sessionNumber
{
    NSString *sessionNumber = [NSString stringWithFormat:@"%li", (long)[[self.userDefaults objectForKey:kLaunchCountKey] integerValue]];
    if (sessionNumber) return sessionNumber;
    return @"0";
}

-(NSInteger)launchCount
{ return [[self.userDefaults objectForKey:kLaunchCountKey] integerValue]; }

-(void)incrementLaunchCount
{
    NSNumber *launchCount = [self.userDefaults objectForKey:kLaunchCountKey];
    int launchCountInteger = (int)launchCount.integerValue + 1;
    [self.userDefaults setObject:[NSNumber numberWithInteger:launchCountInteger] forKey:kLaunchCountKey];
    [self.userDefaults synchronize];
}


@end
