//
//  IndoorLocationViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "NotificationManager.h"


@interface IndoorLocationViewController : UIViewController<NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate, UITextFieldDelegate>

@property NAOLocationHandle* locationHandle;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronyzeButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextField *delaiNotificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *selectedTextView;


@property NotificationManager *notificationManager;

@end
