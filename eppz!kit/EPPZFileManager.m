//
//  EPPZFileManager.m
//  EPPZKit
//
//  Created by Borbás Geri on 6/6/12.
//  Copyright (c) 2012 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZFileManager.h"


@interface EPPZFileManager ()
{
    NSFileManager *_fileManager;
    
    NSArray *_documentDirectoryPaths;
    NSString *_documentsDirectory;
}
@end


#define DOCUMENTS [self documentsDirectory]


@implementation EPPZFileManager

+(EPPZFileManager*)sharedFileManager { return (EPPZFileManager*)[self sharedInstance]; }
-(id)init
{
    if (self = [super init])
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}


#pragma mark - File search

-(NSString*)documentsDirectory
{
    if (_documentsDirectory == nil)
    {
        _documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [_documentDirectoryPaths objectAtIndex:0];
    }
    
    return _documentsDirectory;
}

-(NSString*)pathForFileNameInDocumentsDirectory:(NSString*) fileName
{
    NSString *path = [DOCUMENTS stringByAppendingPathComponent:fileName];
    
    if ([_fileManager fileExistsAtPath:path])
        return path;
    else
        return nil;
}

-(NSString*)pathForNewFileNameInDocumentsDirectory:(NSString*) fileName
{
    NSString *path = [DOCUMENTS stringByAppendingPathComponent:fileName];
    return path;
}

-(NSString*)pathForFileNameInBundle:(NSString*) fileName
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
}

-(NSString*)pathForFileNameInBundle:(NSString*) fileName inDirectory:(NSString*) directoryPath
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:directoryPath];
}

-(NSString*)pathForFileName:(NSString*) fileName
{
    NSString *path = [self pathForFileNameInDocumentsDirectory:fileName];
    if (path != nil) return path;
    
    path = [self pathForFileNameInBundle:fileName];
    return path; //Or nil.
}

-(UIImage*)imageForFileName:(NSString*) imageFileName
{
    return [UIImage imageWithContentsOfFile:[self pathForFileName:imageFileName]];
}


#pragma mark - File modification date

-(BOOL)fileExistsAtPath:filePath
{
    return [_fileManager fileExistsAtPath:filePath];
}

-(NSDate*)fileModificationDateForPath:(NSString*) filePath
{
    return [[_fileManager attributesOfItemAtPath:filePath error:nil] fileModificationDate];
}

-(BOOL)file:(NSString*) filePath modifiedAfterDate:(NSDate*) dateToCompare
{
    NSDate *lastModificationDate = [self fileModificationDateForPath:filePath];
    return ([dateToCompare compare:lastModificationDate] == NSOrderedDescending);
}

#pragma mark - Filename operations

-(NSString*)filePath:(NSString*) filePath withSuffix:(NSString*) suffix
{
    NSString *pathExtension = [filePath pathExtension]; //.jpg
    NSString *pathWithoutExtension = [filePath stringByDeletingPathExtension]; //Directory/FileName
    NSString *pathWithSuffix = [pathWithoutExtension stringByAppendingString:suffix]; //Directory/ImageFileName_suffix
    return [pathWithSuffix stringByAppendingPathExtension:pathExtension]; //Directory/ImageFileName_mask.jpg
}

-(NSString*)fileName:(NSString*) fileName withSuffix:(NSString*) suffix
{
    return [self filePath:fileName withSuffix:suffix];
}

-(NSString*)changeExtensionOfFilePath:(NSString*) filePath to:(NSString*) extension
{
    NSString *pathWithoutExtension = [filePath stringByDeletingPathExtension]; //Directory/FileName
    return [pathWithoutExtension stringByAppendingPathExtension:extension]; //Directory/ImageFileName_mask.data
}

#pragma mark - Directories

-(BOOL)createDirectoryToDocuments:(NSString*) directoryName
{
    return [self createDirectory:directoryName toPath:self.documentsDirectory];
}

-(BOOL)createDirectory:(NSString*) directoryName toPath:(NSString*) path
{
    NSString* directoryPath = [path stringByAppendingPathComponent:directoryName];
    BOOL directoryCreated = [_fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return directoryCreated;
}

-(NSArray*)contentsOfDirectory:(NSString*) directoryPath
{ return [_fileManager contentsOfDirectoryAtPath:directoryPath error:nil]; }

-(NSArray*)filesOfType:(NSString*) fileType inDirectory:(NSString*) directoryPath
{
    NSArray *directoryContent = [self contentsOfDirectory:directoryPath];

    NSMutableArray *files = [NSMutableArray new];
    for (NSString *eachFileName in directoryContent)
    {
        if ([eachFileName hasSuffix:[NSString stringWithFormat:@".%@", fileType]])
        {
            NSString *eachFilePath = [directoryPath stringByAppendingPathComponent:eachFileName];
            BOOL isDirectory = NO;
            [_fileManager fileExistsAtPath:eachFilePath isDirectory:(&isDirectory)];
            if(isDirectory == NO)
            {
                [files addObject:eachFilePath];
            }
        }
    }
    
    return [NSArray arrayWithArray:files];
}


#pragma mark - Delete files

-(BOOL)deleteFileAthPath:(NSString*) filePath
{
    NSError *error;
    [_fileManager removeItemAtPath:filePath error:&error];
    return (error == nil);
}

@end
