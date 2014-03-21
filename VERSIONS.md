
#### Version tracking

* 1.9.0 - 1.9.01

    + Added `eppz!swizzler` as git submodule
    + Added `eppz!reachability` as git submodule
    + Added `eppz!alert` as git submodule

* 1.8.9

    + UIColor NSString conversion imporvements
        + Tests
    + EPPZConfiguration
        + Tools to configure objects with plist
    + EPPZTools
        + count / repeat

* 1.8.8

    + EPPZDevice.batteryPercentage
    + EPPZGeometry
    + NSString, NSDictionary helpers
    + EPPZRepresentable representation order (tracking of already represented objects)    

* 1.8.5 - 1.8.51

    + Updated Google Analytics SDK to 3.03
        + armv64 compilant
    + EPPZBinding
        + Attempt to eliminate redundant bindings
        + Suspended test for a while

* 1.8.45

    + Attempt to swizzle bound object's dealloc
        + Won't use in production

* 1.8.3 - 1.8.4

    + EPPZRepresentableInspectorViewController
        + A really lovely way to inspect representable objects at runtime
        + Cell implementation (a bit rough, but does the job for now)
        + Testbed scene for representables

* 1.8.2

    + EPPZBinding
        + Wording (left, right)
        + Can create binding with formatter blocks for values (undocumented yet)

* 1.8.01 - 1.8.03

    + Wording

* 1.8.0

    + More Tests
        + See Project/eppz!kit!tests/❑ Tools ✔

* 1.7.9
    + NSDictionary+EPPZKit
        + dictionaryByRemovingValueForKey (with tests)
    + EPPZRepresentable 
        + New template `+(BOOL)representEmptyValues`
        + Represent / reconstruct NSSets (handy with CoreData)

* 1.7.8
    + EPPZPropertySynchronizator fixes
    + Tests for dateValue (NSString+EPPZKit)

* 1.7.7
    + NSString+EPPZKit
        + Some drawing compatibility helper
    + More test cases

* 1.7.6
    + More test cases

* 1.7.5
    + Travis Ci setup

* 1.7.4
    + Created unit test target
    + Added NSArray+EPPZKit tests

* 1.7.2 - 1.7.3
    + Merge changes

* 1.7.1
    + NSDictionary+EPPZKit
    + EPPZPropertySynchronizator
    + Tiny EPPZRepresentable hack

* 1.6.9
    + EPPZRepresentable handles NSSet reconstruction

* 1.6.8
    + `-(NSDate*)dateValue;` string extension
        + With some tests

* 1.6.7
    + EPPZRepresentable features
        + See EPPZRepresentable.rtf for details

* 1.6.6
    + EPPZRandom
    + NSArray+EPPZKit
    + UIFont+EPPZKit
    + EPPZDevice
        + Included new device releases

* 1.6.6

    + Added EPPZRandom
        + Also randomObject to NSArray extensions

* 1.6.5

    + Added UICircle
    + Added some UIImage extension (save to Documents or Cache)
    + Fixes in EPPZGeometry
    + Testbed for geometry functions
        + With touch bindings

* 1.6.3

    + Testbed refactoring
        + Some menu
        + Testbed for test CGLine features

* 1.6.2

    + Some Analytics fix (only session start)
    + NSArray extensions
    + Updates on EPPZViewOwner

* 1.6.1

    + EPPZDiatonicScale

* 1.6.0

    + EPPZGeometry
        + Collection of the most of the geometry functions I've used lately

* 1.5.5

    + EPPZAnalytics
        + Updated SDK
    + EPPZRepresentable
        + Fixes
        + Added exceptions
        + Represent collections
        + Attempt to represent any object

* 1.5.1.2

    + EPPZAppStore fixes
        + Unlimited retries when offline is gone
    + EPPZAnalytics
        + Session end is sent along an event hit

* 1.5.1

    + EPPZVersions added

* 1.5.0.6

    + Extremely useful `crash();` function added

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