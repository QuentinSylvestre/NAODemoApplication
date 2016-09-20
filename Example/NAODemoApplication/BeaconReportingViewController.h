//
//  BeaconReportingViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 15/02/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "NotificationManager.h"


@interface BeaconReportingViewController : UIViewController <NAOSyncDelegate, NAOBeaconReportingHandleDelegate, NAOSensorsDelegate>

@property NAOBeaconReportingHandle *beaconReportingHandle;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronyzeButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property NotificationManager *notificationManager;

@end
