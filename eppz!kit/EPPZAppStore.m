//
//  EPPZAppStore.m
//  eppz!tools
//
//  Created by Borbás Geri on 11/15/12.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZAppStore.h"
#import "SKProduct+LocalizedPrice.h"


@interface EPPZAppStore ()
@property (nonatomic, strong) NSMutableArray *detailsCallbackPool;
@property (nonatomic, strong) NSMutableDictionary *purchaseCallbacksForProductIDs;
@property (nonatomic, strong) EPPZAppStoreRestorePurchasesSuccessBlock restorePurchasesSuccessBlock;
@property (nonatomic, strong) EPPZAppStoreRestorePurchasesSuccessBlock restorePurchasesErrorBlock;

@property (nonatomic, strong) NSError *networkError;
@property (nonatomic, strong) NSError *transactionFailedError;

@end


@implementation EPPZAppStore


#pragma mark - Creation

-(id)init
{
    if (self = [super init])
    {
        [self takeOff];
    }
    return self;
}

-(void)takeOff
{
    NSLog(@"EPPZAppStore takeOff");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.detailsCallbackPool = [NSMutableArray new];
    self.purchaseCallbacksForProductIDs = [NSMutableDictionary new];
    
    self.networkError = [NSError errorWithDomain:@"EPPZAppStore"
                                            code:1
                                        userInfo:@{ NSLocalizedDescriptionKey :
                                                    @"Cannot connect to iTunes servers." }];
    
    self.transactionFailedError = [NSError errorWithDomain:@"EPPZAppStore"
                                                      code:2
                                                  userInfo:@{ NSLocalizedDescriptionKey :
                                                              @"Transaction failed." }];
}


#pragma mark - Callback pool management

-(void)addCallbacks:(EPPZAppStoreCallbacks*) callbacks
{ if (callbacks != nil) [self.detailsCallbackPool addObject:callbacks]; }

-(void)removeCallbacks:(EPPZAppStoreCallbacks*) callbacks
{ if (callbacks != nil) [self.detailsCallbackPool removeObject:callbacks]; }

-(EPPZAppStoreCallbacks*)detailsCallbacksForProductsRequest:(SKProductsRequest*) productsRequest
{
    EPPZAppStoreCallbacks *callbacks = nil;
    for (EPPZAppStoreCallbacks *eachCallbacks in self.detailsCallbackPool)
    {
        if (productsRequest == eachCallbacks.productsRequest)
        {
            callbacks = eachCallbacks;
            break;
        }
    }
    return callbacks;
}

-(EPPZAppStoreCallbacks*)purchaseCallbacksForProductID:(NSString*) productID
{
    if (productID != nil) return [self.purchaseCallbacksForProductIDs objectForKey:productID];
    return nil;
}


#pragma mark - Network reachability

-(void)isAppStoreReachable:(EPPZReachabilityCompletitionBlock) completition
{
    //Check iTunes reachability.
    [EPPZReachability reachHost:@"www.apple.com" completition:completition];
}


#pragma mark - Product details request

-(void)requestProductDetails:(NSString*) productID
                     success:(EPPZAppStoreProductDetailsSuccessBlock) successBlock
                       error:(EPPZAppStoreErrorBlock) errorBlock
{ [self requestProductDetails:productID tag:nil success:successBlock error:errorBlock]; }

-(void)requestProductDetails:(NSString*) productID
                         tag:(NSString*) tag
                     success:(EPPZAppStoreProductDetailsSuccessBlock) successBlock
                       error:(EPPZAppStoreErrorBlock) errorBlock
{    
    [self isAppStoreReachable:^(EPPZReachability *reachability)
    {
        //Reachable iTunes.
        if (reachability.reachable)
        {
            NSLog(@"EPPZAppStore requestProductDetails:%@", productID);
            
            NSSet *productIDsSet = [NSSet setWithObject:productID];
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDsSet];
            productsRequest.delegate = self;
            
            //Add callbacks to queue.
            EPPZAppStoreCallbacks *callbacks = [EPPZAppStoreCallbacks productDetailsCallbacksWithSuccess:successBlock
                                                                                                   error:errorBlock
                                                                                         productsRequest:productsRequest];
            [self addCallbacks:callbacks];
            
            [productsRequest start];
        }
        
        //Network error.
        else
        {
            if (errorBlock) errorBlock(self.networkError);
        }
    }];
}

