//
//  ApplicationsTableViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 26/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import "ApplicationsTableViewController.h"
#import "IndoorLocationViewController.h"

@interface ApplicationsTableViewController ()

@end

@implementation ApplicationsTableViewController

@synthesize services;
@synthesize indoorLocationService, geofencingService, beaconProximityService, analyticsService, beaconReportingService, wakeService, allServices;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    services = [[NSMutableArray alloc] init];
    indoorLocationService = @"IndoorLocation";
    geofencingService = @"Geofencing";
    beaconProximityService = @"BeaconProximity";
    analyticsService = @"Analytics";
    beaconReportingService = @"BeaconReporting";
    wakeService = @"WakeService";
    allServices = @"AllServices";

    [services addObject:indoorLocationService];
    [services addObject:geofencingService];
    [services addObject:beaconProximityService];
    [services addObject:analyticsService];
    [services addObject:beaconReportingService];
    [services addObject:wakeService];
    [services addObject:allServices];
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    if (key == nil || [key isEqualToString:DEFAULT_KEY_VALUE] == NO) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:DEFAULT_KEY_VALUE forKey:@"apiKey"];
        [userDefaults synchronize];
    }
    
    self.title = @"Services";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeApiKeyAction:(id)sender {
    [self performSegueWithIdentifier:@"apiKeySelectionSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [services objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:indoorLocationService]) {
        NSLog(@"%@",indoorLocationService);
        [self performSegueWithIdentifier:@"IndoorLocationSegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:geofencingService]) {
        NSLog(@"%@",geofencingService);
        [self performSegueWithIdentifier:@"GeofencingSegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:beaconProximityService]) {
        NSLog(@"%@",beaconProximityService);
        [self performSegueWithIdentifier:@"BeaconProximitySegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:analyticsService]) {
        NSLog(@"%@",analyticsService);
        [self performSegueWithIdentifier:@"AnalyticsSegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:beaconReportingService]) {
        NSLog(@"%@",beaconReportingService);
        [self performSegueWithIdentifier:@"BeaconReportingSegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:wakeService]) {
        NSLog(@"%@",wakeService);
        [self performSegueWithIdentifier:@"WakeServiceMainSegue" sender:self];
    }
    
    if ([[self.services objectAtIndex:indexPath.row] isEqualToString:allServices]) {
        NSLog(@"%@",allServices);
        [self performSegueWithIdentifier:@"AllServicesSegue" sender:self];
    }
}

@end
