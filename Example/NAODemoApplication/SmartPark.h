//
//  SmartParkViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 07/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAOLocationHandle.h"
#import "NAOLocationHandleDelegate.h"
#import "NAOGeofencingHandle.h"
#import "NAOGeofencingHandleDelegate.h"
#import "NAOSyncDelegate.h"
#import "NAOSensorsDelegate.h"
#import "NotificationManager.h"

#define SMART_PARK_MODE     @"SmartParkMode"
#define SMART_PARK_ON       @"SmartParkOn"
#define SMART_PARK_OFF      @"SmartParkOff"

#define LOCATION_COUNT_BEFORE_EXIT_CAR      5
#define PARKING_SLOT                        @"J3-E4"
#define START_MAP_ACTIVITY_KEY              @"startMapActivity"
#define PARKING_SLOT_KEY                    @"parkingSlot"

@interface SmartPark : NSObject<NAOLocationHandleDelegate, NAOGeofencingHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@property NAOLocationHandle* locationHandle;
@property NAOGeofencingHandle* geofencingHandle;
@property CLLocation *carLocation;

@property NotificationManager *notificationManager;

-(id)init;
-(void)startLocation;

@end
