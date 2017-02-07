//
//  IndoorLocationViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import "IndoorLocationViewController.h"

@implementation IndoorLocationViewController {
    NSString *apiKey;
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
    int keyboardHeight;
}

@synthesize locationHandle;
@synthesize statusLabel, locationLabel;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
    locationLabel.text = @"Location:longitude, latitude, altitude, heading";
    statusLabel.text = @"Status: status";
    
    if (self.locationHandle == nil) {
        [self startWaiting];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationHandle = [[NAOLocationHandle alloc] initWithKey:apiKey delegate:self sensorsDelegate:self];
                [self performSelectorOnMainThread:@selector(stopWaiting) withObject:nil waitUntilDone:YES];
            });
        });
    }
    
    [self resetErrorLabel];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    self.notificationManager = [[NotificationManager alloc] init];
    
    stopButtonState = NO;
    startButtonState = YES;
    [self.stopButton setEnabled:stopButtonState];
    
    
    //KeyBoard size on a iPhone SE
    keyboardHeight = 253;
    self.delaiNotificationTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)dismissKeyboard {
    [self.delaiNotificationTextField resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification*)notification {
    // Animate the current view out of the way
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardHeight = keyboardFrameBeginRect.size.height;
}

-(void)keyboardWillHide:(NSNotification*)notification {
    [self animateTextField:self.selectedTextView up: NO];
}

-(void) viewDidAppear:(BOOL)animated {
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self stopLoc];
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
}

- (IBAction)Start:(id)sender {
    [self enableStopButton];
    
    [self.locationHandle start];
}

- (IBAction)stop:(id)sender {
    [self enableStartButton];
    
    [self stopLoc];
}

- (IBAction)SynchronyzeButtonClicked:(id)sender {
    [self startWaiting];
    [self.locationHandle synchronizeData:self];
}


- (IBAction)launchScheduledNotification:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self.delaiNotificationTextField.text];
    
    if (myNumber) {
        [self.notificationManager displayNotificationWithMessage:@"Scheduled notification" withTimer:myNumber];
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

- (void)startWaiting {
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:NO];
    [self.synchronyzeButton setEnabled:NO];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void)stopWaiting {
    [self.startButton setEnabled:startButtonState];
    [self.stopButton setEnabled:stopButtonState];
    [self.synchronyzeButton setEnabled:YES];
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

- (void)onEnterBackground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.locationHandle != nil) {
        [self.locationHandle setPowerMode:DBTPOWERMODE_LOW];
    }
}

- (void)onEnterForeground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.locationHandle != nil) {
        [self.locationHandle setPowerMode:DBTPOWERMODE_HIGH];
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

#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationLabel.text = [NSString stringWithFormat:@"Location: %.6f,%.6f,%.3f,%.2f, accuracy : %.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course, location.horizontalAccuracy];
    });
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    [self enableStartButton];
    
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
    [self stopWaiting];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];

    [self.errorLabel setText:errorText];
    [self.errorLabel setHidden:NO];
    [self stopWaiting];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.selectedTextView = textField;
    [self animateTextField: textField up: YES];
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [textField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    int botTF = textField.frame.origin.y + textField.frame.size.height;
    int heightLeft = self.view.frame.size.height - botTF;
    int movementDistance = keyboardHeight - heightLeft;
    
    if (movementDistance < 0) {
        movementDistance = 0;
    }
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
