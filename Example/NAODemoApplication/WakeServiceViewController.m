//
//  WakeServiceMainViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "WakeServiceViewController.h"

#import "NAOServicesConfig.h"

@interface WakeServiceViewController ()

@end

@implementation WakeServiceViewController {
    UIActivityIndicatorView *spinner;
    BOOL startButtonState;
    BOOL stopButtonState;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WakeUpService Main";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    
    self.notificationManager = [[NotificationManager alloc] init];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    self.apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];

    self.wakeService = [WakeService sharedInstance];
    [self.wakeService setDelegate:self];
    
    stopButtonState = NO;
    startButtonState = YES;
    [self.stopServiceButton setEnabled:stopButtonState];
    
    [self checkWakeUpState];
    [self updateUIService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetErrorLabel];
}

- (IBAction)wakeLockTouch:(id)sender {
    switch (self.wakeupState) {
        case WAKEUP_ENABLE:
            [NAOServicesConfig disableOnSiteWakeUp];
            [self.wakeService disableWakeServiceWakeUp];
            break;
            
        case WAKEUP_DISABLE:
            [NAOServicesConfig enableOnSiteWakeUp];
            break;
            
        default:
            break;
    }
    
    [self checkWakeUpState];
    [self updateUIService];
}
- (IBAction)startServiceTouch:(id)sender {
    [self enableStopButton];
    [self.wakeService startLocation];
}
- (IBAction)stopServiceTouch:(id)sender {
    [self enableStartButton];
    [self stop];
}
- (IBAction)synchronizeTouch:(id)sender {
    [self waitForSynchro];
    [NAOServicesConfig synchronizeData:self apiKey:self.apiKey];
}

-(void)checkWakeUpState {
    self.wakeupMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"wake_up_notifier"];
    if (self.wakeupMode != nil && [self.wakeupMode isEqualToString:@"YES"]) {
        self.wakeupState = WAKEUP_ENABLE;
    } else {
        self.wakeupState = WAKEUP_DISABLE;
    }
}

- (void)updateUIService {
    switch (self.wakeupState) {
        case WAKEUP_ENABLE:
            [self setTitleToWakeLockButton:WAKEUP_BUTTON_ENABLE];
            break;
            
        case WAKEUP_DISABLE:
            [self setTitleToWakeLockButton:WAKEUP_BUTTON_DISABLE];
            break;
            
        default:
            break;
    }
}

- (void)setTitleToWakeLockButton:(NSString *)title{
    [self.wakeLockButton setTitle:title forState:UIControlStateNormal];
    [self.wakeLockButton setTitle:title forState:UIControlStateSelected];
    [self.wakeLockButton setTitle:title forState:UIControlStateHighlighted];
}

- (void)waitForSynchro {
    [self.startServiceButton setEnabled:NO];
    [self.stopServiceButton setEnabled:NO];
    [self.synchronyzeButton setEnabled:NO];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void)dismissAfterSynchro {
    [self.startServiceButton setEnabled:startButtonState];
    [self.stopServiceButton setEnabled:stopButtonState];
    [self.synchronyzeButton setEnabled:YES];
    
    [spinner stopAnimating];
}

- (void)enableStartButton {
    startButtonState = YES;
    stopButtonState = NO;
    [self.startServiceButton setEnabled:startButtonState];
    [self.stopServiceButton setEnabled:stopButtonState];
}

- (void)enableStopButton {
    startButtonState = NO;
    stopButtonState = YES;
    [self.startServiceButton setEnabled:startButtonState];
    [self.stopServiceButton setEnabled:stopButtonState];
}

- (void)stop {
    if (self.wakeService != nil) {
        [self.wakeService stopLocation];
    }
}

- (void)resetErrorLabel {
    [self.errorLabel setText:@""];
    [self.errorLabel setHidden:YES];
}

- (void)onEnterBackground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.wakeService != nil) {
        [self.wakeService setPowerMode:DBTPOWERMODE_LOW];
    }
}

- (void)onEnterForeground {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.wakeService != nil) {
        [self.wakeService setPowerMode:DBTPOWERMODE_HIGH];
    }
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
    [self dismissAfterSynchro];
    [self resetErrorLabel];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), errorText]];
    [self dismissAfterSynchro];
}

#pragma mark - WakeServiceDelegate

-(void) didFailWithError:(NSString *)message {
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ : %@", NSStringFromSelector(_cmd), message]];
    [self.errorLabel setText:message];
    [self.errorLabel setHidden:NO];
}

- (void)statusChanged {

}


@end
