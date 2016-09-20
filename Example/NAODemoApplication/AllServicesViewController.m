//
//  AllServicesViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 23/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "AllServicesViewController.h"

@implementation AllServicesViewController{
    NSString *apiKey;
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
}

@synthesize locationHandle;
@synthesize statusLabel, locationLabel;

- (void) viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    locationLabel.text = @"Location:longitude, latitude, altitude, heading";
    statusLabel.text = @"Status: status";
    
    if (self.locationHandle == nil) {
        self.locationHandle = [[NAOLocationHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    if (self.geofencingHandle == nil) {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    if (self.beaconReportingHandle == nil) {
        self.beaconReportingHandle = [[NAOBeaconReportingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    if (self.beaconProximityHandle == nil) {
        self.beaconProximityHandle = [[NAOBeaconProximityHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    if (self.analyticsHandle == nil) {
        self.analyticsHandle = [[NAOAnalyticsHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    
    [self resetErrorLabel];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    self.notificationManager = [[NotificationManager alloc] init];
    
    stopButtonState = NO;
    startButtonState = YES;
    [self.stopButton setEnabled:stopButtonState];
}

-(void) viewDidAppear:(BOOL)animated {
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self stop];
    }
}

- (void)stop {
    if (self.locationHandle != nil) {
        [self stopLoc];
    }
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle stop];
    }
    if (self.beaconReportingHandle != nil) {
        [self.beaconReportingHandle stop];
    }
    if (self.beaconProximityHandle != nil) {
        [self.beaconProximityHandle stop];
    }
    if (self.analyticsHandle != nil) {
        [self.analyticsHandle stop];
    }
}

- (IBAction)stubModeSwitch:(id)sender {
    if (self.locationHandle != nil) {
        [self stopLoc];
    }
    
    [self resetErrorLabel];
    
    if ([sender isOn]) {
        self.locationHandle = [[NAOLocationHandle alloc] initWithKey:@"emulator" delegate:self sensorsDelegate:self];
    } else {
        self.locationHandle = [[NAOLocationHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
        [self.locationHandle synchronizeData:self];
    }
    
    
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle stop];
    }
    
    if ([sender isOn]) {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:@"emulator" delegate:self sensorsDelegate:self];
    } else {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
        [self.geofencingHandle synchronizeData:self];
    }
}

- (IBAction)Start:(id)sender {
    [self enableStopButton];
    
    if (self.locationHandle != nil) {
        [self.locationHandle start];
    }
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle start];
    }
    if (self.beaconReportingHandle != nil) {
        [self.beaconReportingHandle start];
    }
    if (self.beaconProximityHandle != nil) {
        [self.beaconProximityHandle start];
    }
    if (self.analyticsHandle != nil) {
        [self.analyticsHandle start];
    }
}

- (IBAction)stop:(id)sender {
    [self enableStartButton];
    
    [self stop];
}

- (IBAction)SynchronyzeButtonClicked:(id)sender {
    [self waitForSynchro];
    
    if (self.locationHandle != nil) {
        [self.locationHandle synchronizeData:self];
    }
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle synchronizeData:self];
    }
    if (self.beaconReportingHandle != nil) {
        [self.beaconReportingHandle synchronizeData:self];
    }
    if (self.beaconProximityHandle != nil) {
        [self.beaconProximityHandle synchronizeData:self];
    }
    if (self.analyticsHandle != nil) {
        [self.analyticsHandle synchronizeData:self];
    }
}

- (void)stopLoc {
    [self.locationHandle stop];
    locationLabel.text = @"Location:longitude, latitude, altitude, heading";
    statusLabel.text = @"Status: status";
}

- (void)resetErrorLabel {
    [self.errorLabel setText:@""];
    [self.errorLabel setHidden:YES];
}

- (void)waitForSynchro {
    [self.startButton setEnabled:startButtonState];
    [self.stopButton setEnabled:stopButtonState];
    [self.synchronyzeButton setEnabled:NO];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void)dismissAfterSynchro {
    [self.startButton setEnabled:startButtonState];
    [self.stopButton setEnabled:stopButtonState];
    [self.synchronyzeButton setEnabled:YES];
    
    [spinner stopAnimating];
}

- (void)onEnterBackground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.locationHandle != nil) {
        [self.locationHandle setPowerMode:DBTPOWERMODE_LOW];
    }
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle setPowerMode:DBTPOWERMODE_LOW];
    }
    if (self.beaconReportingHandle != nil) {
        [self.beaconReportingHandle setPowerMode:DBTPOWERMODE_LOW];
    }
    if (self.beaconProximityHandle != nil) {
        [self.beaconProximityHandle setPowerMode:DBTPOWERMODE_LOW];
    }
    if (self.analyticsHandle != nil) {
        [self.analyticsHandle setPowerMode:DBTPOWERMODE_LOW];
    }
}

- (void)onEnterForeground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.locationHandle != nil) {
        [self.locationHandle setPowerMode:DBTPOWERMODE_HIGH];
    }
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle setPowerMode:DBTPOWERMODE_HIGH];
    }
    if (self.beaconReportingHandle != nil) {
        [self.beaconReportingHandle setPowerMode:DBTPOWERMODE_HIGH];
    }
    if (self.beaconProximityHandle != nil) {
        [self.beaconProximityHandle setPowerMode:DBTPOWERMODE_HIGH];
    }
    if (self.analyticsHandle != nil) {
        [self.analyticsHandle setPowerMode:DBTPOWERMODE_HIGH];
    }
}

- (void)enableStartButton {
    startButtonState = YES;
    stopButtonState = NO;
    [self.startButton setEnabled:startButtonState];
    [self.stopButton setEnabled:stopButtonState];
}

- (void)enableStopButton {
    startButtonState = NO;
    stopButtonState = YES;
    [self.startButton setEnabled:startButtonState];
    [self.stopButton setEnabled:stopButtonState];
}

#pragma mark - NAOBeaconProximityHandleDelegate

- (void) didRangeBeacon:(NSString*)beaconPublicID withRssi: (int) rssi {
    NSLog(@"NAODemoApp : %@ : %@ : beacon=%@ rssi=%d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), beaconPublicID, rssi);
}

- (void) didProximityChange:(DBTBEACONSTATE) proximity forBeacon:(NSString*) beaconPublicID {
    NSLog(@"NAODemoApp : %@ : %@ : proximity=%ld beacon=%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (long)proximity, beaconPublicID);
}

#pragma mark - NAOGeofencingHandleDelegate

- (void) didFireNAOAlert:(NaoAlert *)alert {
    NSString *alertText = [NSString stringWithFormat:@"name=%@ content=%@", alert.name, alert.content];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), alertText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), alertText]];
}

#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationLabel.text = [NSString stringWithFormat:@"Location: %.6f,%.6f,%.3f,%.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course];
    });
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];
    
    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
    NSString* statusString = [self stringFromStatus:status];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), statusString);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), statusString]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"statusString: %@", statusString];
    });
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
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), name]];
}

- (void) didExitSite:(NSString *)name {
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), name]];
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
    
    [self resetErrorLabel];
    [self dismissAfterSynchro];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];
    
    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
    [self dismissAfterSynchro];
}

#pragma mark - NAOSensorsDelegate

- (void)requiresBLEOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresWifiOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresLocationOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresCompassCalibration {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

//Optional
- (void)didCompassCalibrated {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
