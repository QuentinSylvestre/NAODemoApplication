//
//  SmartParkMainViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAOSyncDelegate.h"
#import "NAOLocationHandle.h"
#import "NotificationManager.h"

@interface SmartParkMainViewController : UIViewController <NAOSyncDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *synchronizationLabel;

@property NotificationManager *notificationManager;

@end
