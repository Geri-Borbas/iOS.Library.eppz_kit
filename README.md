## eppz!kit
[![Build Status](https://travis-ci.org/eppz/eppz.kit.svg?branch=master)](https://travis-ci.org/eppz/eppz.kit)

**The collection of the usefuls. Objective-C everydayers.** You could use it like
you would do with any other static library - as Apple recommends [Using Static Libraries in iOS](http://developer.apple.com/library/ios/#technotes/iOSStaticLibraries/Articles/configuration.html#//apple_ref/doc/uid/TP40012554-CH3-SW1)) -, or just grab some individual class that is not that tightly
coupled (just look at the imports at the top of .h files). Gonna put the whole library up on
[CocoaPods](http://cocoapods.org/) with submodules where appropriate. Google Analytics SDK
has some specific build settings (check the Analytics build settings.png for details).
Feel free to file a pull request if you spot some errors.

> ### [eppz!swizzler](https://github.com/eppz/eppz.swizzler)
> Basic swizzling wrapped up into an Objective-C interface.
> ```
> pod 'eppz!swizzler', '~> 0.1.1'
> ```
> ### [eppz!reachability](https://github.com/eppz/eppz.reachability)
> A block-based extraction of Apple's Reachability sample.
> ### [eppz!alert](https://github.com/eppz/eppz.alert)
> Simplest UIAlertView wrapper ever.


#### EPPZBinding
Keeps the properties of two objects synchronized along a given property map. If either value changes, it tries to set its matching property to the other object.
```Objective-C
// Keep a user model object synced with the UI, and vica-versa.
NSDictionary *map = @{
                      @"name" : @"nameTextField.text",
                      @"email" : @"emailTextField.text"
                      };
self.binding = [EPPZBinding bindObject:self.user
                            withObject:self
                           propertyMap:map];
```


#### NSDictionary extensions
Swap NSDictionary objects with keys.
```Objective-C
inverse = [this.map dictionaryBySwappingKeysAndValues];
```


#### EPPZRandom
Some random shortcuts.
```Objective-C
alpha = randomFloat();
index = randomIntegerInRange(length);
```


#### NSArray extensions
NSArray object picking.
```Objective-C
randomItem = [this.items randomObject];
nextItem = [this.items nextObjectAfterObject:currentItem];
```


#### UIColor extensions
Some handy `UIColor` tools to mix colors at runtime.
```Objective-C
overlayColor = [backgroundColor colorWithAlpha:0.5];
opaqueTextColor = [backgroundColor blendWithColor:foregroundColor amount:0.5];
```


#### UICircle
A lovely `UIImage` subclass that renders a circle. Comes in handy when debugging geometry.


#### EPPZDiatonicScale
This latest member is a really a specific piece of a class. Converts a single music interval value (expressed in semitones) into a pitch value (expressed in segments). Also can step back and forth on a diatonic major or minor scale and return pitch result for that.
```Objective-C
// Play effect pitched with major 5th.
float pitch = [self.diatonicScale pitchForNote:5];
[self.soundEngine playEffect:@"piano.wav" volume:1.0 pitch:pitch pan:1.0 loop:NO];
```


#### EPPZGeometry
Awesome geometry toolkit for intersecting lines, intersecting circles, whatnot.
```Objective-C
// Some examples.
CGRect bigger = rectFromRectWithMargin(original, spacing);
CGFloat radians = angleBetweenPoints(touchLocation, previousLocation);
CGVector rotated = rotateVector(handle, angle);
BOOL crossed = areLinesIntersecting(ray, wall);
BOOL hit = isPointOnLineWithTolerance(touchLocation, fence);
```


#### EPPZVersions
Tool that tells you useful app bundle version history information.
```Objective-C
if ([VERSIONS isFirstRun])
{ [self showWelcomeMessage]; }

if ([VERSIONS isFirstRunCurrentVersion])
{ [self showThanksForUpdatingMessage]; }

if ([VERSIONS hasBundleVersionEverInstalled:@"1.4.5"])
{ [self migrateSomethingIfNeeded]; }
```
It is effective only from the point the class has used for the first time. Do not persist between application installs (yet) since it uses NSUserDefaults.


#### EPPZRepresentable
A solid NSObject extension that makes work with models much easier. If a class conforms to the protocol, it marks that object to implement those features.
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
It will be just as easy to save into NSUserDefaults/NSKeyedArchiver/JSON string or even into a self-describing CoreData archive. In addition, it now supports saving object references, so it won't allocate duplicates on reconstruction. Still in progress.


#### EPPZAnalytics
A simple wrapper around Google Analytics iOS SDK 3.0 (Check Analytics build settings.png for specific build settings constraints). Were intended to be suitable to support multiple analytics service (Flurry, GameAnalytics, etc.), though only Google is implemented yet.


#### EPPZBoolTools
A helper function to make boolean syntax a bit more readable, and spare you some if statements.
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
A cool compositable object that reduces boilerplate for recognizing gestures. Also arranges some underlying stuff (e.g. double-tap does not block triple-tap).
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
An `NSTimer` wrapper that does not retain its target, and so unlikely to create retain cycles.
```Objective-C
//Just you'd normally do with NSTimer but without retain cycle.
self.timer = [EPPZTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(updateClock:)
                                              userInfo:nil
                                               repeats:YES];
```
The timer will invalidate itself when the target no longer exists. A check for taget existence is invoked in every invocation of the timer.


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


#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/005a730f8a23bffdb3ce994cc12e4e32 "githalytics.com")](http://githalytics.com/eppz/eppz-kit)

