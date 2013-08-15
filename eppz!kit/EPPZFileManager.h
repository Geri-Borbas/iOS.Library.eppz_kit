//
//  EPPZFileManager.h
//  EPPZKit
//
//  Created by Borbás Geri on 6/6/12.
//  Copyright (c) 2012 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EPPZSingletonSubclass.h"


#define FILES [EPPZFileManager sharedFileManager]


@interface EPPZFileManager : EPPZSingleton

@property (nonatomic, readonly) NSString *documentsDirectory;
+(EPPZFileManager*)sharedFileManager;

#pragma mark - File Search

-(NSString*)pathForFileNameInDocumentsDirectory:(NSString*) fileName;
-(NSString*)pathForNewFileNameInDocumentsDirectory:(NSString*) fileName;
-(NSString*)pathForFileNameInBundle:(NSString*) fileName;
-(NSString*)pathForFileNameInBundle:(NSString*) fileName inDirectory:(NSString*) directoryPath;
-(NSString*)pathForFileName:(NSString*) fileName;
-(UIImage*)imageForFileName:(NSString*) imageFileName;


#pragma mark - File modification date

-(BOOL)fileExistsAtPath:filePath;
-(NSDate*)fileModificationDateForPath:(NSString*) filePath;
-(BOOL)file:(NSString*) filePath modifiedAfterDate:(NSDate*) dateToCompare;

#pragma mark - Filename operations

-(NSString*)filePath:(NSString*) filePath withSuffix:(NSString*) suffix;
-(NSString*)fileName:(NSString*) fileName withSuffix:(NSString*) suffix;
-(NSString*)changeExtensionOfFilePath:(NSString*) filePath to:(NSString*) extension;


#pragma mark - Directories

-(BOOL)createDirectoryToDocuments:(NSString*) directoryName;
-(BOOL)createDirectory:(NSString*) directoryName toPath:(NSString*) path;
-(NSArray*)contentsOfDirectory:(NSString*) path;
-(NSArray*)filesOfType:(NSString*) fileType inDirectory:(NSString*) directoryPath;


#pragma mark - Delete files

-(BOOL)deleteFileAthPath:(NSString*) filePath;

@end
