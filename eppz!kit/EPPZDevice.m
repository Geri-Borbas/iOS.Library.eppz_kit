//
//  EPPZDevice.m
//  eppz!kit
//
//  Created by Borbás Geri on 8/22/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZDevice.h"


static NSString *const kUnknownModelData = @"-";


typedef enum
{
    kGenerationIndex,   //0
    kVariantIndex,      //1
    kModelIndex,        //2
} EPPZDeviceModelDataIndices;



@interface EPPZDevice ()
@property (nonatomic, readonly) NSUInteger iOSversionInteger;
@property (nonatomic, readonly) NSDictionary *deviceModelDataForMachineIDs;
@property (nonatomic, strong) NSDictionary *deviceModelDataForMachineIDs_; //Lazy but still beauty.
@property (nonatomic, readonly) NSString *platform;
-(NSString*)getSysInfoByName:(char*) typeSpecifier;
@end


@implementation EPPZDevice

+(EPPZDevice*)sharedDevice { return (EPPZDevice*)[self sharedInstance]; }


#pragma mark - iOS version detect

-(float)iOSversion { return [[[UIDevice currentDevice] systemVersion] floatValue]; }
-(NSUInteger)iOSversionInteger { return floor(self.iOSversion); }
-(BOOL)iOS5 { return (self.iOSversionInteger == 5); }
-(BOOL)iOS6 { return (self.iOSversionInteger == 6); }
-(BOOL)iOS7 { return (self.iOSversionInteger == 7); }


#pragma mark - Platform detect

-(NSDictionary*)deviceModelDataForMachineIDs
{
    // See 'iOS device model identifiers.xlsx' for details.
    return @{
    
             //iPad.
             @"iPad1,1" : @[ @"iPad 1G", @"Wi-Fi / GSM", @"A1219 / A1337" ],
             @"iPad2,1" : @[ @"iPad 2", @"Wi-Fi", @"A1395" ],
             @"iPad2,2" : @[ @"iPad 2", @"GSM", @"A1396" ],
             @"iPad2,3" : @[ @"iPad 2", @"CDMA", @"A1397" ],
             @"iPad2,4" : @[ @"iPad 2", @"Wi-Fi Rev A", @"A1395" ],
             @"iPad2,5" : @[ @"iPad mini", @"Wi-Fi", @"A1432" ],
             @"iPad2,6" : @[ @"iPad mini", @"GSM", @"A1454" ],
             @"iPad2,7" : @[ @"iPad mini", @"GSM+CDMA", @"A1455" ],
             @"iPad3,1" : @[ @"iPad 3", @"Wi-Fi", @"A1416" ],
             @"iPad3,2" : @[ @"iPad 3", @"GSM+CDMA", @"A1403" ],
             @"iPad3,3" : @[ @"iPad 3", @"GSM", @"A1430" ],
             @"iPad3,4" : @[ @"iPad 4", @"Wi-Fi", @"A1458" ],
             @"iPad3,5" : @[ @"iPad 4", @"GSM", @"A1459" ],
             @"iPad3,6" : @[ @"iPad 4", @"GSM+CDMA", @"A1460" ],
             @"iPad4,1" : @[ @"iPad Air", @"Wi‑Fi", @"A1474" ],
             @"iPad4,2" : @[ @"iPad Air", @"Cellular", @"A1475" ],
             @"iPad4,4" : @[ @"iPad mini 2", @"Wi‑Fi", @"A1489" ],
             @"iPad4,5" : @[ @"iPad mini 2", @"Cellular", @"A1517" ],
             @"iPad4,6" : @[ @"iPad mini 2", @"N/A", @"A1491" ],
             @"iPad4,7" : @[ @"iPad mini 3", @"N/A", @"A1599" ],
             @"iPad4,8" : @[ @"iPad mini 3", @"N/A", @"A1600" ],
             @"iPad4,9" : @[ @"iPad mini 3", @"N/A", @"A1601" ],
             @"iPad5,3" : @[ @"iPad Air 2", @"N/A", @"A1566" ],
             @"iPad5,4" : @[ @"iPad Air 2", @"N/A", @"A1567" ],
             
             //iPhone.
             @"iPhone1,1" : @[ @"iPhone 2G", @"GSM", @"A1203" ],
             @"iPhone1,2" : @[ @"iPhone 3G", @"GSM", @"A1241 / A13241" ],
             @"iPhone2,1" : @[ @"iPhone 3GS", @"GSM", @"A1303 / A13251" ],
             @"iPhone3,1" : @[ @"iPhone 4", @"GSM", @"A1332" ],
             @"iPhone3,2" : @[ @"iPhone 4", @"GSM Rev A", @"-" ],
             @"iPhone3,3" : @[ @"iPhone 4", @"CDMA", @"A1349" ],
             @"iPhone4,1" : @[ @"iPhone 4S", @"GSM+CDMA", @"A1387 / A14311" ],
             @"iPhone5,1" : @[ @"iPhone 5", @"GSM", @"A1428" ],
             @"iPhone5,2" : @[ @"iPhone 5", @"GSM+CDMA", @"A1429 / A14421" ],
             @"iPhone5,3" : @[ @"iPhone 5C", @"GSM", @"A1456 / A1532" ],
             @"iPhone5,4" : @[ @"iPhone 5C", @"Global", @"A1507 / A1516 / A1526 / A1529" ],
             @"iPhone6,1" : @[ @"iPhone 5S", @"GSM", @"A1433 / A1533" ],
             @"iPhone6,2" : @[ @"iPhone 5S", @"Global", @"A1457 / A1518 / A1528 / A1530" ],
             @"iPhone7,2" : @[ @"iPhone 6", @"N/A", @"A1549 / A1586" ],
             @"iPhone7,1" : @[ @"iPhone 6 Plus", @"N/A", @"A1522 / A1524" ],
             
             //iPod.
             @"iPod1,1" : @[ @"iPod touch 1G", @"-", @"A1213" ],
             @"iPod2,1" : @[ @"iPod touch 2G", @"-", @"A1288" ],
             @"iPod3,1" : @[ @"iPod touch 3G", @"-", @"A1318" ],
             @"iPod4,1" : @[ @"iPod touch 4G", @"-", @"A1367" ],
             @"iPod5,1" : @[ @"iPod touch 5G", @"-", @"A1421 / A1509" ]
    
    };
}


