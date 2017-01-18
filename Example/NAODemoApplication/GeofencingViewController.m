//
//  GeofencingViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import "GeofencingViewController.h"

@implementation GeofencingViewController {
    NSString *apiKey;
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
}

- (void) viewWillAppear:(BOOL)animated {
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (self.geofencingHandle == nil) {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    
    [self resetErrorLabel];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    self.notificationManager = [[NotificationManager alloc] init];
    
    stopButtonState = NO;
    startButtonState = YES;
    [self.stopButton setEnabled:stopButtonState];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self stop];
    }
}

- (void)stop {
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle stop];
    }
}

#pragma mark - View Events
- (IBAction)startGeofencingServiceButtonClicked:(id)sender {
    [self enableStopButton];
    
    [self.geofencingHandle start];
}


- (IBAction)StopGeofencingServiceButtonClicked:(id)sender {
    [self enableStartButton];
    
    [self stop];
}

- (IBAction)stubModeSwitch:(id)sender {
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle stop];
    }
    
    [self resetErrorLabel];
    
    if ([sender isOn]) {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:@"emulator" delegate:self sensorsDelegate:self];
    } else {
        self.geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
        [self.geofencingHandle synchronizeData:self];
    }
}
- (IBAction)synchronyzeButtonClicked:(id)sender {
    [self waitForSynchro];
    [self.geofencingHandle synchronizeData:self];
}

- (void)waitForSynchro {
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:NO];
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

- (void)resetErrorLabel {
    [self.errorLabel setText:@""];
    [self.errorLabel setHidden:YES];
}

- (void)onEnterBackground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle setPowerMode:DBTPOWERMODE_LOW];
    }
}

- (void)onEnterForeground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.geofencingHandle != nil) {
        [self.geofencingHandle setPowerMode:DBTPOWERMODE_HIGH];
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

#pragma mark - NAOGeofencingHandleDelegate

- (void) didFireNAOAlert:(NaoAlert *)alert {
    NSString *alertText = [NSString stringWithFormat:@"name=%@ content=%@", alert.name, alert.content];
    [self.lastAlertLabel setText:[NSString stringWithFormat:@"Last alert : %@", alertText]];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), alertText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), alertText]];
    
    NAOGeofenceData *regiondata = [self.geofencingHandle getGeofenceData:[alert.rules objectAtIndex:0].regionId];
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    [self enableStartButton];
    
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errCode, message];
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];
    
    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
}

#pragma mark - NAOSensorsDelegate

- (void) requiresBLEOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void) requiresWifiOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void) requiresLocationOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void) requiresCompassCalibration {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}


#pragma mark - NAOSyncDelegate


- (void) didSynchronizationSuccess {
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
    
    [self resetErrorLabel];
    [self dismissAfterSynchro];
}

- (void) didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];
    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
    [self dismissAfterSynchro];
}



@end
