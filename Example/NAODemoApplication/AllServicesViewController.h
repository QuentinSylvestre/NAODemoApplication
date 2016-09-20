//
//  AllServicesViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 23/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "NotificationManager.h"


@interface AllServicesViewController : UIViewController<NAOAnalyticsHandleDelegate, NAOBeaconProximityHandleDelegate, NAOBeaconReportingHandleDelegate, NAOGeofencingHandleDelegate, NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@property NAOLocationHandle* locationHandle;
@property NAOGeofencingHandle* geofencingHandle;
@property NAOBeaconReportingHandle *beaconReportingHandle;
@property NAOBeaconProximityHandle *beaconProximityHandle;
@property NAOAnalyticsHandle *analyticsHandle;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronyzeButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property NotificationManager *notificationManager;

@end
