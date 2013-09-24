//
//  EPPZRepresentableException.m
//  eppz!kit
//
//  Created by Gardrobe on 9/24/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZRepresentableException.h"

@implementation EPPZRepresentableException


+(EPPZRepresentableException*)object:(NSObject*) object hasNoSuchPropertyNamed:(NSString*) propertyName
{
    NSString *reason = [NSString stringWithFormat:@"Probably you have defined custom 'representablePropertyNames' for this class <%@>, but no '%@' property exist anymore.", NSStringFromClass(object.class), propertyName];
    return (EPPZRepresentableException*)[NSException exceptionWithName:@"No such property." reason:reason userInfo:nil];
}

+(EPPZRepresentableException*)object:(NSObject*) object couldNotRepresentPropertyNamed:(NSString*) propertyName;
{
    NSString *reason = [NSString stringWithFormat:@"Class <%@> could not represent property '%@'.", NSStringFromClass(object.class), propertyName];
    return (EPPZRepresentableException*)[NSException exceptionWithName:@"Could not represent class." reason:reason userInfo:nil];
}

+(EPPZRepresentableException*)object:(NSObject*) object couldNotWriteDictionaryRepresentation:(NSDictionary*) dictionaryRepresentation toPlistNamed:(NSString*) plistName
{
    NSString *reason = [NSString stringWithFormat:@"Class <%@> could not saved to plist named '%@'. Probably represented dictionary tree below contains some non-plist compilant values. %@", NSStringFromClass(object.class), plistName, dictionaryRepresentation];
    return (EPPZRepresentableException*)[NSException exceptionWithName:@"Could not save plist representation." reason:reason userInfo:nil];
}


@end
