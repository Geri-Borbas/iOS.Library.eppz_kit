//
//  SKProduct+LocalizedPrice.h
//  tangram!
//
//  Created by Geri on 10/11/11.
//  Copyright 2012 eppz! All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
