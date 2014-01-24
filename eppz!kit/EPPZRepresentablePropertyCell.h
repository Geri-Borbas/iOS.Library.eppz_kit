//
//  EPPZRepresentablePropertyCell.h
//  eppz!kit
//
//  Created by Gardrobe on 1/24/14.
//  Copyright (c) 2014 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EPPZRepresentable.h"


@interface EPPZRepresentablePropertyCell : UITableViewCell

@property (nonatomic, readonly) BOOL isDisclosing;
@property (nonatomic, readonly) NSString *propertyName;

+(id)configuredCellInTableView:(UITableView*) tableView
                         index:(NSUInteger) index
                 representable:(NSObject<EPPZRepresentable>*) representable
      dictionaryRepresentation:(NSDictionary*) dictionaryRepresentation;

@end