-(void)productsRequest:(SKProductsRequest*) request didReceiveResponse:(SKProductsResponse*) response
{
    NSLog(@"EPPZAppStore productsRequest:didReceiveResponse:");
    
    //Get callbacks for this ID.
    EPPZAppStoreCallbacks *callbacks = [self detailsCallbacksForProductsRequest:request];
    
    for (SKProduct *eachProduct in response.products)
    {
        NSLog(@"EPPZAppStore product.localizedTitle %@" , eachProduct.localizedTitle);
        NSLog(@"EPPZAppStore product.localizedDescription %@" , eachProduct.localizedDescription);
        NSLog(@"EPPZAppStore product.localizedPrice %@" , eachProduct.localizedPrice);
        NSLog(@"EPPZAppStore product.productIdentifier: %@" , eachProduct.productIdentifier);
        
        //Callback (then remove callback from queue).
        if (callbacks.productDetailsSuccessBlock) callbacks.productDetailsSuccessBlock(eachProduct);
        [self removeCallbacks:callbacks];

    }
    
    for (NSString *eachInvalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , eachInvalidProductId);
        
        //Callback (then remove callback from queue).
        if (callbacks.productDetailsErrorBlock) callbacks.productDetailsErrorBlock(nil);
        [self removeCallbacks:callbacks];
    }
    
}


#pragma mark - Transactions (Purchase)

-(void)purchaseProduct:(NSString*) productID
               success:(EPPZAppStoreProductPurchaseSuccessBlock) successBlock
                 error:(EPPZAppStoreErrorBlock) errorBlock
{
    [self isAppStoreReachable:^(EPPZReachability *reachability)
    {
        //Reachable iTunes.
        if (reachability.reachable)
        {
            
        }
        
        //Network error.
        else
        {
            if (errorBlock) errorBlock(self.networkError);
        }
    }];
    
    NSLog(@"EPPZAppStore purchaseProductForID:%@", productID);
    
    //Add callbacks to queue.
    [self.purchaseCallbacksForProductIDs setObject:[EPPZAppStoreCallbacks productPurchaseCallbacksWithSuccess:successBlock
                                                                                                        error:errorBlock]
                                            forKey:productID];
    
    if ([SKPaymentQueue canMakePayments])
    {
        //Need to request product details before.
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    else
    {
        NSError *error = [NSError errorWithDomain:@"EPPZAppStore" code:0
                                         userInfo:[NSDictionary dictionaryWithObject:@"User cannot make payements."
                                                                              forKey:NSLocalizedDescriptionKey]];
        
        //Callback (then remove callback from queue).
        EPPZAppStoreCallbacks *callbacksForProductID = [self.purchaseCallbacksForProductIDs objectForKey:productID];
        if (callbacksForProductID.productPurchaseErrorBlock) callbacksForProductID.productPurchaseErrorBlock(error);
        if (callbacksForProductID) [self.purchaseCallbacksForProductIDs removeObjectForKey:productID];
    }
}


#pragma mark - Transactions (Restore)

-(void)restorePurchasesWithSuccess:(EPPZAppStoreRestorePurchasesSuccessBlock) successBlock
                             error:(EPPZAppStoreErrorBlock) errorBlock;
{
    NSLog(@"EPPZAppStore restoreProducts");
    
    [self isAppStoreReachable:^(EPPZReachability *reachability)
    {
        //Reachable iTunes.
        if (reachability.reachable)
        {
            //Retain callbacks.
            self.restorePurchasesSuccessBlock = successBlock;
            self.restorePurchasesErrorBlock = errorBlock;
            
            if ([SKPaymentQueue canMakePayments])
            {
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            }
            
            else
            {
                NSError *error = [NSError errorWithDomain:@"EPPZAppStore" code:0
                                                 userInfo:[NSDictionary dictionaryWithObject:@"User cannot make payements."
                                                                                      forKey:NSLocalizedDescriptionKey]];
                
                //Callback.
                if (self.restorePurchasesErrorBlock)
                {
                    self.restorePurchasesErrorBlock(error);
                    self.restorePurchasesErrorBlock = nil;
                }
            }
        }
         
        //Network error.
        else
        {
            if (errorBlock) errorBlock(self.networkError);
        }
    }];
}


#pragma mark - Payement queue callbacks (purchase)

-(void)paymentQueue:(SKPaymentQueue*) queue updatedTransactions:(NSArray*) transactions
{
    NSLog(@"EPPZAppStore paymentQueue:updatedTransactions: %@", transactions);
    
    BOOL anyRestorationsTookPlace = NO;
    for (SKPaymentTransaction *eachTransaction in transactions)
    {
        switch (eachTransaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self transactionPurchased:eachTransaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self transactionFailed:eachTransaction];
                break;
            case SKPaymentTransactionStateRestored:
                anyRestorationsTookPlace = YES;
                [self transactionRestored:eachTransaction];
                break;
            default:
                break;
        }
    }
    
    //Callback restored transactions if any.
    if (anyRestorationsTookPlace && self.restorePurchasesSuccessBlock)
    {
        self.restorePurchasesSuccessBlock();
        self.restorePurchasesSuccessBlock = nil;
    }
}


