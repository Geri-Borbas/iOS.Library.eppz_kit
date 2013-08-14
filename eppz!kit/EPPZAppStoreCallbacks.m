//
//  EPPZAppStoreCallbacks.m
//  eppz!tools
//
//  Created by Borbás Geri on 11/15/12.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZAppStoreCallbacks.h"

@implementation EPPZAppStoreCallbacks


#pragma mark - Product request

+(id)productDetailsCallbacksWithSuccess:(EPPZAppStoreProductDetailsSuccessBlock) successBlock error:(EPPZAppStoreErrorBlock) errorBlock productsRequest:(SKProductsRequest*) productsRequest productIdentifier:(NSString*) productIdentifier
{ return [[self alloc] initDetailsCallbacksWithSuccess:successBlock error:errorBlock productsRequest:productsRequest productIdentifier:productIdentifier]; }

-(id)initDetailsCallbacksWithSuccess:(EPPZAppStoreProductDetailsSuccessBlock) successBlock error:(EPPZAppStoreErrorBlock) errorBlock productsRequest:(SKProductsRequest*) productsRequest productIdentifier:(NSString*) productIdentifier
{
    if (self = [super init])
    {
        self.productDetailsSuccessBlock = successBlock;
        self.productDetailsErrorBlock = errorBlock;
        self.productIdentifier = productIdentifier;
        self.productsRequest = productsRequest;
    }
    return self;
}

-(void)retryAfterIntervalIfNeeded:(NSTimeInterval) interval
{
    [EPPZTimer scheduledTimerWithTimeInterval:interval
                                       target:self
                                     selector:@selector(retryProductRequest)
                                     userInfo:nil
                                      repeats:NO];
}

-(void)retryProductRequest
{
    NSLog(@"retryProductRequest (%@)", self.productsRequest);
    
    //Cancel current request if any.
    id delegate = self.productsRequest.delegate;
    [self.productsRequest cancel];
    
    //Create a new request.
    NSSet *productIDsSet = [NSSet setWithObject:self.productIdentifier];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDsSet];
    productsRequest.delegate = delegate;
    
    //Store new request.
    self.productsRequest = productsRequest;
    
    //Start.
    [self.productsRequest start];
}


#pragma mark - Purchase request

+(id)productPurchaseCallbacksWithSuccess:(EPPZAppStoreProductPurchaseSuccessBlock) successBlock error:(EPPZAppStoreErrorBlock) errorBlock
{ return [[self alloc] initPurchaseCallbacksWithSuccess:successBlock error:errorBlock]; }

-(id)initPurchaseCallbacksWithSuccess:(EPPZAppStoreProductPurchaseSuccessBlock) successBlock error:(EPPZAppStoreErrorBlock) errorBlock
{
    if (self = [super init])
    {
        self.productPurchaseSuccessBlock = successBlock;
        self.productPurchaseErrorBlock = errorBlock;
    }
    return self;
}

-(void)dealloc
{ NSLog(@"EPPZAppStoreCallbacks dealloc"); }


@end
