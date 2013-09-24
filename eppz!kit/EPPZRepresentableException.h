//
//  EPPZRepresentableException.h
//  eppz!kit
//
//  Created by Gardrobe on 9/24/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPPZRepresentableException : NSException


+(EPPZRepresentableException*)object:(NSObject*) object hasNoSuchPropertyNamed:(NSString*) propertyName;
+(EPPZRepresentableException*)object:(NSObject*) object couldNotRepresentPropertyNamed:(NSString*) propertyName;
+(EPPZRepresentableException*)object:(NSObject*) object couldNotWriteDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation toPlistNamed:(NSString*) plistName;


@end
