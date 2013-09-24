//
//  NSObject+EPPZRepresentable_Plist.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/22/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSObject+EPPZRepresentable.h"
#import "NSObject+EPPZRepresentable_Plist.h"


@implementation NSObject (EPPZRepresentable_Plist)


#pragma mark - Store

-(BOOL)storeAsPlistNamed:(NSString*) plistFileName
{ _LOG
    
    //Compose file path in 'Documents' directory.
    NSString *fileName = [plistFileName stringByAppendingPathExtension:@"plist"];
    NSString *filePath = [FILES pathForNewFileNameInDocumentsDirectory:fileName];
    return [self storeAsPlistAtPath:filePath];
}

-(BOOL)storeAsPlistAtPath:(NSString*) plistFilePath
{ _LOG
    
    NSDictionary *dictionaryRepresentation = self.dictionaryRepresentation;
    BOOL plistWritten = [dictionaryRepresentation writeToFile:plistFilePath atomically:YES];
    
    ERLog(@"EPPZRepresentable storeAsPlistAtPath:'%@' %@.", plistFilePath, (plistWritten) ? @"succeeded" : @"failed");
    
    // Catch errors.
    if (plistWritten == NO)
    { [[EPPZRepresentableException object:self couldNotWriteDictionaryRepresentation:dictionaryRepresentation toPlistNamed:plistFilePath.lastPathComponent] raise]; }
    
    return plistWritten;
}


#pragma mark - Load

+(id)loadFromPlistNamed:(NSString*) plistFileName
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
    
    return [self loadFromPlistAtPath:filePath];
}

+(id)loadFromPlistAtPath:(NSString*) plistFilePath;
{
    NSDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
    return [self representableWithDictionaryRepresentation:dictionaryRepresentation];
}


@end
