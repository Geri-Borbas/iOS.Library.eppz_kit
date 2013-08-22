//
//  NSObject+EPPZRepresentable_Plist.m
//  eppz!kit
//
//  Created by Carnation on 8/22/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "NSObject+EPPZRepresentable.h"
#import "NSObject+EPPZRepresentable_Plist.h"

@implementation NSObject (EPPZRepresentable_Plist)


#pragma mark - Store

-(BOOL)storeAsPlistNamed:(NSString*) plistFileName
{
    //Compose file path in 'Documents' directory.
    NSString *fileName = [plistFileName stringByAppendingPathExtension:@"plist"];
    NSString *filePath = [FILES pathForNewFileNameInDocumentsDirectory:fileName];
    return [self storeAsPlistAtPath:filePath];
}

-(BOOL)storeAsPlistAtPath:(NSString*) plistFilePath
{
    return [self.dictionaryRepresentation writeToFile:plistFilePath atomically:YES];
}


#pragma mark - Create

+(id)representableWithPlistNamed:(NSString*) plistFileName
{
    //Look for file path in main bundle.
    NSString *fileName = [plistFileName stringByAppendingPathExtension:@"plist"];
    NSString *filePath = [FILES pathForFileNameInBundle:fileName];
    
    //If no such plist in bundle, lookup 'Documents' directory.
    if (filePath == nil)
    {
        NSString *fileName = [plistFileName stringByAppendingPathExtension:@"plist"];
        NSString *filePath = [FILES pathForFileNameInDocumentsDirectory:fileName];
        
        //If still not found, do nothing.
        if (filePath == nil) return nil;
    }
    
    return [self representableWithPlistAtPath:filePath];
}

+(id)representableWithPlistAtPath:(NSString*) plistFilePath;
{
    NSDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
    return [self representableWithDictionaryRepresentation:dictionaryRepresentation];
}


@end
