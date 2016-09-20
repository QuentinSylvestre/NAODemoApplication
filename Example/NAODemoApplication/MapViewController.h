//
//  MapViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 08/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAOLocationHandle.h"
#import "NAOLocationHandleDelegate.h"
#import "NAOSyncDelegate.h"
#import "NAOSensorsDelegate.h"

#define KEY_PARKING_SLOT @"smartpark_parking_slot"

@interface MapViewController : UIViewController<NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@property NAOLocationHandle* locationHandle;
@property NSString *parkingSlot;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;

@end