#pragma mark - Platform detect (human readability)

-(NSString*)platform
{ return [self getSysInfoByName:"hw.machine"]; }

-(NSString*)machineID
{ return [self platform]; }

-(NSString*)generation
{
    NSArray *modelData = [self.deviceModelDataForMachineIDs objectForKey:self.platform];
    if (modelData.count > kGenerationIndex)
        return modelData[kGenerationIndex];
    return kUnknownModelData;
}

-(NSString*)variant
{
    NSArray *modelData = [self.deviceModelDataForMachineIDs objectForKey:self.platform];
    if (modelData.count > kVariantIndex)
        return modelData[kVariantIndex];
    return kUnknownModelData;
}

-(NSString*)model
{
    NSArray *modelData = [self.deviceModelDataForMachineIDs objectForKey:self.platform];
    if (modelData.count > kModelIndex)
        return modelData[kModelIndex];
    return kUnknownModelData;
}

-(NSString*)platformString { return [self platformDescription]; }
-(NSString*)platformDescription
{
    //Get device info and identified aliases.
    NSArray *modelData = [self.deviceModelDataForMachineIDs objectForKey:self.platform];
    
    //Return raw platform string if not identified yet.
    if (modelData == nil) return [NSString stringWithFormat:@"Unknown: %@", self.platform];
    
    //Return human readable platform string.
    NSString *platformDescription = [NSString stringWithFormat:@"%@ %@ (%@)", self.generation, self.variant, self.model];
    return platformDescription;
}


#pragma mark - Platform detect (lower level)

-(NSDictionary*)platformStringsForMachineIDs_
{
    if (_deviceModelDataForMachineIDs_ == nil)
        _deviceModelDataForMachineIDs_ = self.deviceModelDataForMachineIDs;
    return _deviceModelDataForMachineIDs_;
}

-(NSString*)getSysInfoByName:(char*) typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}


#pragma mark - Identifiers

-(NSString*)vendorIdentifier
{ return [UIDevice currentDevice].identifierForVendor.UUIDString; }


#pragma mark - Battery

-(float)batteryPercentage
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [[UIDevice currentDevice] batteryLevel];
}


@end
