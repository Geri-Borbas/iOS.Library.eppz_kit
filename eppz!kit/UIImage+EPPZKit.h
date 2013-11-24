//
//  UIImage+EPPZKit.h
//  eppz!kit
//
//  Created by Gardrobe on 11/23/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPPZFileManager.h"


typedef enum
{
    UIImageFileFormatJPG,    //0
    UIImageFileFormatPNG     //1
} UIImageFileFormat;



@interface UIImage (EPPZKit)

-(void)saveToDocuments;
-(void)saveToDocumentsWithFileName:(NSString*) fileName;
-(void)saveToDocumentsWithFileName:(NSString*) fileName format:(UIImageFileFormat) format;

-(void)saveToCache;
-(void)saveToCacheWithFileName:(NSString*) fileName;
-(void)saveToCacheWithFileName:(NSString*) fileName format:(UIImageFileFormat) format;

@end
