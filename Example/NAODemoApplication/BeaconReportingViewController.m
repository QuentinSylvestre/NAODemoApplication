//
//  BeaconReportingViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 15/02/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "BeaconReportingViewController.h"

@interface BeaconReportingViewController ()

@end

@implementation BeaconReportingViewController{
    NSString *apiKey;
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
}

- (void) viewWillAppear:(BOOL)animated {
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    if (self.beaconReportingHandle == nil) {
        self.beaconReportingHandle = [[NAOBeaconReportingHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
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

- (IBAction)StartBeaconReportingButtonClicked:(id)sender {
    [self enableStopButton];
    
    [self.beaconReportingHandle start];
}

- (IBAction)StopBeaconReportingButtonClicked:(id)sender {
    [self enableStartButton];
    
    [self stop];
}

- (IBAction)synchronyzeButtonClicked:(id)sender {
    [self waitForSynchro];
    [self.beaconReportingHandle synchronizeData:self];
}

- (void)stop {
    [self.beaconReportingHandle stop];
}

- (void)resetErrorLabel {
    [self.errorLabel setText:@""];
    [self.errorLabel setHidden:YES];
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

#pragma mark - NAOAnalyticsHandleDelegate

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    [self enableStartButton];
    
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
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


@end
