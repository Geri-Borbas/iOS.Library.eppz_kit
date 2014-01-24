//
//  EPPZRepresentableInspectorViewController.m
//  eppz!kit
//
//  Created by Borbás Geri on 1/23/14.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZRepresentableInspectorViewController.h"


@interface EPPZRepresentableInspectorViewController ()

@property (nonatomic, strong) UINavigationController *navigationController_;
@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, strong) NSObject <EPPZRepresentable> *representable;
@property (nonatomic, strong) NSDictionary *dictionaryRepresentation;
@property (nonatomic, readonly) BOOL isTopLevelController;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation EPPZRepresentableInspectorViewController


#pragma mark - Creation

+(void)presentInViewController:(UIViewController*) viewController
             withRepresentable:(NSObject<EPPZRepresentable>*) representable
{
    EPPZRepresentableInspectorViewController *instance = [[self alloc] initWithViewController:viewController representable:representable];
    [instance present];
}

-(id)initWithViewController:(UIViewController*) viewController representable:(NSObject<EPPZRepresentable>*) representable
{
    if (self = [super init])
    {        
        // Save.
        self.superViewController = viewController;
        self.representable = representable;
        self.dictionaryRepresentation = representable.dictionaryRepresentation;
        
        // Build.
        [self build];
    }
    return self;
}

-(BOOL)isTopLevelController
{ return ([self.superViewController isKindOfClass:[self class]] == NO); }

-(void)build
{
    // Wrap into a navigation controller if a top level stuff.
    if (self.isTopLevelController)
    {
        self.navigationController_ = [[UINavigationController alloc] initWithRootViewController:self];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                               target:self
                                                                                               action:@selector(dismiss)];
    }
    
    // Add table view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // Title.
    self.title = NSStringFromClass(self.representable.class);
}


#pragma mark - Transitions

-(void)present
{
    // Top level controller is presented on super controller.
    if (self.isTopLevelController)
    {
        // Form sheet on iPad.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        { self.navigationController_.modalPresentationStyle = UIModalPresentationFormSheet; }
        [self.superViewController presentViewController:self.navigationController_ animated:YES completion:nil];
    }
    
    // Sub controllers are pushed into the navigation stack.
    else
    { [self.superViewController.navigationController pushViewController:self animated:YES]; }
    
    // Reload data.
    [self.tableView reloadData];
}

-(void)dismiss
{ [self.superViewController dismissViewControllerAnimated:YES completion:nil]; }


#pragma mark - Table view

-(NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    if ([self.representable isKindOfClass:[NSArray class]])
    { return [(NSArray*)self.representable count]; }
    
    return self.dictionaryRepresentation.count;
}

-(UITableViewCell*)tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return [EPPZRepresentablePropertyCell configuredCellInTableView:tableView
                                                              index:indexPath.row
                                                      representable:self.representable
                                           dictionaryRepresentation:self.dictionaryRepresentation];
}


#pragma mark - Navigation

-(void)tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    EPPZRepresentablePropertyCell *cell = (EPPZRepresentablePropertyCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isDisclosing == NO) return;
    
    // Model.
    NSObject <EPPZRepresentable> *representable = [self.representable valueForKey:cell.propertyName];
    
    // Present (push).
    [EPPZRepresentableInspectorViewController presentInViewController:self
                                                    withRepresentable:representable];
}



@end
