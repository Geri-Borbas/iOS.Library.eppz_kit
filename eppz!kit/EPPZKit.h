//
//  EPPZKit.h
//  eppz!kit
//
//  Created by Borbás Geri on 7/15/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


static NSString *const kEPPZKitVersion = @"1.8.5";


//Base classes.
#import "EPPZSingleton.h"
#import "EPPZSingletonSubclass.h"

//Wrappers.
#import "EPPZAnalytics.h" //ANALYTICS_ (subclasses should define ANALYTICS)
#import "EPPZFileManager.h" //FILES
#import "EPPZDevice.h" //DEVICE
#import "EPPZReachability.h"
#import "NSString+EPPZReachability.h"
#import "EPPZAppStore.h" //APPSTORE_

//Tools.
#import "EPPZTools.h"
#import "EPPZBoolTools.h"
#import "NSDate+EPPZKit.h"
#import "NSString+EPPZKit.h"
#import "NSArray+EPPZKit.h"
#import "EPPZTimer.h"
#import "EPPZVersions.h" //VERSIONS_
#import "EPPZGeometry.h"
#import "EPPZDiatonicScale.h"
#import "NSDictionary+EPPZKit.h"
#import "EPPZBinding.h"

//UIKit tools.
#import "EPPZViewOwner.h"
#import "EPPZGestureRecognizer.h"
#import "EPPZFlatButton.h"
#import "EPPZAlert.h"
#import "EPPZPagingScrollViewController.h"
#import "EPPZTagFinder.h"
#import "EPPZLabel.h"
#import "UIImage+EPPZKit.h"
#import "UICircle.h"
#import "UIColor+EPPZKit.h"
#import "UIFont+EPPZKit.h"

//Model tools.
#import "EPPZUserDefaults.h"
#import "NSObject+EPPZRepresentable.h"
#import "EPPZRepresentableInspectorViewController.h"


