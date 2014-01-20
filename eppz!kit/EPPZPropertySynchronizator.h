//
//  EPPZPropertyMapper.h
//  Totoya parenting
//
//  Created by Carnation on 20/01/14.
//  Copyright (c) 2014 Pangalaktik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+EPPZKit.h"


@interface EPPZPropertySynchronizator : NSObject

+(id)mapperWithInstance:(NSObject*) one
               instance:(NSObject*) other
            propertyMap:(NSDictionary*) propertyMap;

@end
