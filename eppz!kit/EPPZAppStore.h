//
//  EPPZAppStore.h
//  eppz!tools
//
//  Created by Borbás Geri on 11/15/12.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZSingletonSubclass.h"
#import "EPPZReachability.h"

#import "SKProduct+LocalizedPrice.h"
#import <StoreKit/StoreKit.h>


/*
 
    EPPZAppStore is set up only for a single product per request!
    But you can invoke multiply request at once anyway.
 
*/

#import "EPPZAppStoreCallbacks.h"


typedef void (^EPPZAppStoreRestorePurchasesSuccessBlock)();


#define APPSTORE_ [EPPZAppStore sharedInstance]


@interface EPPZAppStore : EPPZSingleton

<SKProductsRequestDelegate,
SKPaymentTransactionObserver>

-(void)takeOff;


#pragma mark - Features

-(void)isAppStoreReachable:(EPPZReachabilityCompletitionBlock) completition;

-(BOOL)isProductPurchased:(NSString*) productID;
-(void)saveReceipeForProduct:(NSString*) productID;
-(void)clearReceipeForProduct:(NSString*) productID;

-(void)requestProductDetails:(NSString*) productID
                     success:(EPPZAppStoreProductDetailsSuccessBlock) successBlock
                       error:(EPPZAppStoreErrorBlock) errorBlock;

-(void)purchaseProduct:(NSString*) productID
               success:(EPPZAppStoreProductPurchaseSuccessBlock) successBlock
                 error:(EPPZAppStoreErrorBlock) errorBlock;

-(void)restorePurchasesWithSuccess:(EPPZAppStoreRestorePurchasesSuccessBlock) successBlock
                             error:(EPPZAppStoreErrorBlock) errorBlock;


@end
