//
//  WakeServiceViewController.m
//  NAODemoApplication
//
//  Created by Pole Star on 07/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "WakeService.h"

#import "NAOServicesConfig.h"

#import "NaoContext.h"
#import "NAOServicesConfig.h"

@interface WakeService ()

@end

@implementation WakeService


+ (WakeService *)sharedInstance {
    static WakeService *wakeService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wakeService = [[self alloc] init];
    });
    return wakeService;
}

-(id)init {
    if ((self = [super init])) {
        self.notificationManager = [[NotificationManager alloc] init];
        self.apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    }
    return self;
}



#pragma mark - NAO services

-(void)startLocation {
    if (self.locationHandle == nil) {
        self.apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
        self.locationHandle = [[NAOLocationHandle alloc] initWithKey:self.apiKey delegate:self sensorsDelegate:self];
    }
    
    self.isRunning = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:WAKE_SERVICE_ON forKey:WAKE_SERVICE_MODE];
    [userDefaults synchronize];
    
    [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"StartLocation : %p", self]];
    [self.locationHandle start];
}

-(void)stopLocation {
    if (self.locationHandle != nil) {
        [[NAOServicesConfig getNaoContext] writeToLog:[NSString stringWithFormat:@"StopLocation : %p", self]];
        [self.locationHandle stop];
        
        self.isRunning = NO;
        
        self.locationHandle = nil;
    }
}

-(void)disableWakeServiceWakeUp {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:WAKE_SERVICE_OFF forKey:WAKE_SERVICE_MODE];
    [userDefaults synchronize];
}


-(void)setPowerMode:(DBTPOWERMODE)power {
    if (self.locationHandle != nil) {
        [self.locationHandle setPowerMode:power];
    }
}

#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    NSLog(@"NAODemoApp : didLocationChange : Location: %.6f,%.6f,%.3f,%.2f", location.coordinate.longitude, location.coordinate.latitude, location.altitude, location.course);
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSLog(@"Location Error: %@", message);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)]) {
        [self.delegate didFailWithError:message];
    }
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
}


- (NSString*) stringFromStatus:(DBTNAOFIXSTATUS) status {
    switch (status) {
        case DBTNAOFIXSTATUS_NAO_FIX_UNAVAILABLE:
            return @"FIX_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_FIX_AVAILABLE:
            return @"AVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_TEMPORARY_UNAVAILABLE:
            return @"TEMPORARY_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_OUT_OF_SERVICE:
            return @"OUT_OF_SERVICE";
            break;
        default:
            return @"UNKNOWN";
            break;
    }
}



- (void) didEnterSite:(NSString *)name {
    NSLog(@"NAODemoApp : WakeService : didEnterSite:%@", name);
    [self.notificationManager displayNotificationWithMessage:@"Enter Site"];

    //[self onEnterBeaconArea];
}

- (void) didExitSite:(NSString *)name {
    NSLog(@"NAODemoApp : WakeService : didExitSite:%@", name);
    [self.notificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"NAODemoApp : WakeService : didExitSite:%@", name]];
}


#pragma mark - NAOSensorsDelegate

- (void) requiresBLEOn {
    NSLog(@"NAODemoApp : WakeService : requiresBLEOn");
}

- (void) requiresWifiOn {
    NSLog(@"NAODemoApp : WakeService : requiresWifiOn");
}

- (void) requiresLocationOn {
    NSLog(@"NAODemoApp : WakeService : requiresLocationOn");
}

- (void) requiresCompassCalibration {
    NSLog(@"NAODemoApp : WakeService : requiresCompassCalibration");
}


#pragma mark - NAOSyncDelegate


- (void) didSynchronizationSuccess {
    NSLog(@"NAODemoApp : WakeService : didSynchronizationSuccess");
}

- (void) didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"didSynchronizationFailure : errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : WakeService : %@", errorText);
}


@end
