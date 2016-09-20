//
//  SmartParkViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 07/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "SmartPark.h"

#import "NAOServicesConfig.h"

#import "NaoContext.h"
#import "NAOServicesConfig.h"

@interface SmartPark ()

@end

@implementation SmartPark {
    NSString *apiKey;
    int locationCount;
    BOOL isEnteredPark;
}

-(id)init {
    if ((self = [super init])) {
        self.notificationManager = [[NotificationManager alloc] init];
        apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
        locationCount = 0;
        isEnteredPark = NO;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:SMART_PARK_ON forKey:SMART_PARK_MODE];
        [userDefaults synchronize];
    }
    return self;
}

-(void)onEnterBeaconArea {
    [self.notificationManager displayNotificationWithMessage:@"Enter Beacon Area"];
    [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : onEnterBeaconArea : %p", self]];
    [self startGeofencing];
}


-(void)whenUserExitsCar {
    //NSLog(@"NAODemoApp : SmartPark : whenUserExitsCar");
    [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : whenUserExitsCar : %p", self]];
    isEnteredPark = NO;
    if ((self.carLocation != nil)) {
        [self.notificationManager displayParkingSlotNotificationWithparkingSlot:PARKING_SLOT startMapActivityKey:START_MAP_ACTIVITY_KEY parkingSlotKey:PARKING_SLOT_KEY];
    }
}

#pragma mark - NAO services

-(void)startGeofencing {
    if (self.geofencingHandle == nil) {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : startGeofencing : %p", self]];
    [self.geofencingHandle start];
}

-(void)stopGeofencing {
    if (self.geofencingHandle != nil) {
        [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : stopGeofencing : %p", self]];
        [self.geofencingHandle stop];
        self.geofencingHandle = nil;
    }
}

-(void)startLocation {
    if (self.locationHandle == nil) {
        self.locationHandle = [[NAOLocationHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : startLocation : %p", self]];
    [self.locationHandle start];
}

-(void)stopLocation {
    if (self.locationHandle != nil) {
        [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : stopLocation : %p", self]];
        [self.locationHandle stop];
        self.locationHandle = nil;
    }
}

#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    NSLog(@"NAODemoApp : SmartPark : didLocationChange : Location: %.6f,%.6f,%.3f,%.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course);
    
    self.carLocation = location;
    
    if (isEnteredPark) {
        locationCount ++;
        if (locationCount >= LOCATION_COUNT_BEFORE_EXIT_CAR) {
            locationCount = 0;
            [self whenUserExitsCar];
        }
    }
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSLog(@"Location Error: %@", message);
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
}


- (NSString*) stringFromStatus:(DBTNAOFIXSTATUS) status {
    switch (status) {
        case DBTNAOFIXSTATUS_NAO_FIX_UNAVAILABLE:
            return @"FIX_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_FIX_AVAILABLE:
            return @"AVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_TEMPORARY_UNAVAILABLE:
            return @"TEMPORARY_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_OUT_OF_SERVICE:
            return @"OUT_OF_SERVICE";
            break;
        default:
            return @"UNKNOWN";
            break;
    }
}



- (void) didEnterSite:(NSString *)name {
    NSLog(@"NAODemoApp : SmartPark : didEnterSite:%@", name);
    [self onEnterBeaconArea];
}

//- (void) didExitSite:(NSString *)name {
//    NSLog(@"NAODemoApp : SmartPark : didExitSite:%@", name);
//    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"NAODemoApp : SmartPark : didExitSite:%@", name]];
//}

#pragma mark - NAOGeofencingHandleDelegate

- (void) didFireNAOAlert:(NaoAlert *)alert {
    NSString *alertText = [NSString stringWithFormat:@" name=%@ content=%@", alert.name, alert.content];
    //[self.lastAlertLabel setText:[NSString stringWithFormat:@"Last alert :%@", alertText]];
    NSLog(@"NAODemoApp : SmartPark : didFireNAOAlert %@", alertText);
    
    if ([alert.name rangeOfString:@"Enter_Park"].location != NSNotFound) {
        NSString *parkName = alert.name;
        [parkName stringByReplacingOccurrencesOfString:@"Enter_Park" withString:@""];
        //NSLog(@"NAODemoApp : SmartPark : didFireNAOAlert : Enter park : %@", parkName);

        [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"SmartPark : Enter park : %@ : %p", parkName, self]];
        [self.notificationManager displayWelcomeToParkingNotificationWithParkingName:alert.name startMapActivityKey:START_MAP_ACTIVITY_KEY];
        [self stopGeofencing];
        isEnteredPark = YES;
    }
}

#pragma mark - NAOSensorsDelegate

- (void) requiresBLEOn {
    NSLog(@"NAODemoApp : SmartPark : requiresBLEOn");
}

- (void) requiresWifiOn {
    NSLog(@"NAODemoApp : SmartPark : requiresWifiOn");
}

- (void) requiresLocationOn {
    NSLog(@"NAODemoApp : SmartPark : requiresLocationOn");
}

- (void) requiresCompassCalibration {
    NSLog(@"NAODemoApp : SmartPark : requiresCompassCalibration");
}


#pragma mark - NAOSyncDelegate


- (void) didSynchronizationSuccess {
    NSLog(@"NAODemoApp : SmartPark : didSynchronizationSuccess");
}

- (void) didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : SmartPark : %@", errorText);
}


@end
