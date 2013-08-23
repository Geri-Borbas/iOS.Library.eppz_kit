//
//  EPPZReachability.m
//  eppz!reachability
//
//  Created by Borbás Geri on 6/16/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZReachability.h"
#import <netinet/in.h>
#import <arpa/inet.h>


typedef void (^EPPZReachCompletitionBlock)();


@interface EPPZReachability ()

@property (nonatomic, weak) id <EPPZReachabilityDelegate> delegate;
@property (nonatomic) SCNetworkReachabilityRef reachabilityRef;
@property (nonatomic, strong) EPPZReachabilityCompletitionBlock completition;

+(void)addReachabilityToIndex:(EPPZReachability*) reachability;
+(void)removeReachabilityFromIndex:(EPPZReachability*) reachability;

@end


@implementation EPPZReachability


#pragma mark - Synchronous reachability (works with IP addresses as well)

+(void)reachHost:(NSString*) hostNameOrAddress completition:(EPPZReachabilityCompletitionBlock) completition
{
    EPPZRLog(@"EPPZReachability ----------");
    EPPZRLog(@"EPPZReachability reachHost: '%@'", hostNameOrAddress);
    
    EPPZReachability *instance = [[self alloc] initWithHost:hostNameOrAddress];;
    instance.completition = completition;
    
    [self addReachabilityToIndex:instance]; //Retain.
    [instance reachWithCompletition:^(EPPZReachability* reachability)
    {
        //Do not tear down.
        if (reachability.completition) reachability.completition(reachability);
        [reachability tearDown]; //Release.
    }];
}

+(void)reachObservedHost:(NSString*) hostNameOrAddress completition:(EPPZReachabilityCompletitionBlock) completition
{
    EPPZRLog(@"EPPZReachability ----------");
    EPPZRLog(@"EPPZReachability reachObservedHost: '%@'", hostNameOrAddress);
    
    EPPZReachability *instance = [[self alloc] initWithHost:hostNameOrAddress]; //Probably there is a reachability allocated out there.
    instance.completition = completition;
    
    [self addReachabilityToIndex:instance]; //Retain.
    [instance reachWithCompletition:^(EPPZReachability* reachability)
    {
        //Do tear down (as well).
        if (reachability.completition) reachability.completition(reachability);
        [reachability tearDown]; //Release.
    }];
}


#pragma mark - Asynchronous reachability (do not works with IP addresses somewhy)

+(void)listenHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate
{
    EPPZRLog(@"EPPZReachability ----------");
    EPPZRLog(@"EPPZReachability listenHost: '%@'", hostNameOrAddress);
    
    EPPZReachability *instance = [[self alloc] initWithHost:hostNameOrAddress];
    instance.delegate = delegate;
    [self addReachabilityToIndex:instance];
    
    [instance listen];
}


#pragma mark - Initialize

-(id)initWithHost:(NSString*) hostNameOrAddress
{
    if (self = [super init])
    {
        SCNetworkReachabilityRef reachabilityRef;
        
        _hostNameOrAddress = hostNameOrAddress;
        if ([hostNameOrAddress isIPaddress]) //Pretty neat IP address regular expression check.
        {
            EPPZRLog(@"EPPZReachability initialize new instance for IP address: '%@'", hostNameOrAddress);
            
            //Initialize SCNetworkReachability with address.
            _address = hostNameOrAddress;
            
            static struct sockaddr_in hostAddress;
            bzero(&hostAddress, sizeof(hostAddress));
            hostAddress.sin_len = sizeof(hostAddress);
            hostAddress.sin_family = AF_INET;
            hostAddress.sin_addr.s_addr = inet_addr([self.hostNameOrAddress UTF8String]);
            reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&hostAddress);
            EPPZRLog(@"EPPZReachability reachabilityRef %@", reachabilityRef);            
        }
        
        else
        {
            EPPZRLog(@"EPPZReachability initialize new instance for host name: '%@'", hostNameOrAddress);
            
            //Initialize SCNetworkReachability with hostName.
            _hostName = hostNameOrAddress;
            reachabilityRef = SCNetworkReachabilityCreateWithName(nil, [hostNameOrAddress UTF8String]);
            EPPZRLog(@"EPPZReachability reachabilityRef %@", reachabilityRef);            
        }
        
        self.reachabilityRef = reachabilityRef;
    }
    return self;
}


#pragma mark - Features

-(void)reachWithCompletition:(EPPZReachabilityCompletitionBlock) completition
{
    EPPZRLog(@"EPPZReachability reach '%@'", self.hostNameOrAddress);
    
    //Get flags.
    dispatch_async(dispatch_queue_create("com.eppz.reachability.reach", NULL), ^
    {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        {
            [self parseFlags:flags];
            dispatch_async(dispatch_get_main_queue(), ^ //Dispatch completition callback on the main thread.
            {
                EPPZRLog(@"EPPZReachability got flags '%@'", self.hostNameOrAddress);                
                if (self.completition) self.completition(self);
            });
        }
    });
}

