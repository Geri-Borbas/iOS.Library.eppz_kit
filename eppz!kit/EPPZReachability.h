//
//  EPPZReachability.h
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

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSString+EPPZReachability.h"


//May enable for debugging/inspecting.
#define EPPZ_REACHABILITY_LOGGING NO
#define EPPZRLog if (EPPZ_REACHABILITY_LOGGING) NSLog


//Completition block.
@class EPPZReachability;
typedef void(^EPPZReachabilityCompletitionBlock)(EPPZReachability* reachability);


//Delegate.
@protocol EPPZReachabilityDelegate <NSObject>
-(void)reachabilityChanged:(EPPZReachability*) reachability; //Will call back on the main thread.
@end


@interface EPPZReachability : NSObject


#pragma mark - Reachability information

//User-defined trough factory.
@property (nonatomic, readonly) NSString *hostNameOrAddress;
@property (nonatomic, readonly) NSString *hostName;
@property (nonatomic, readonly) NSString *address;

//Networ status flags (for humans).
@property (nonatomic, readonly) BOOL reachable;
@property (nonatomic, readonly) BOOL notReachable;
@property (nonatomic, readonly) BOOL reachableViaCellular;
@property (nonatomic, readonly) BOOL reachableViaWiFi;

//Reachability flags and their aliases (for the curious minds).
@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;
@property (nonatomic, readonly) BOOL cellularFlag;
@property (nonatomic, readonly) BOOL reachableFlag;
@property (nonatomic, readonly) BOOL transistentConnectionFlag;
@property (nonatomic, readonly) BOOL connectionRequiredFlag;
@property (nonatomic, readonly) BOOL connectionOnTrafficFlag;
@property (nonatomic, readonly) BOOL interventionRequiredFlag;
@property (nonatomic, readonly) BOOL connectionOnDemandFlag;
@property (nonatomic, readonly) BOOL localAddressFlag;
@property (nonatomic, readonly) BOOL directFlag;


#pragma mark - Features

+(void)listenHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate; 
+(void)stopListeningHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate;

//This method is a one shot method, reachability instance will deallocated after use.
+(void)reachHost:(NSString*) hostNameOrAddress completition:(EPPZReachabilityCompletitionBlock) completition; //Will call back on the main thread.


@end
