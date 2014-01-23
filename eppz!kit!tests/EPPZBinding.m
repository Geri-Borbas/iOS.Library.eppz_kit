//
//  _EPPZPropertySynchronizator.m
//  eppz!kit
//
//  Created by Borbás Geri on 21/01/14.
//  Copyright (c) 2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>


@interface _Model : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation _Model
@end


@interface _EPPZPropertySynchronizator : XCTestCase
@property (nonatomic, strong) EPPZPropertySynchronizator *synchronizator;
@end


@implementation _EPPZPropertySynchronizator


-(void)test
{
    _Model *model = [_Model new];
    UITextField *textField = [UITextField new];
    NSDictionary *propertyMap = @{
                                  @"name" : @"text"
                                  };
    
    self.synchronizator = [EPPZPropertySynchronizator synchronizatorWithObject:model
                                                                        object:textField
                                                                   propertyMap:propertyMap];
    
    // Sync model change.
    model.name = @"John Doe";
    XCTAssertEqualObjects(textField.text, @"John Doe", @"Property `textField.text` should be synchronized.");
    
    // Sync UI change.
    textField.text = @"Uma Thurman";
    XCTAssertEqualObjects(model.name, @"Uma Thurman", @"Property `model.name` should be synchronized.");

}


@end
