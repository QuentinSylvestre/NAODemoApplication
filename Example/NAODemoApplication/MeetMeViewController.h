//
//  MeetMeViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 David FERNANDEZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAOLocationHandleDelegate.h"
#import "NAOLocationHandle.h"

@interface MeetMeViewController : UITableViewController<NAOLocationHandleDelegate>

@property NAOLocationHandle* locationHandle;

@end
