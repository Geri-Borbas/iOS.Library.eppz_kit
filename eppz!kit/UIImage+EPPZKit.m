//
//  UIImage+EPPZKit.m
//  eppz!kit
//
//  Created by Gardrobe on 11/23/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "UIImage+EPPZKit.h"

@implementation UIImage (EPPZKit)


-(void)saveToDocuments
{
    NSString *fileName = [NSString stringWithFormat:@"%@", @(self.hash)];
    [self saveToDocumentsWithFileName:fileName];
}

-(void)saveToDocumentsWithFileName:(NSString*) fileName
{ [self saveToDocumentsWithFileName:fileName format:UIImageFileFormatJPG]; }

-(void)saveToDocumentsWithFileName:(NSString*) fileName format:(UIImageFileFormat) format
{
    // Either JPG or PNG data.
    NSData *data = (format == UIImageFileFormatJPG) ? UIImageJPEGRepresentation(self, 1.0) : UIImagePNGRepresentation(self);
    NSString *extension = (format == UIImageFileFormatJPG) ? @"jpg" : @"png";
    NSString *path = [FILES pathForNewFileNameInDocumentsDirectory:[fileName stringByAppendingPathExtension:extension]];
    [data writeToFile:path atomically:YES];
}

-(void)saveToCache
{
    NSString *fileName = [NSString stringWithFormat:@"%@", @(self.hash)];
    [self saveToCacheWithFileName:fileName];
}

-(void)saveToCacheWithFileName:(NSString*) fileName
{ [self saveToCacheWithFileName:fileName format:UIImageFileFormatJPG]; }

-(void)saveToCacheWithFileName:(NSString*) fileName format:(UIImageFileFormat) format
{
    // Either JPG or PNG data.
    NSData *data = (format == UIImageFileFormatJPG) ? UIImageJPEGRepresentation(self, 1.0) : UIImagePNGRepresentation(self);
    NSString *extension = (format == UIImageFileFormatJPG) ? @"jpg" : @"png";
    NSString *path = [FILES pathForNewFileNameInCacheDirectory:[fileName stringByAppendingPathExtension:extension]];
    [data writeToFile:path atomically:YES];
}


@end
