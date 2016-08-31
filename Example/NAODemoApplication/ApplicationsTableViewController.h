//
//  ApplicationsTableViewController.h
//  NAODemoApplication
//
//  Created by Pole Star on 26/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import <UIKit/UIKit.h>

// You can use this default key: @"rnKk22vZHX5tKuKjQiyBg"
// #define DEFAULT_KEY_VALUE     @"YOUR_API_KEY"
#ifndef DEFAULT_KEY_VALUE
#  error "Please uncomment the line above, and set your API key (or use the provided key)."
#endif

@interface ApplicationsTableViewController : UITableViewController

@property (nonatomic) NSMutableArray* services;
@property (nonatomic) NSString* indoorLocationService;
@property (nonatomic) NSString* geofencingService;
@property (nonatomic) NSString* beaconProximityService;
@property (nonatomic) NSString* analyticsService;
@property (nonatomic) NSString* beaconReportingService;
@property (nonatomic) NSString* smartPark;
@property (nonatomic) NSString* allServices;

@end
