//
//  MapViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "MapViewController.h"

#import "NAOServicesConfig.h"
#import "SmartPark.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    NSString *apiKey;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SmartPark Map";
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    self.locationHandle = [[NAOLocationHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    
    if (self.parkingSlot != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.parkingSlot forKey:KEY_PARKING_SLOT];
        [userDefaults synchronize];
    } else {
        self.parkingSlot = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PARKING_SLOT];
    }
    
    if (self.parkingSlot != nil) {
        [self displayParkingSlotDialog];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.locationHandle != nil) {
        NSLog(@"NAODemoApp : SmartPark : MapView : Map visible : Start location");
        [self.locationHandle start];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.locationHandle != nil) {
        NSLog(@"NAODemoApp : SmartPark : MapView : Map not visible : Stop location");
        [self.locationHandle stop];
    }
}

-(void)displayParkingSlotDialog {
    NSString *message = [NSString stringWithFormat:@"Your parking slot is %@.", self.parkingSlot];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parking slot"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    //NSLog(@"NAODemoApp : SmartPark : MapView : didLocationChange : Location: %.6f,%.6f,%.3f,%.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course);
    [self.mapLabel setText:[NSString stringWithFormat:@"Location: %.6f,%.6f,%.3f,%.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course]];
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSLog(@"NAODemoApp : SmartPark : MapView : Error: %@", message);
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
    NSString* statusString = [self stringFromStatus:status];
    NSLog(@"NAODemoApp : SmartPark : MapView : status : %@", statusString);
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
    NSLog(@"NAODemoApp : SmartPark : MapView : didEnterSite:%@", name);
    
    if (self.parkingSlot == nil) {
        SmartPark *smartPark = [[SmartPark alloc] init];
        [smartPark startLocation];
    }
}

- (void) didExitSite:(NSString *)name {
    NSLog(@"NAODemoApp : SmartPark : MapView : didExitSite:%@", name);
}

#pragma mark - NAOSensorsDelegate

- (void) requiresBLEOn {
    NSLog(@"NAODemoApp : SmartPark : MapView : requiresBLEOn");
}

- (void) requiresWifiOn {
    NSLog(@"NAODemoApp : SmartPark : MapView : requiresWifiOn");
}

- (void) requiresLocationOn {
    NSLog(@"NAODemoApp : SmartPark : MapView : requiresLocationOn");
}

- (void) requiresCompassCalibration {
    NSLog(@"NAODemoApp : SmartPark : MapView : requiresCompassCalibration");
}


#pragma mark - NAOSyncDelegate


- (void) didSynchronizationSuccess {
    NSLog(@"NAODemoApp : SmartPark : MapView : didSynchronizationSuccess");
}

- (void) didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : SmartPark : MapView : didSynchronizationFailure : %@", errorText);
}

@end
