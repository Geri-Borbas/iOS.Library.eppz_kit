## ![eppz!kit](http://www.eppz.eu/beacons/eppz!.png) eppz!kit
**The collection of the usefuls. Objective-C everydayers.** You could use it like you would do with any other static library (as Apple recommends [Using Static Libraries in iOS](http://developer.apple.com/library/ios/#technotes/iOSStaticLibraries/Articles/configuration.html#//apple_ref/doc/uid/TP40012554-CH3-SW1)), or just grab some individual class, they are not that coupled (just watch the imports at the top of .h files).


#### EPPZRepresentable
A solid NSObject extension that makes work with models much easier. If a class conforms to the protocol than it mark that object to implement such features.
Yet objects able to represent themselves in a dictionary form that allows me to create many store implementation (Defaults, Archiver, CoreData, JSON, Plist, Keychain, whatnot). In progress, though `plist` implementation actually works. Saving foreign classes (like UIViews for example) is also possible. Actually an archiver with much less boilerplate. Example from the testbed project:
```Objective-C
//A UIView extension to make it persistable

@interface UIView (EPPZRepresentable) <EPPZRepresentable>
@end

@implementation UIView (EPPZRepresentable)
+(NSArray*)representablePropertyNames
{ return @[ @"frame", @"bounds", @"center", @"transform", @"tag" ]; }
@end


//A model object.

@interface EPPZGameProgress : NSObject <EPPZRepresentable>
@property (nonatomic) NSUInteger progress;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) UIView *view;
@end

@implementation EPPZGameProgress
@end


//Saving somewhere in a controller code.
[progress storeAsPlistNamed:@"gameProgress"];


//Restoring later on.
progress = [EPPZGameProgress representableWithPlistNamed:@"gameProgress"];
```
It will be just as easy to save into NSUserDefaults/NSKeyedArchiver/JSON string or even into a self-describing CoreData archive. In addition, it is now supports saving object references, so won't allocate duplicates on reconstruction. Still in progress.


#### EPPZAnalytics
A simple wrapper around Google Analytics iOS SDK (3.0). Were intended to be suitable to support multiple analytics service (Flurry, GameAnalytics, etc.), thought only Google is implemented yet.


#### EPPZBoolTools
Some helper function to make boolean works a bit more readable and spare some if statements.
```Objective-C
//For debugging.
NSLog(@"Switched to %@.", stringFromBool(switch.isOn));

//For UI.
-(IBAction)switchValueChanged:(UISwitch*) switch
{ wrapper.alpha = floatFromBool(switch.isOn); }
```


#### EPPZDevice
A charming class showing running iOS version with shorties, and model detection as well.
```Objective-C
//iOS version detect.
if (DEVICE.iOS6)
{
    [self something];
}

//Device model.
NSLog(@"Running on an %@", DEVICE.platformDescription);
```


#### EPPZGestureRecognizer
A cool compositable object that reduces boilerplate for recognizing gestures. Also arranges some undelying stuff (e.g. double tap do not block triple tap).
```Objective-C
//A typical setup in a view controller.
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add gesture to close with.
    self.gestureRecognizer = [EPPZGestureRecognizer gestureRecognizerWithView:self.view delegate:self];
    [self.gestureRecognizer addSwipeDownGesture];
}

-(void)swipeDownEvent
{ [self close]; }
```


#### EPPZTimer
An `NSTimer` wrapper that does not retain it's target so not likely to create retain cycles.
```Objective-C
//Just you'd normally do with NSTimer but without retain cycle.
self.timer = [EPPZTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(updateClock:)
                                              userInfo:nil
                                               repeats:YES];
```
The timer will invalidate itself when the target is existing no more. A check for taget existence is invoked in every invocation of the timer.


#### EPPZLabel
A cool `UILabel` subclass that allows you to define bold ranges for a given text. It is using `EPPZTagFinder` for a feature where you can use `<strong>` tags for indicate bold ranges withing an `NSString`.
```Objective-C
//Using '<strong>' tags.
self.label.htmlString = @"Make <strong>this range</strong> bold.";
//Using a range.
self.label.boldRange = NSMakeRange(15, 5);
```
Prior iOS 6.0 it falls back to be an arbitary label. I did implemented a solution that uses `CATextLayer` to work this issue around in iOS 5.0 but it felt me too hacky, so I decided to stop support iOS 5.0 anymore.


#### NSDate+EPPZKit
With a sole feature for now that converts NSTimeInterval to something human readable. Converts `1500000.0` to `17 days 08:40:00` for example.
```Objective-C
//Supposing remainingTimeInterval is 1500000.0 it sets '17 days 08:40:00' as the label text.
self.countDownLabel.text = [NSDate diplayStringOfInterval:remainingTimeInterval];
```

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

* 1.5.0.5

    + EPPZRepresentable improvements
        + Can populate key paths not just keys
            + Only for existing objects (of course)
                + Subclasses can implement `-(void)willLoad;` to create blank objects to populate via keypaths
            + Still the `(EPPZRepresentable)` category is the preferred way (since it allocates the instance as well)
        + NSKeyedArchiver implementation just sketched up

* 1.5.0

    + EPPZRepresentable improvements
        + Tracks references
            + Generate IDs from memory address of each object at representing
            + Reconstruct referenced objects properly using stored IDs

* 1.4.8.9

    + EPPZRepresentable improvements
        + Lovely NSStringFromUIColor extension
        + CGRect, CGPoint, CGSize, CGAffineTransform now stored/restored in plist

* 1.4.8.1

    + EPPZAnalytics misspelling

* 1.4.8

    + EPPZAnalytics upgraded to Google Analytics iOS SDK 3.0
        + Now registring dimensions is a must-have for subclasses

* 1.4.6

    + EPPZAnalytics addded
    + EPPZDevice addons
        + machineID, platformDescription
        + Updated device info from The iPhone Wiki

* 1.4.5

    + EPPZRepresentable milestones achieved
    + EPPZTools (with a neat _LOG macro)

* 1.4.2

    + Headers (MIT License, twitter donations)

* 1.4.1

    + EPPZBoolTools added

* 1.4.0

    + EPPZRepresentable changes

* 1.3.4

    + Removed prefix header entirely (to force import dependencies in every header)
    + Some grouping of classes
    + EPPZRepresentable kicked off with some tests
        + Representing works well over class hirearchy
        + Stores class name for restoration

* 1.3.3

    + EPPZDevice added
    + EPPZLabel's <strong> feature is an iOS 6.0+ feature
        + Tired of iOS 5.0 workaround. As a fallback text is not bold on iOS 5.0, voila! Progressive enhancement.
    + Explicit import of frameworks and dependencies of every class (removed everything from prefix.pch)

* 1.3.2

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
