## ![eppz!kit](http://www.eppz.eu/beacons/eppz!.png) eppz!kit
**The collection of the usefuls. Objective-C everydayers.** You could use it like you would do with any other static library (as Apple recommends [Using Static Libraries in iOS](http://developer.apple.com/library/ios/#technotes/iOSStaticLibraries/Articles/configuration.html#//apple_ref/doc/uid/TP40012554-CH3-SW1)), or just grab some individual class, they are not that coupled (just watch the imports).


#### EPPZGestureRecognizer
A cool compositable object that reduces boilerplate for recognizing gestures. Also arranges some undelying stuff (e.g. double tap do not block triple tap).


#### EPPZTimer
An `NSTimer` wrapper that does not retain it's target so not likely to create retain cycles.


#### EPPZLabel
A cool `UILabel` subclass that allows you to adjust a `boldRange` property and a `bondFont` class method. Using attributed string under the hood (in iOS 6.0+ it is useless by the way).


#### NSDate+EPPZKit
With a sole feature for now that converts NSTimeInterval to something human readable. Converts `1500000.00` to `17 days 08:40:00` for example.


#### EPPZPagingScrollViewController
Astonishing paging `UIScrollView` with `UIPageControl` controller. Just drop-in this controller object into an Interface Builder file, hook up `scrollView`, `contentView` and `pageControl` outlets, and wire it in as the `delegate` for the `UIScrollView`. It calculates the number of pages based on the content size. Note that you have to retain this object somehow to survive after XIB loading (I usually create a `strong` `IBOutlet` for this in the containing controller, that does the job well).


#### EPPZAppStore
App Store with blocks, multiple async requests, restoring purchases, store recipes.
```Objective-C
//Populate UI with check on purchased state.
-(void)refreshStoreUI
{
    self.levelPackView.purchased = [APPSTORE isProductPurchased:kLevelPackIdentifier];
}

//Get product details.
[APPSTORE requestProductDetails:kLevelPackIdentifier
                        success:^(SKProduct *product)
{
    [self.levelPackView refreshWithProduct:product];
} error:nil];

//Purchase (with encapsulated network error handling).
[APPSTORE purchaseProduct:kLevelPackIdentifier
                  success:^(NSString *productIdentifier)
{
    [self refreshStoreUI];
} error:nil];

//Same for restore purchases.
[APPSTORE restorePurchasesWithSuccess:^
{
    [self refreshStoreUI];
} error:nil];
```


#### EPPZViewOwner
A handy helper object to assis encapsulation of Xib loading. More on [http://eppz.eu/blog/uiview-from-xib/](http://eppz.eu/blog/uiview-from-xib/) about this method.


#### EPPZUserDefaults
A really convenient way to store objects in NSUserDefault without any piece of boilerplate code. See the testbed project and the corresponding article on design at [eppz!settings](https://github.com/eppz/eppz-settings).
```Objective-C
//Just create a model object, and done.
@interface EPPZSettings : EPPZUserDefaults

@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL sound;
@property (nonatomic) float volume;
@property (nonatomic) BOOL messages;
@property (nonatomic) BOOL iCloud;

@end
```


#### EPPZReachability
A pretty thin block-based reachability implementation. See the testbed project and the corresponding article on design at [eppz!reachability](https://github.com/eppz/eppz-reachability).
```Objective-C
//Get status on-demand.
[EPPZReachability reachHost:hostNameOrIPaddress
               completition:^(EPPZReachability *reachability)
{
    if (reachability.reachable) [self postSomething];
}];
```


#### EPPZFlatButton
A helper class that works well with a darkgrey colored Custom button in Interface Builder. I use it mainly in prototype projects, not relly meant for production.


#### EPPZFileManager
Actually a wrapper around `NSFileManager`, some aliases that keeps controller codes clean. See header file for feature set so far.
```Objective-C
NSString *documentPath = [FILES pathForNewFileNameInDocumentsDirectory:documentFileName];
BOOL exists = [FILES fileExistsAtPath:documentPath];
BOOL aged = [FILES file:documentPath modifiedAfterDate:lastWeek];
NSArray *documents = [FILES filesOfType:extension inDirectory:FILES.documentsDirectory];
```


#### NSString+EPPZKit
Some useful `NSString` extension especially for network applications, for HTTP request issues. Class- and instance methods goes like `md5`, `urlEncode`, `urlDecode`.


#### EPPZSingleton
A singleton base class from the pre-ARC era. Main feature is that this class is safe to subclass it, and can have multiple delegates. Will rewrite to ARC compilant using `dispathc_once` with far less code soon.


#### Version tracking

*1.3.2

    + EPPZGestureRecognizer added
    + EPPZTagFinder and EPPZLabel got closer

* 1.3.1

    + EPPZLabel added
    + EPPZTagFinder kicked off, though it is not working yet

* 1.3.0
    + EPPZTimer added
    + EPPZAppStore retry
        + Now retries product detail requests older than 8 seconds
        + Or the one that returns without product (why does it such a thing at all anyway?)

* 1.2.8
    + EPPZAppStore tuning
        + Exposed SKPayementTransactions in callback blocks
        + Removed reachability, use corresponding SKProduct delegate method instead

* 1.2.7
    + Added NSDate+EPPZKit

* 1.2.5
    + EPPZAppStore tuning
        + Product details callbacks stored by SKProductsRequest (ensure multiply requests to the same product at once)

* 1.2.0
    + Awesome Drop-In App Store wrapper
        + EPPZAppStore
        + EPPZViewOwner

* 1.0.1
    + New members on the board
        + EPPZReachability 
        + EPPZFlatButton
        + EPPZUserDefaults
    + Now built with `-ObjC` linker flag to compile categories right

* 1.0.0
    + Added Some classics
        + EPPZSingleton
        + EPPZFileManager
        + NSString+EPPZKit
    + Built library is copied back to the project folder

#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/005a730f8a23bffdb3ce994cc12e4e32 "githalytics.com")](http://githalytics.com/eppz/eppz-kit)