-(void)listen
{
    EPPZRLog(@"EPPZReachability listen '%@'", self.hostNameOrAddress);
    
    //Set context, callback.
    SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    SCNetworkReachabilitySetCallback(self.reachabilityRef, reachabilityCallback, &context);
    
    //Dispatch where callbacks happen.
    //SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, dispatch_queue_create("com.eppz.reachability.listen", NULL));
    SCNetworkReachabilityScheduleWithRunLoop(self.reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    //Dispatch a first callback anyway to work around IP address unwanted behaviour (more in http://eppz.eu/blog/?p=260 post).
    BOOL isAddressReachability = (self.address != nil);
    if (isAddressReachability)
    {
        dispatch_async(dispatch_queue_create("com.eppz.reachability.workaround", NULL), ^
        {
            SCNetworkReachabilityFlags flags;
            if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
            {
                //Invoke callback 'by hand'.
                dispatch_async(dispatch_get_main_queue(), ^ //Dispatch delegate callback on the main thread.
                {
                    [self parseFlags:flags];
                    [self.delegate reachabilityChanged:self];
                });
            }
        });
    }
}

static void reachabilityCallback(SCNetworkReachabilityRef reachabilityRef, SCNetworkReachabilityFlags flags, void* info)
{
    if ([(__bridge id)info isKindOfClass:[EPPZReachability class]])
    {
        EPPZReachability *reachability = (__bridge EPPZReachability*)info; //Cast context object.
        EPPZRLog(@"EPPZReachability reachabilityCallback '%@'", reachability.hostNameOrAddress);
        
        dispatch_async(dispatch_get_main_queue(), ^ //Dispatch delegate callback on the main thread.
        {
            [reachability parseFlags:flags];
            [reachability.delegate reachabilityChanged:reachability];
        });
    }
    
    else
    {
        //Has happened while used dispatch_queue instead of CFRunLoop.
        EPPZRLog(@"EPPZReachability reachabilityCallback with unexpected context object %@", info);
    }
}

-(void)parseFlags:(SCNetworkReachabilityFlags) flags
{
    EPPZRLog(@"EPPZReachability parseFlags '%@'", self.hostNameOrAddress);
    
    _flags = flags;
    
    //Typecast flags to arbiraty BOOL properties.
    
        _cellularFlag = (flags & kSCNetworkReachabilityFlagsIsWWAN);
        _reachableFlag =  (flags & kSCNetworkReachabilityFlagsReachable);
        _transistentConnectionFlag = (flags & kSCNetworkReachabilityFlagsTransientConnection);
        _connectionRequiredFlag = (flags & kSCNetworkReachabilityFlagsConnectionRequired);
        _connectionOnTrafficFlag = (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic);
        _interventionRequiredFlag = (flags & kSCNetworkReachabilityFlagsInterventionRequired);
        _connectionOnDemandFlag = (flags & kSCNetworkReachabilityFlagsConnectionOnDemand);
        _localAddressFlag = (flags & kSCNetworkReachabilityFlagsIsLocalAddress);
        _directFlag = (flags & kSCNetworkReachabilityFlagsIsDirect);
    
    //Network status (from Apple's Reachability sample).
    
        //TODO: Untangle this to a more simple/readable stuff.
    
        _reachableViaWiFi = _reachableViaCellular = _reachable = NO; //Reset.
        
        _notReachable = (self.reachableFlag == NO);
        if (self.notReachable) return; //No other status if not reachable.
        
        _reachableViaWiFi = (self.connectionRequiredFlag == NO);
        if (self.connectionOnDemandFlag || self.connectionOnTrafficFlag) { _reachableViaWiFi = (self.interventionRequiredFlag == NO); }
        _reachableViaCellular = ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN);
        if (_reachableViaCellular) _reachableViaWiFi = NO;
    
        _reachable = (self.reachableViaWiFi || self.reachableViaCellular);
        _notReachable = (self.reachableViaWiFi == NO && self.reachableViaCellular == NO);   
}


#pragma mark - Reachability collection maintanance 

__strong static NSMutableArray *_reachabilityIndex = nil;

+(NSMutableArray*)reachabilityIndex //Like a 'Class property'.
{
    if (_reachabilityIndex == nil) _reachabilityIndex = [NSMutableArray new];
    return _reachabilityIndex;
}

+(void)addReachabilityToIndex:(EPPZReachability*) reachability
{
    EPPZRLog(@"EPPZReachability addReachabilityToIndex '%@'", reachability.hostNameOrAddress);    
    
    if (reachability != nil)
    {
        //Replace previous reachability for this host.
        [[self reachabilityIndex] addObject:reachability];
    }
    
    EPPZRLog(@"EPPZReachability reachabilityCount: <%i>", [[self reachabilityIndex] count]);
}

+(void)removeReachabilityFromIndex:(EPPZReachability*) reachability
{
    EPPZRLog(@"EPPZReachability removeReachabilityFromIndex '%@'", reachability.hostNameOrAddress);
    
    if (reachability != nil)
        if ([[self reachabilityIndex] containsObject:reachability])
                [[self reachabilityIndex] removeObject:reachability];
    
    EPPZRLog(@"EPPZReachability reachabilityCount: <%i>", [[self reachabilityIndex] count]);        
}

+(void)stopListeningHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate
{
    //Search for a matching instance.
    EPPZReachability *matchingReachability;
    for (EPPZReachability *eachReachability in [self reachabilityIndex])
    {
        if (eachReachability.delegate == delegate)
            if ([eachReachability.hostNameOrAddress isEqualToString:hostNameOrAddress])
            {
                matchingReachability = eachReachability;
                break;
            }
    }
    
    //Unschedule invoking callbacks from the main run loop.
    SCNetworkReachabilityUnscheduleFromRunLoop(matchingReachability.reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    [matchingReachability tearDown];
}

-(void)tearDown
{    
    EPPZRLog(@"EPPZReachability tearDown '%@'", self.hostNameOrAddress);
    [self.class removeReachabilityFromIndex:self];
}

-(void)dealloc
{
    EPPZRLog(@"EPPZReachability dealloc '%@'", self.hostNameOrAddress);
    
    if (self.reachabilityRef != NULL)
    { CFRelease(self.reachabilityRef); }
}


@end
