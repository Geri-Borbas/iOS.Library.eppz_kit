## ![eppz!kit](http://www.eppz.eu/beacons/eppz!.png) eppz!kit
The collection of the usefuls.

#### EPPZUserDefaults
A really convenient way to store objects in NSUserDefault without any piece of boilerplate code. See the testbed project and the corresponding article on design at [eppz!settings](https://github.com/eppz/eppz-settings).
```
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
```
//Get status on-demand.
[EPPZReachability reachHost:hostNameOrIPaddress
               completition:^(EPPZReachability *reachability)
{
    if (reachability.reachable) [self postSomething];
}];
```

#### EPPZFlatButton
A helper class that works well with a darkgrey colored Custom button in Interface Builder. I use it mainly in prototype project, not relly meant for production.

#### EPPZFileManager
Actually a wrapper around `NSFileManager`, some aliases that keeps controller codes clean. See header file for feature set so far.
```
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
