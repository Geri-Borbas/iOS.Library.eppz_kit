//
//  EPPZColorThemeTestbed.m
//  eppz!kit
//
//  Created by Borbás Geri on 12/1/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZColorThemeTestbed.h"

// Declare the availability of a particular API
void f(void) __attribute__((availability(macosx,introduced=10.4,deprecated=10.6)));

// Project constants.
enum { EPPZViewAutoresizingNone};
static NSString *const _yes = @"YES";
static NSString *const _no = @"NO";

// Project preprocessor macros.
#define NSStringFromBool(bool) (bool) ? _yes : _no
#define EPPZ_COLOR [UIColor colorWithRed:0.5 green:0.4 blue:0.6 alpha:0.1]

// Project type.
typedef struct { float value; } EPPZFloat;

@interface EPPZColor : UIColor
@end

@interface ProjectClass : NSObject
+(id)projectFactory;
@end

@implementation ProjectClass
+(id)projectFactory
{ return [self new]; }
@end


@interface EPPZColorThemeTestbed ()
@property (nonatomic, strong) UIView *projectVariable;
@end


@implementation EPPZColorThemeTestbed

-(void)awakeFromNib
{
    // Teal-greenish is what you're doing.
    // Red-yellow is subject you're doing with.
    // Blueish are strings, numbers, URLs, all the static stuff.
    
    // Class names.
    UIDatePicker *common = [UIDatePicker new]; // Framework -> enlighted
    ProjectClass *custom = [ProjectClass new];  // Project -> strong
    
    // Class methods.
    ProjectClass *this = [ProjectClass new]; // Framework -> enlighted
    ProjectClass *that = [ProjectClass projectFactory]; // Project -> strong
    
    // Type names.
    CGFloat commonType; // Type enlighted compared to class.
    UIColor *commonClass;
    EPPZFloat customType; // Type enlighted compared to class.
    EPPZColor *customClass;
    
    // Instance methods.
    [super awakeFromNib]; // Framework -> enlighted
    [self projectMethod]; // Project -> strong
    
    // Instance variables.
    self.backgroundColor = [UIColor new]; // Framework -> enlighted
    self.projectVariable = [UIView new]; // Project -> strong
    
    // Constants.
    self.projectVariable.autoresizingMask = UIViewAutoresizingNone; // Framework -> enlighted
    self.projectVariable.autoresizingMask = EPPZViewAutoresizingNone; // Project -> strong

    // Preprocessor macros (like methods).
    NSString *commonized = NSLocalizedString(nil, nil); // Framework -> enlighted
    NSString *customized = NSStringFromBool(NO); // Project -> strong
    UIColor *color = EPPZ_COLOR;
    
    // Strings.
    id string = @"eppz! development, LLC";
    id message = @"appcrafting since 2010";
    
    // Characters.
    char character = 'c';
    
    // Numbers.
    id number = @(2013);
    commonType = 1 + 2 * 3 / 4;
    
    // URLs http://twitter.com/_eppz
    
    // Keywords (considered 'boilerplate' so enlighted)
    SEL method = @selector(projectMethod); // Method not colored by xCode here :(
    
// Preprocessor statements (similar to default).
#ifdef DEBUG
#endif
    
    // Attributes (same as keywords).
    NSString *arcOnly __attribute__((visibility("default")));
    
    // Supress 'Unused variable' warnings.
    NSLog(@"%@%@ %@%@ %f%@%f%@ %@%@%@ %@%@%i%@ %@ %@",
          common,
          custom,
          
          this,
          that,
          
          commonType,
          commonClass,
          customType.value,
          customClass,
          
          commonized,
          customized,
          color,
          
          string,
          message,
          character,
          number,
          
          NSStringFromSelector(method),
          
          arcOnly
          );
}

-(void)projectMethod
{ /* Template */ }

@end
