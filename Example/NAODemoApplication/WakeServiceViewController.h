//
//  WakeServiceMainViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "WakeService.h"

#import "NotificationManager.h"

#define SERVICE_BUTTON_UNACTIVE_TITLE       @"Start Service"
#define SERVICE_BUTTON_SYNCHRONIZING_TITLE  @"Synchronizing"
#define SERVICE_BUTTON_ERROR_TITLE          @"ERROR"
#define SERVICE_BUTTON_ACTIVE_TITLE         @"Stop Service"

#define WAKEUP_BUTTON_ENABLE    @"Disable wake lock"
#define WAKEUP_BUTTON_DISABLE   @"Enable wake lock"


typedef enum serviceStateTypes
{
    SERVICE_UNACTIVE,
    SERVICE_ACTIVE,
    SERVICE_SYNCHRONIZING,
    SERVICE_ERROR
} ServiceSate;

typedef enum wakeUpStateTypes
{
    WAKEUP_ENABLE,
    WAKEUP_DISABLE
}WakeupState;


@interface WakeServiceViewController : UIViewController <NAOSyncDelegate, WakeServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *wakeLockButton;
@property (weak, nonatomic) IBOutlet UIButton *startServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *stopServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronyzeButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@property ServiceSate serviceState;
@property WakeupState wakeupState;
@property NSString *apiKey;
@property WakeService *wakeService;
@property NotificationManager *notificationManager;
@property NSString *wakeupMode;

@end
