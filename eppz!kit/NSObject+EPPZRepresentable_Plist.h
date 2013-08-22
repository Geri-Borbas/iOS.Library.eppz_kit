//
//  NSObject+EPPZRepresentable_Plist.h
//  eppz!kit
//
//  Created by Carnation on 8/22/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPPZFileManager.h"


@interface NSObject (EPPZRepresentable_Plist)

-(BOOL)storeAsPlistNamed:(NSString*) plistFileName;
-(BOOL)storeAsPlistAtPath:(NSString*) plistFilePath;

+(id)representableWithPlistNamed:(NSString*) plistFileName;
+(id)representableWithPlistAtPath:(NSString*) plistFilePath;

@end
