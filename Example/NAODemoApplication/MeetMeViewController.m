//
//  MeetMeViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 27/11/2015.
//  Copyright © 2015 David FERNANDEZ. All rights reserved.
//

#import "MeetMeViewController.h"

@implementation MeetMeViewController

- (void) viewWillAppear:(BOOL)animated {
 
}

- (void) viewWillDisappear:(BOOL)animated {
 
}

- (void) startNAOLocationService {
    if (self.locationHandle== nil) {
        //self.locationHandle = [[NAOLocationHandle alloc] init];
    }
    
    //set the parameters of the location manager: key and delegate
  
}



- (void) didLocationChange:(CLLocation *)location {
    
}

- (void) didError:(int)errCode withMessage:(NSString *)message {
    
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
    
}

- (void) didLocationSynFailure:(NSString *)message {
    
}

- (void) didLocationSynStarted {
    
}

- (void) didLocationSynSucces:(NSString *)message {
    
}

- (void) didEnterSite:(NSString *)name {
    
}

- (void) didExitSite:(NSString *)name {
    
}



@end
