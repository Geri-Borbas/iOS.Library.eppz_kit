//
//  EPPZRepresentablePropertyCell.m
//  eppz!kit
//
//  Created by Gardrobe on 1/24/14.
//  Copyright (c) 2014 eppz!. All rights reserved.
//

#import "EPPZRepresentablePropertyCell.h"


@interface EPPZRepresentablePropertyCell ()
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSObject <EPPZRepresentable> *representable;
@property (nonatomic, strong) NSDictionary *dictionaryRepresentation;
@end


@implementation EPPZRepresentablePropertyCell


#pragma mark - Creation

+(id)configuredCellInTableView:(UITableView*) tableView
                         index:(NSUInteger) index
                 representable:(NSObject<EPPZRepresentable>*) representable
      dictionaryRepresentation:(NSDictionary*) dictionaryRepresentation
{
    // Cell instance.
    EPPZRepresentablePropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil)
    { cell = [[EPPZRepresentablePropertyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(self)]; }
    
    // Wire in models.
    cell.index = index;
    cell.representable = representable;
    cell.dictionaryRepresentation = dictionaryRepresentation;

    [cell configure];
    return cell;
}


#pragma mark - Model selection

-(NSString*)propertyNameForIndex:(NSUInteger) index
{
    // Show index for countables.
    if ([self.representable isKindOfClass:[NSArray class]])
    { return [NSString stringWithFormat:@"[%i]", (unsigned int)index]; }
    
    return self.dictionaryRepresentation.allKeys[index];
}

-(NSString*)valueForIndex:(NSUInteger) index
{
    // Show object for countables.
    if ([self.representable isKindOfClass:[NSArray class]])
    { return [(NSArray*)self.representable objectAtIndex:index]; }
    
    return [self.dictionaryRepresentation objectForKey:[self propertyNameForIndex:index]];
}

-(BOOL)isLeafValue:(id) value
{
    return (
            ([value isKindOfClass:[NSArray class]] == NO) &&
            ([value isKindOfClass:[NSDictionary class]] == NO) &&
            ([value isKindOfClass:[NSSet class]] == NO) &&
            ([value conformsToProtocol:@protocol(EPPZRepresentable)] == NO)
            );
}


#pragma mark - UI

-(void)configure
{
    // Property name.
    _propertyName = [self propertyNameForIndex:self.index];
    id value = [self valueForIndex:self.index];
    
    // Determine if there is something to disclose.
    _isDisclosing = ([self isLeafValue:value] == NO);
    
    // Display item count for countables.
    if ([value isKindOfClass:[NSArray class]] ||
        [value isKindOfClass:[NSSet class]])
    { value = [NSString stringWithFormat:@"%lu item(s)", (unsigned long)[value count]]; }
    
    // Display fixed type for representable.
    if ([value conformsToProtocol:@protocol(EPPZRepresentable)])
    { value = @"EPPZRepresentable"; }
    
    // Property type.
    NSString *propertyType = [self.representable typeOfPropertyNamed:self.propertyName];
    if ([self.representable isKindOfClass:[NSArray class]])
    { propertyType = NSStringFromClass([value class]); }
    if (propertyType == nil) propertyType = @"__eppz";
    
    // UI.
    self.textLabel.text = [NSString stringWithFormat:@"%@ : %@", propertyType, self.propertyName];
    self.detailTextLabel.text = [value description];
    self.accessoryType = (self.isDisclosing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}


@end
