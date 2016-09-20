//
//  BeaconProximityViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 19/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "BeaconProximityViewController.h"

@interface BeaconProximityViewController ()

@end

@implementation BeaconProximityViewController {
    NSString *apiKey;
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
}

- (void) viewWillAppear:(BOOL)animated {
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    if (self.beaconProximityHandle == nil) {
        self.beaconProximityHandle = [[NAOBeaconProximityHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
    }
    
    [self resetErrorLabel];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    self.notificationManager = [[NotificationManager alloc] init];
    
    stopButtonState = NO;
    startButtonState = YES;
    [self.stopButton setEnabled:stopButtonState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartBeaconProximityServiceButtonClicked:(id)sender {
    [self enableStopButton];
    
    [self.beaconProximityHandle start];
}


- (IBAction)StopBeaconProximityServiceButtonClicked:(id)sender {
    [self enableStartButton];
    
    [self stop];
}

- (void) stop {
    [self.beaconProximityHandle stop];
}

- (void)resetErrorLabel {
    [self.errorLabel setText:@""];
    [self.errorLabel setHidden:YES];
}

- (IBAction)synchronyzeButtonClicked:(id)sender {
    [self waitForSynchro];
    [self.beaconProximityHandle synchronizeData:self];
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


#pragma mark - NAOBeaconProximityHandleDelegate

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString*)message {
    [self enableStartButton];
    
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ :%@", NSStringFromSelector(_cmd), errorText]];
    
    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
}

- (void) didRangeBeacon:(NSString*)beaconPublicID withRssi: (int) rssi {
    NSLog(@"NAODemoApp : %@ : %@ : beacon=%@ rssi=%d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), beaconPublicID, rssi);
}

- (void) didProximityChange:(DBTBEACONSTATE) proximity forBeacon:(NSString*) beaconPublicID {
    NSLog(@"NAODemoApp : %@ : %@ : proximity=%ld beacon=%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (long)proximity, beaconPublicID);
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

@end
