//
//  EPPZRepresentableException.m
//  eppz!kit
//
//  Created by Borbás Geri on 9/24/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
