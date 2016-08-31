//
//  SmartParkMainViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "SmartParkMainViewController.h"

@interface SmartParkMainViewController ()

@end

@implementation SmartParkMainViewController {
    NSString *apiKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SmartPark Main";
    self.notificationManager = [[NotificationManager alloc] init];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"Version : %@", [NAOServicesConfig getSoftwareVersion]]];
    
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    [self downloadNAOResources];
    [NAOServicesConfig enableOnSiteWakeUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadNAOResources {
    [self.synchronizationLabel setText:@"Synchronization state : Starts..."];
    [NAOServicesConfig synchronizeData:self apiKey:apiKey];
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    NSLog(@"SmartParkMain : didSynchronizationSuccess");
    [self.synchronizationLabel setText:@"Synchronization state : Synchronization Success"];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"SmartParkMain : didSynchronizationFailure : %@", errorText);
    [self.synchronizationLabel setText:@"Synchronization state : Failure"];
}


@end
