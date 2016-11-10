//
//  WakeService.h
//  NAODemoApplication
//
//  Created by Pole Star on 07/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAOSDK/NAOSDK.h>
#import "NotificationManager.h"

#define WAKE_SERVICE_MODE     @"WakeUpMode"
#define WAKE_SERVICE_ON       @"WakeUpOn"
#define WAKE_SERVICE_OFF      @"WakeUpOff"

@protocol WakeServiceDelegate <NSObject>
- (void)statusChanged;
- (void)didFailWithError:(NSString *)message;
@end

@interface WakeService : NSObject<NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@property NAOLocationHandle* locationHandle;

@property NotificationManager *notificationManager;

@property id<WakeServiceDelegate> delegate;
@property NSString *apiKey;

@property bool isRunning;

+ (WakeService *)sharedInstance;

-(id)init;
-(void)startLocation;
-(void)stopLocation;
-(void)setPowerMode:(DBTPOWERMODE)power;
-(void)disableWakeServiceWakeUp;

@end
