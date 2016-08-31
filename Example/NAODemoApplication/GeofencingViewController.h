//
//  GeofencingViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "NotificationManager.h"

@interface GeofencingViewController : UIViewController <NAOGeofencingHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastAlertLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronyzeButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property NAOGeofencingHandle* geofencingHandle;

@property NotificationManager *notificationManager;

@end