#pragma mark - Payement queue callbacks (restore)

-(void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*) error
{
    NSLog(@"EPPZAppStore paymentQueue:restoreCompletedTransactionsFailedWithError: %@", error);
    
    if (self.restorePurchasesSuccessBlock)
    {
        self.restorePurchasesErrorBlock();
        self.restorePurchasesErrorBlock = nil;
    }
}


#pragma mark - Payement queue callbacks (download)

-(void)paymentQueue:(SKPaymentQueue*)queue updatedDownloads:(NSArray*) downloads
{
    NSLog(@"EPPZAppStore paymentQueue:updatedDownloads: %@", downloads);
    
    for (SKDownload *eachDownload in downloads)
    {
        switch (eachDownload.downloadState)
        {
            case SKDownloadStateWaiting:
                NSLog(@"EPPZAppStore SKDownloadStateWaiting");
                break;
            case SKDownloadStateActive:
                NSLog(@"EPPZAppStore SKDownloadStateActive");
                break;
            case SKDownloadStatePaused:
                NSLog(@"EPPZAppStore SKDownloadStatePaused");
                break;
            case SKDownloadStateFinished:
                NSLog(@"EPPZAppStore SKDownloadStateFinished");
                break;
            case SKDownloadStateFailed:
                NSLog(@"EPPZAppStore SKDownloadStateFailed");
                break;
            case SKDownloadStateCancelled:
                NSLog(@"EPPZAppStore SKDownloadStateCancelled");
                break;
            default:
                break;
        }
    }
}


#pragma mark - Transaction callbacks

-(void)transactionPurchased:(SKPaymentTransaction*) transaction
{
    NSString *productID = transaction.payment.productIdentifier;
    NSLog(@"EPPZAppStore transactionPurchased:%@", productID);
    
    //Save.
    [self saveReceipeForProduct:productID];
    
    //Callback (then remove callback from queue).
    EPPZAppStoreCallbacks *callbacksForProductID = [self.purchaseCallbacksForProductIDs objectForKey:productID];
    if (callbacksForProductID.productPurchaseSuccessBlock) callbacksForProductID.productPurchaseSuccessBlock(productID);
    if (callbacksForProductID) [self.purchaseCallbacksForProductIDs removeObjectForKey:productID];
    
    //StoreKit.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)transactionRestored:(SKPaymentTransaction*) transaction
{
    NSString *productID = transaction.payment.productIdentifier;
    NSLog(@"EPPZAppStore transactionRestored:%@", productID);
    
    //Save.
    [self saveReceipeForProduct:transaction.payment.productIdentifier];
    
    //Callback (then remove callback from queue).
    EPPZAppStoreCallbacks *callbacksForProductID = [self.purchaseCallbacksForProductIDs objectForKey:productID];
    if (callbacksForProductID.productPurchaseSuccessBlock) callbacksForProductID.productPurchaseSuccessBlock(productID);
    if (callbacksForProductID) [self.purchaseCallbacksForProductIDs removeObjectForKey:productID];
    
    //StoreKit.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)transactionFailed:(SKPaymentTransaction*) transaction
{
    NSString *productID = transaction.payment.productIdentifier;
    NSLog(@"EPPZAppStore transactionFailed:%@", productID);
    
    //Callback (then remove callback from queue).
    EPPZAppStoreCallbacks *callbacksForProductID = [self.purchaseCallbacksForProductIDs objectForKey:productID];
    if (callbacksForProductID.productPurchaseErrorBlock) callbacksForProductID.productPurchaseErrorBlock(self.transactionFailedError);
    if (callbacksForProductID) [self.purchaseCallbacksForProductIDs removeObjectForKey:productID];
    
    //Restore transaction callback if any.
    if (self.restorePurchasesErrorBlock)
    {
        self.restorePurchasesErrorBlock(self.transactionFailedError);
        self.restorePurchasesErrorBlock = nil;
    }
    
    //StoreKit.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


#pragma mark - Local store

-(BOOL)isProductPurchased:(NSString*) productID
{ return ([[NSUserDefaults standardUserDefaults] objectForKey:productID] != nil); }

-(void)saveReceipeForProduct:(NSString*) productID
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Purchased" forKey:productID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clearReceipeForProduct:(NSString*) productID
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:productID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
